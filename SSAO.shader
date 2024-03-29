﻿Shader "Custom/SSAO" {
	Properties
	{
		_MainTex ("", 2D) = "white" {}
		_ScreenRT0 ("", 2D) = "white" {}
		_ScreenRT1 ("", 2D) = "white" {}
	}

		CGINCLUDE
	
		#pragma fragmentoption ARB_precision_hint_fastest
		#pragma exclude_renderers flash
		#pragma target 3.0
		#include "UnityCG.cginc"

		ENDCG

	SubShader
	{
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }


		// --------------------------------------------------------------------------------
		// Clear (white)

		Pass // (0)
		{
			CGPROGRAM

				#pragma vertex vert_ssao
				#pragma fragment frag_ssao


				
	sampler2D _MainTex;
	half4 _MainTex_TexelSize;
	sampler2D _SSAOTex;

	sampler2D_float _ScreenRT0;
	sampler2D_float _CameraDepthTexture;
	sampler2D_float _ScreenRT1;
	sampler2D_float _CameraDepthNormalsTexture;
		
	half4x4 _InverseViewProject;
	half4x4 _CameraModelView;

	sampler2D _NoiseTex;
	half4 _Params1; // Noise Size / Sample Radius / Intensity / Distance
	half4 _Params2; // Bias / Luminosity Contribution / Distance Cutoff / Cutoff Falloff
	half4 _OcclusionColor;

	half2 _Direction;
	half _BilateralThreshold;

	#define _NoiseSize			_Params1.x
	#define _SampleRadius		_Params1.y
	#define _Intensity			_Params1.z
	#define _Distance			_Params1.w
	#define _Bias				_Params2.x
	#define _LumContrib			_Params2.y
	#define _DistanceCutoff		_Params2.z
	#define _CutoffFalloff		_Params2.w

	// --------------------------------------------------------------------------------
	// Functions

	inline half invlerp(half from, half to, half value)
	{
		return (value - from) / (to - from);
	}

	inline half getDepth(half2 uv)
	{
		return tex2D(_ScreenRT0,uv);
	}

	inline half3 getWSPosition(half2 uv, half depth)
	{
		// Compute world space position from the view depth
		half4 pos = half4(uv.xy * 2.0 - 1.0, depth, 1.0);
		half4 ray = mul(_InverseViewProject, pos);
		return ray.xyz / ray.w;
	}

	inline half3 getVSNormal(half2 uv)
    {
		return fixed3(tex2D(_ScreenRT1,uv).xyz);
    }

	inline half3 getWSNormal(half2 uv)
	{
		// Get the view space normal and convert it to world space
		half3 vsnormal = getVSNormal(uv);
		half3 wsnormal = mul((half3x3)_CameraModelView, vsnormal);
		return wsnormal;
	}

	inline half compare(half3 n1, half3 n2)
    {
        return pow((dot(n1, n2) + 1.0) * 0.5, _BilateralThreshold);
    }

	inline half calcAO(half2 tcoord, half2 uv, half3 p, half3 cnorm)
	{
		half2 t = tcoord + uv;
		half depth = getDepth(t);
		half3 diff = getWSPosition(t, depth) - p;
		half3 v = normalize(diff);
		half d = length(diff) * _Distance;
		return max(0.0, dot(cnorm, v) - _Bias) * (1.0 / (1.0 + d)) * _Intensity;
	}

	half ssao(half2 uv)
	{
		half2 CROSS[4] = { half2(1.0, 0.0), half2(-1.0, 0.0), half2(0.0, 1.0), half2(0.0, -1.0) };
			
		half depth = getDepth(uv);
		half eyeDepth = LinearEyeDepth(depth);

		half3 position = getWSPosition(uv, depth);
		half3 normal = getWSNormal(uv);

		#if defined(SAMPLE_NOISE)
		half2 random = normalize(tex2D(_NoiseTex, _ScreenParams.xy * uv / _NoiseSize).rg * 2.0 - 1.0);
		#endif

		half radius = max(_SampleRadius / eyeDepth, 0.005);
		clip(_DistanceCutoff - eyeDepth); // Skip out of range pixels
		half ao = 0.0;

		// Sampling
		for (int j = 0; j < 4; j++)
		{
			half2 coord1;

			#if defined(SAMPLE_NOISE)
			coord1 = reflect(CROSS[j], random) * radius;
			#else
			coord1 = CROSS[j] * radius;
			#endif

			#if !SAMPLES_VERY_LOW
			half2 coord2 = coord1 * 0.707;
			coord2 = half2(coord2.x - coord2.y, coord2.x + coord2.y);
			#endif
  
			#if SAMPLES_ULTRA			// 20
			ao += calcAO(uv, coord1 * 0.20, position, normal);
			ao += calcAO(uv, coord2 * 0.40, position, normal);
			ao += calcAO(uv, coord1 * 0.60, position, normal);
			ao += calcAO(uv, coord2 * 0.80, position, normal);
			ao += calcAO(uv, coord1, position, normal);
			#elif SAMPLES_HIGH			// 16
			ao += calcAO(uv, coord1 * 0.25, position, normal);
			ao += calcAO(uv, coord2 * 0.50, position, normal);
			ao += calcAO(uv, coord1 * 0.75, position, normal);
			ao += calcAO(uv, coord2, position, normal);
			#elif SAMPLES_MEDIUM		// 12
			ao += calcAO(uv, coord1 * 0.30, position, normal);
			ao += calcAO(uv, coord2 * 0.60, position, normal);
			ao += calcAO(uv, coord1 * 0.90, position, normal);
			#elif SAMPLES_LOW			// 8
			ao += calcAO(uv, coord1 * 0.30, position, normal);
			ao += calcAO(uv, coord2 * 0.80, position, normal);
			#else	// 4
			ao += calcAO(uv, coord1 * 0.50, position, normal);
			#endif
		}
		
		#if SAMPLES_ULTRA
		ao /= 20.0;
		#elif SAMPLES_HIGH
		ao /= 16.0;
		#elif SAMPLES_MEDIUM
		ao /= 12.0;
		#elif SAMPLES_LOW
		ao /= 8.0;
		#else
		ao /= 4.0;
		#endif

		// Distance cutoff
		ao = lerp(1.0 - ao, 1.0, saturate(invlerp(_DistanceCutoff - _CutoffFalloff, _DistanceCutoff, eyeDepth)));

		return ao;
	}


				
				struct v_data 
				{
					float4 pos : SV_POSITION; 
					float2 uv : TEXCOORD0;
				};

				v_data vert_ssao(appdata_img v)
				{
					v_data o;
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv = v.texcoord;        	        	
					return o; 
				}
				
	half4 getAOColor(half ao, half2 uv)
	{
		#if defined(LIGHTING_CONTRIBUTION)

		// Luminance for the current pixel, used to reduce the AO amount in bright areas
		// Could potentially be replaced by the lighting pass in Deferred...
		half3 color = tex2D(_MainTex, uv).rgb;
		half luminance = dot(color, half3(0.2126, 0.7152, 0.0722));
		half aofinal = lerp(ao, 1.0, luminance * _LumContrib);
		return half4(aofinal.xxx, 1.0);

		#else

		return half4(ao.xxx, 1.0);

		#endif
	}
				float4 frag_ssao(v_data i) : SV_Target
				{
					return saturate(getAOColor(ssao(i.uv), i.uv) + _OcclusionColor);
				}

			ENDCG
		}

		// --------------------------------------------------------------------------------
		// 1-None 2-Noise 3-Lighting 4-both 5-Gaussian Blur 6-Bilateral Blur 7-Composite

		
	}
}
