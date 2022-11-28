Shader "PS Vita/Uber/Post FX Vita Optimized" 
{
	Properties 
	{
		[Header(_______________________________________________________________________________)]
		[Header(Post FX Uber Vita Optimized)]
		[Header(_______________________________________________________________________________)]
		[Header(Main Input)]
		[Space]
		[NoScaleOffset]_ScreenRT0 ("Color & Z Depth Buffer [RT0]", 2D) = "white" {}
		[NoScaleOffset]_ScreenRT1 ("Normals & Y Depth Buffer [RT1]", 2D) = "white" {}
		[Header(_______________________________________________________________________________)]
	
		[Header(Outline)]
		[Toggle]_OUTLINE ("Enable Outline", Float)=1
		[Toggle]_TINT_OUTLINE ("Tint Outline", Float)=1
		[HDR]_OutlineColor("Outline Color", Color)=(1,1,1,1)
		_OutlineSampleDistance("Sample Distance", Float)=1
		_FadeOriginalContributionToColor("Fade Original Contribution To Color", Range(0,1))=1
		_ColorToFade("Color To Fade To", Color)=(1,1,1,1)
		_OutlineNormalContribution("Normals Contribution Threshold", Range(0,5))=2
		
		[Header(_______________________________________________________________________________)]
		
		[Header(Fullscreen Distortion)]
		[Space]
		[Toggle] _SCREEN_DISTORTION ("Screen Distortion",Float)=0
		_DistortionTex ("Distortion Map",2D)= "white" {}
		_DistortionAmount ("Distortion Amount",Float)=0
		_DistortionSpeed ("Distortion Speed",Float)=0
		[Header(_______________________________________________________________________________)]
		
		[Header(Blur and Depth Of Field)]
		[Space]
		[Toggle] _BLUR("Blur",Float)=0
		_BlurRadius("Blur Radius", Range(0,2))=2
		[Toggle]_DOF("Use as Depth of Field", Float)=1
		//_DoFFocalPoint("Depth of Field Focal Point", Float)=1
		_DoFFocalPoint("Depth of Field Focal Point", Range(0,1))=1
		[Header(_______________________________________________________________________________)]
		
		[Header(Image Sharpening)]
		[Space]
		[Toggle] _SHARPEN("Image Sharpening",Float)=0
		_Sharpen("Sharpen",Range(0,1))=1
		[Header(_______________________________________________________________________________)]
		
		
		[Header(Sun Shaft and Athmospheric Fog)]
		[Space]
		[Toggle] _SUN_SHAFTS_AND_ATMOS_FOG("Sun Shafts & Fog",Float)=0
		_SunShaftTightness("Sun Shaft Tightness", Float)=2
		[HDR]_SunShaftColor("Sun Shaft Color", Color)=(1,1,1,1)
		[HDR]_FogColor("Fog Color", Color)=(1,1,1,1)
		[Header(Height Fog)]
		[Space]
		[Toggle]_HEIGHT_FOG ("Height Fog", Float)=0
		_HeightFogThickness("Height Fog Thickness", Float)=1
		_HeightFogHeight("Height Fog Height", Float)=1
		[Toggle]_HEIGHT_FOG_COLOR("Make Height Fog use a different Color", Float)=0
		[HDR]_HeightFogColor("Height Fog Color", Color)=(1,1,1,1)
		[Header(_______________________________________________________________________________)]
		
		[Header(Color Grading)]
		[Space]
		[KeywordEnum(Off,On)]_COLOR_GRADING ("Color Graing", Float)=0
		[NoScaleOffset]_CGLookupTex ("Lookup Texture", 2D) = "white" {}
		[Header(_______________________________________________________________________________)]
		
		[Header(Chromatic Aberration)]
		[Space]
		[Toggle] _CHROMATIC_ABERRATION("Chromatic Aberration",Float)=0
		_ChromAbDistortion("Chromatic Aberration Distortion", Range(0,2))=0.5
		_ChromAbRedX("Red Channel X Displacement", Range(0,1))=1
		_ChromAbRedY("Red Channel Y Displacement", Range(0,1))=1
		_ChromAbGreenX("Green Channel X Displacement", Range(0,1))=1
		_ChromAbGreenY("Green Channel Y Displacement", Range(0,1))=1
		_ChromAbBlueX("Blue Channel X Displacement", Range(0,1))=1
		_ChromAbBlueY("Blue Channel Y Displacement", Range(0,1))=1
		[Header(_______________________________________________________________________________)]

		[Header(Vignette)]
		[Space]
		[KeywordEnum(Off,Simple,Tinted)]_VIGNETTE ("Vignette", Float)=0
		_VignetteSize("Vignette Size",Range(0,2))=0.5
		_VignetteColor("Vignette Color",Color)=(1,0,0,1)
		[Header(_______________________________________________________________________________)]
		
		[Header(Film Grain)]
		[Space]
		[KeywordEnum(Off,Additive,Multiplicative)]_FILM_GRAIN ("Film Grain", Float)=0
		_GrainTex ("Film Grain Texture", 2D) = "white" {}
		_GrainAmount ("Film Grain Amount", Range(0,1))=0
		[Header(_______________________________________________________________________________)]

		[Header(Image Tinting)]
		[Space]
		[KeywordEnum(Off,Additive,Multiplicative)]_IMAGE_TINTING ("Image Tint", Float)=0
		[HDR] _ImageTint ("Tinting Color", Color) = (1,1,1,1)
		[Header(_______________________________________________________________________________)]
		
		[Header(Brightness and Contrast)]
		[Space]
		[KeywordEnum(Off,Brightness,Contrast,Brightness and Contrast)]_USE_BRIGHTNESS_CONTRAST ("Brightness and Contrast", Float)=0
		_Brightness ("Brightness", Float)=0
		_Contrast ("Contrast", Float)=0
		[Header(_______________________________________________________________________________)]
		
		[Header(Color Space Conversion)]
		[Space]
		[KeywordEnum(Off,Gamma To Linear,Linear To Gamma)]_COLOR_SPACE_CONVERSION ("Color Space Conversion", Float)=0
		[Header(_______________________________________________________________________________)]
		
		[Header(Debug)]
		[Space]
		[KeywordEnum(None,Depth Of Field,Sun Shafts, Outline,Alpha , Y Depth, Z Depth)]_DEBUG ("Debug View", Float)=0
	
		
	}
	SubShader 
	{
	       Blend SrcAlpha OneMinusSrcAlpha
		Pass
		{
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma shader_feature _BLUR_ON
		#pragma shader_feature _DOF_ON
		#pragma shader_feature _POST_PROCESSING_ON
		#pragma shader_feature _SCREEN_DISTORTION_ON
		#pragma shader_feature _SHARPEN_ON
		#pragma shader_feature _COLOR_GRADING_ON
		#pragma shader_feature _SUN_SHAFTS_AND_ATMOS_FOG_ON
		#pragma shader_feature _HEIGHT_FOG_ON
		#pragma shader_feature _CHROMATIC_ABERRATION_ON

		#pragma shader_feature _FILM_GRAIN_OFF _FILM_GRAIN_ADDITIVE _FILM_GRAIN_MULTIPLICATIVE
		#pragma shader_feature _VIGNETTE_OFF _VIGNETTE_SIMPLE _VIGNETTE_TINTED
		#pragma shader_feature _IMAGE_TINTING_OFF _IMAGE_TINTING_ADDITIVE _IMAGE_TINTING_MULTIPLICATIVE _IMAGE_TINTING_LOOKUP
		#pragma shader_feature _COLOR_SPACE_CONVERSION_OFF _COLOR_SPACE_CONVERSION_GAMMA_TO_LINEAR _COLOR_SPACE_CONVERSION_LINEAR_TO_GAMMA
		#pragma shader_feature _USE_BRIGHTNESS_CONTRAST_OFF _USE_BRIGHTNESS_CONTRAST_BRIGHTNESS _USE_BRIGHTNESS_CONTRAST_CONTRAST _USE_BRIGHTNESS_CONTRAST_BRIGHTNESS_AND_CONTRAST
		#pragma shader_feature _DEBUG_NONE _DEBUG_ALPHA _DEBUG_DEPTH_OF_FIELD _DEBUG_Y_DEPTH _DEBUG_SUN_SHAFTS _DEBUG_Z_DEPTH
		#include "UnityCG.cginc"
		uniform sampler2D _ScreenRT0; uniform fixed4 _ScreenRT0_TexelSize;
		uniform sampler2D _ScreenRT1;
		uniform fixed4x4 _CurrentToPreviousViewProjectionMatrix;
		uniform fixed _MotionBlurSamples;
		uniform fixed _BlurRadius; uniform fixed _DoFFocalPoint;
		uniform fixed _ChromAbDistortion;
		uniform fixed _Sharpen;
		uniform fixed4 _FogColor; uniform fixed4 _SunShaftColor; uniform fixed _SunShaftTightness;
		uniform fixed _HeightFogThickness;uniform fixed _HeightFogHeight;
		uniform fixed4 _HeightFogColor;
		uniform sampler2D _CGLookupTex;
		uniform fixed _ChromAbRedX; uniform fixed _ChromAbRedY; uniform fixed _ChromAbGreenX;
		uniform fixed _ChromAbGreenY; uniform fixed _ChromAbBlueX; uniform fixed _ChromAbBlueY;
		uniform sampler2D _GrainTex; uniform fixed4 _GrainTex_ST;  uniform fixed _GrainAmount;
		uniform sampler2D _DistortionTex; uniform fixed4 _DistortionTex_ST; 
		uniform fixed _DistortionAmount; uniform fixed _DistortionSpeed;
		uniform fixed _VignetteSize; uniform fixed4 _VignetteColor; 
		uniform fixed4 _ImageTint;
		uniform fixed _Brightness; uniform fixed _Contrast;
		
		fixed3 Grayscale(fixed3 inputColor)
		//fixed Grayscale(fixed3 inputColor)
		{
		    fixed gray = (inputColor.r + inputColor.g + inputColor.b) / 3;
		    return fixed3(gray, gray, gray);
		    //return gray;
		}
		struct v2f 
		{
		fixed4 pos : SV_POSITION;
		fixed2 uv : TEXCOORD0;
		fixed2 dist : TEXCOORD1;
		fixed2 tileUV : TEXCOORD2;
		fixed2 distortionTiledUV : TEXCOORD3;
		fixed2 uv0CA : TEXCOORD4;
		fixed2 uv1CA : TEXCOORD5;
		fixed2 uv2CA : TEXCOORD6;
		fixed4 sunShaft : TEXCOORD7;
		fixed4 heightFog : TEXCOORD8;
		fixed4 sharpenUV  : TEXCOORD9;
		};
		half3 AdjustContrast(half3 color, half contrast) 
		{
			return saturate(lerp(half3(0.5, 0.5, 0.5), color, contrast));
		}

		v2f vert (appdata_img v)
		{
		v2f o;
		o.uv = v.texcoord;
		o.pos = UnityObjectToClipPos(v.vertex);

		#if _FILM_GRAIN_ADDITIVE || _FILM_GRAIN_MULTIPLICATIVE
		o.tileUV = TRANSFORM_TEX(v.texcoord, _GrainTex);
		#endif

		#if _SCREEN_DISTORTION_ON
		o.distortionTiledUV = TRANSFORM_TEX(v.texcoord, _DistortionTex);
		#endif


		#if _SHARPEN_ON
		o.sharpenUV = fixed4(o.uv - _ScreenRT0_TexelSize.xy, o.uv + _ScreenRT0_TexelSize.xy);
		#endif
		
		#if _HEIGHT_FOG_ON || _SUN_SHAFTS_AND_ATMOS_FOG_ON
		fixed3 viewDir = normalize(-WorldSpaceViewDir(v.vertex));
		//fixed3 viewDir = mul((fixed3x3)unity_CameraToWorld, fixed3(0,0,1));
		fixed3 lightDir = normalize(_WorldSpaceLightPos0);
		#endif

		#if _HEIGHT_FOG_ON
		//fixed heightFogThickness = dot(1-_HeightFogHeight*2-.5,lightDir);
		fixed heightFogThickness = max(dot(viewDir.y + 1-_HeightFogHeight,lightDir),0.0);
		o.heightFog = lerp(fixed4 (1,1,1,1),_FogColor, heightFogThickness);
		//o.heightFog = lerp(fixed4 (1,1,1,1), _FogColor, pow(heightFogThickness,_HeightFogThickness));
		#endif

		#if _SUN_SHAFTS_AND_ATMOS_FOG_ON
		fixed sunShaftSize = dot(viewDir,lightDir);
		o.sunShaft = lerp(_FogColor, _SunShaftColor, pow(sunShaftSize, _SunShaftTightness));
		#endif

		#if _VIGNETTE_SIMPLE || _VIGNETTE_TINTED
		o.dist = (o.uv - 0.5) * 1.25;
		o.dist.x = 1 - dot(o.dist, o.dist) * _VignetteSize;
		#endif
		
		#if _CHROMATIC_ABERRATION_ON
		o.uv0CA.x = v.texcoord.x + _ChromAbRedX * _ScreenRT0_TexelSize.x;
		o.uv0CA.y = v.texcoord.y + _ChromAbRedY * _ScreenRT0_TexelSize.y;
		o.uv1CA.x = v.texcoord.x + _ChromAbGreenX * _ScreenRT0_TexelSize.x - 0.5h;
		o.uv1CA.y = v.texcoord.y + _ChromAbGreenY * _ScreenRT0_TexelSize.y - 0.5h;
		o.uv2CA.x = v.texcoord.x + _ChromAbBlueX * _ScreenRT0_TexelSize.x - 0.5h;
		o.uv2CA.y = v.texcoord.y + _ChromAbBlueY * _ScreenRT0_TexelSize.y - 0.5h;
		#endif

		return o;
		}
		fixed4 frag (v2f i) : COLOR
		{
		float4 normalsDepthBuffer = tex2D(_ScreenRT1, i.uv);
		fixed yDepth = normalsDepthBuffer.z;
		fixed zDepth = normalsDepthBuffer.w;
		fixed2 normals = normalsDepthBuffer.xy;
		fixed alpha = 1;
		#if !_SCREEN_DISTORTION_ON && !_SHARPEN_ON
		fixed3 screen = 1;
		//fixed zDepth = depth.z;
		#endif
		//fixed3 screen = tex2D(_ScreenRT0, i.uv);

		//Motion Blur
		//float4 projPos;
		//projPos.xy = i.uv.xy * 2.0 - 1.0;
		//projPos.z = zDepth;
		//projPos.w = 1.0f;
		//float4 previous = mul(_CurrentToPreviousViewProjectionMatrix, projPos);
		//previous /= previous.w;
		//float2 blurVec = (previous.xy - projPos.xy) * 0.5f;
		//float2 v = blurVec / _MotionBlurSamples;
		//for(int j = 1; j < _MotionBlurSamples; ++j)
		//{
		//    float2 uv = i.uv + (v * zDepth * j);
		//    screen += tex2D(_ScreenRT0, uv).rgb;
		//}
		//screen /= _MotionBlurSamples;
		#if _SCREEN_DISTORTION_ON
		fixed2 distUV = i.distortionTiledUV + _Time.x * _DistortionSpeed;
		fixed2 distortionTex = tex2D(_DistortionTex, distUV).xy;
		distortionTex = ((distortionTex*2) - 1) * _DistortionAmount*.1;
			#if !_BLUR_ON
			fixed3 screen = 1;
			//.fixed zDepth = frameBuffer.a;
			#endif
		#endif
		
		#if _SHARPEN_OFF
		#elif _SHARPEN_ON
		fixed3 unsharpened = screen;
		screen = tex2D(_ScreenRT0, i.uv).rgb * (1+(3.2 * _Sharpen));
		screen -= tex2D(_ScreenRT0, i.sharpenUV.xy).rgb* (.8 * _Sharpen);
		screen -= tex2D(_ScreenRT0, i.sharpenUV.xw).rgb* (.8 * _Sharpen);
		screen -= tex2D(_ScreenRT0, i.sharpenUV.zy).rgb* (.8 * _Sharpen);
		screen -= tex2D(_ScreenRT0, i.sharpenUV.zw).rgb* (.8 * _Sharpen);
		screen = lerp(screen,unsharpened,.5);
		#endif

		#if _BLUR_ON
		fixed2 direction = fixed2(1.0, 0.0);
		fixed2 blurDisplacementX = fixed2(1.3846153846, 1.3846153846) * direction * _BlurRadius;
		fixed2 blurDisplacementY = fixed2(3.2307692308, 3.2307692308) * direction * _BlurRadius;
		fixed2 texelSize = _ScreenRT0_TexelSize.zw; //z = texture width, w = texture height
			fixed3 dofFocused = screen;
			screen = fixed3(0.0, 0.0, 0.0);
			#if !_SCREEN_DISTORTION_ON
			screen += tex2D(_ScreenRT0, i.uv).rgb * 0.2270270270;
			screen += tex2D(_ScreenRT0, i.uv + (blurDisplacementX / texelSize)).rgb * 0.3162162162;
			screen += tex2D(_ScreenRT0, i.uv - (blurDisplacementX / texelSize)).rgb * 0.3162162162;
			screen += tex2D(_ScreenRT0, i.uv + (blurDisplacementY / texelSize)).rgb * 0.0702702703;
			screen += tex2D(_ScreenRT0, i.uv - (blurDisplacementY / texelSize)).rgb * 0.0702702703;
				//DoF
				#if _DOF_ON
				screen = lerp(dofFocused,screen,pow(zDepth,(_DoFFocalPoint*10)));
				#endif
			#else
			screen += tex2D(_ScreenRT0, i.uv+ distortionTex).rgb * 0.2270270270;
			screen += tex2D(_ScreenRT0, i.uv + (blurDisplacementX / texelSize)+distortionTex).rgb * 0.3162162162;
			screen += tex2D(_ScreenRT0, i.uv - (blurDisplacementX / texelSize)+distortionTex).rgb * 0.3162162162;
			screen += tex2D(_ScreenRT0, i.uv + (blurDisplacementY / texelSize)+distortionTex).rgb * 0.0702702703;
			screen += tex2D(_ScreenRT0, i.uv - (blurDisplacementY / texelSize)+distortionTex).rgb * 0.0702702703;
			#endif
		#endif
		
		
		#if _HEIGHT_FOG_OFF
		#elif _HEIGHT_FOG_ON
		//screen.rgb += (yDepth*_HeightFogThickColor);
		//screen.rgb +=(i.heightFog.rgb*yDepth);
		screen.rgb +=(i.heightFog.rgb*yDepth);
		#endif

		#if _SUN_SHAFTS_AND_ATMOS_FOG_OFF
		#elif _SUN_SHAFTS_AND_ATMOS_FOG_ON
		screen.rgb += (i.sunShaft.rgb*zDepth);
		#endif

		#if _COLOR_GRADING_OFF
		#elif _COLOR_GRADING_ON
		screen.r = tex2D(_CGLookupTex, screen.rr).r;
		screen.g = tex2D(_CGLookupTex, screen.gg).g;
		screen.b = tex2D(_CGLookupTex, screen.bb).b;
		#endif

		#if _CHROMATIC_ABERRATION_OFF
		#elif _CHROMATIC_ABERRATION_ON
			
			#if _BLUR_OFF
			#elif _BLUR_ON
			fixed3 blurscreen = screen;
			#endif

			fixed sqUVA = i.uv1CA.x * i.uv1CA.x + i.uv1CA.y * i.uv1CA.y;
			fixed2 uvA = (1.0h + sqUVA * (0.15h + _ChromAbDistortion * sqrt(sqUVA))) * i.uv1CA;
			fixed sqUVB = i.uv2CA.x * i.uv2CA.x + i.uv2CA.y * i.uv2CA.y;
			fixed2 uvB = (1.0h + sqUVB * (0.15h + 1.5h*_ChromAbDistortion * sqrt(sqUVB))) * i.uv2CA;
			
			#if _SUN_SHAFTS_AND_ATMOS_FOG_OFF
			#elif _SUN_SHAFTS_AND_ATMOS_FOG_ON
			fixed3 sunShaftScreen = screen;
			#endif

			#if _SCREEN_DISTORTION_OFF
			screen = fixed3(0.0h,0.0h,0.0h);
			screen.r = tex2D(_ScreenRT0, i.uv0CA).r;
			screen.g = tex2D(_ScreenRT0, uvA).g;
			screen.b = tex2D(_ScreenRT0, uvB).b;
			#elif _SCREEN_DISTORTION_ON
			screen = fixed4(0.0h,0.0h,0.0h,1.0h);
			screen.r = tex2D(_ScreenRT0, i.uv0CA+distortionTex).r;
			screen.g = tex2D(_ScreenRT0, uvA+distortionTex).g;
			screen.b = tex2D(_ScreenRT0, uvB+distortionTex).b;
				#if _BLUR_OFF
				#elif _BLUR_ON
				fixed3 distBlurScreen = screen;
				distBlurScreen = fixed4(0.0h,0.0h,0.0h,1.0h);
				distBlurScreen += tex2D(_ScreenRT0, i.uv+ distortionTex).rgb * 0.2270270270;
				distBlurScreen += tex2D(_ScreenRT0, i.uv + (blurDisplacementX / texelSize)+distortionTex).rgb * 0.3162162162;
				distBlurScreen += tex2D(_ScreenRT0, i.uv - (blurDisplacementX / texelSize)+distortionTex).rgb * 0.3162162162;
				distBlurScreen += tex2D(_ScreenRT0, i.uv + (blurDisplacementY / texelSize)+distortionTex).rgb * 0.0702702703;
				distBlurScreen += tex2D(_ScreenRT0, i.uv - (blurDisplacementY / texelSize)+distortionTex).rgb * 0.0702702703;
				screen = lerp(distBlurScreen, screen,.5);
				#endif
			#endif
			#if _BLUR_OFF
			#elif _BLUR_ON
			screen = lerp(screen, blurscreen, .5);
			#endif

			#if _SUN_SHAFTS_AND_ATMOS_FOG_OFF
			#elif _SUN_SHAFTS_AND_ATMOS_FOG_ON
			screen = lerp(sunShaftScreen, screen, .5);
			#endif
		#endif
		#if _VIGNETTE_SIMPLE
		screen *=i.dist.x;
		#elif _VIGNETTE_TINTED
		fixed4 colorVignette = 1-saturate(1-i.dist.x *1-_VignetteColor);
		screen *= colorVignette;
		//failed attempt to blend
		//screen = lerp(screen,normalize(colorVignette+(1-i.dist.x*2)),.5);
		#endif
		
		#if _FILM_GRAIN_OFF
		#elif _FILM_GRAIN_ADDITIVE || _FILM_GRAIN_MULTIPLICATIVE
		fixed3 filmGrain = tex2D(_GrainTex,i.tileUV).rgb;
			#if _FILM_GRAIN_ADDITIVE
			screen += (filmGrain*_GrainAmount);
			#elif _FILM_GRAIN_MULTIPLICATIVE
			screen *= (filmGrain*_GrainAmount);
			#endif
		#endif

		#if _IMAGE_TINTING_OFF
		#elif _IMAGE_TINTING_ADDITIVE
		screen += _ImageTint;
		#elif _IMAGE_TINTING_MULTIPLICATIVE
		screen *= _ImageTint;
		#endif
		
		#if _USE_BRIGHTNESS_CONTRAST_CONTRAST
		screen = AdjustContrast(screen,_Contrast);
		#endif

		#if _COLOR_SPACE_CONVERSION_OFF
		#elif _COLOR_SPACE_CONVERSION_GAMMA_TO_LINEAR
		screen *= screen;
		#elif _COLOR_SPACE_CONVERSION_LINEAR_TO_GAMMA
		screen = sqrt(screen);
		#endif
		//return zDepth+yDepth;
		//return yDepth;
		
		alpha = 0
		#if _VIGNETTE_SIMPLE || _VIGNETTE_TINTED
		+(1-i.dist.x)
		#endif
		
		#if _SUN_SHAFTS_AND_ATMOS_FOG_ON
		+(i.sunShaft.rgb)
		#endif
		#if _HEIGHT_FOG_ON
		+(i.heightFog.rgb)
		#endif

		#if _FILM_GRAIN_ADDITIVE
		+(filmGrain*_GrainAmount)
		#endif
		;
		
		#if _DEBUG_SUN_SHAFTS && _SUN_SHAFTS_AND_ATMOS_FOG_ON
		return i.sunShaft*zDepth;
		#endif
		//return i.heightFog*yDepth;
		#if _DEBUG_DEPTH_OF_FIELD && _BLUR_ON && _DOF_ON
		return pow(zDepth,_DoFFocalPoint);
		#endif
		
		#if _DEBUG_OUTLINE
		return outline;
		#endif

		#if _DEBUG_Y_DEPTH
		return fixed4(yDepth,yDepth,yDepth,1);
		#endif
		
		#if _DEBUG_Z_DEPTH
		return fixed4(zDepth,zDepth,zDepth,1);
		#endif
		
		#if _DEBUG_ALPHA
		return fixed4(alpha,alpha, alpha,1);
		#endif

		return fixed4(screen,alpha);
		}

		ENDCG
		}
	}
	SubShader 
	{
		Pass
		{
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma shader_feature _BLUR_ON
		#pragma shader_feature _DOF_ON
		#pragma shader_feature _POST_PROCESSING_ON
		#pragma shader_feature _SCREEN_DISTORTION_ON
		#pragma shader_feature _SHARPEN_ON
		#pragma shader_feature _COLOR_GRADING_ON
		#pragma shader_feature _OUTLINE_ON
		#pragma shader_feature _TINT_OUTLINE_ON
		#pragma shader_feature _SUN_SHAFTS_AND_ATMOS_FOG_ON
		#pragma shader_feature _HEIGHT_FOG_ON
		#pragma shader_feature _CHROMATIC_ABERRATION_ON

		#pragma shader_feature _FILM_GRAIN_OFF _FILM_GRAIN_ADDITIVE _FILM_GRAIN_MULTIPLICATIVE
		#pragma shader_feature _VIGNETTE_OFF _VIGNETTE_SIMPLE _VIGNETTE_TINTED
		#pragma shader_feature _IMAGE_TINTING_OFF _IMAGE_TINTING_ADDITIVE _IMAGE_TINTING_MULTIPLICATIVE _IMAGE_TINTING_LOOKUP
		#pragma shader_feature _COLOR_SPACE_CONVERSION_OFF _COLOR_SPACE_CONVERSION_GAMMA_TO_LINEAR _COLOR_SPACE_CONVERSION_LINEAR_TO_GAMMA
		#pragma shader_feature _DEBUG_NONE _DEBUG_DEPTH_OF_FIELD _DEBUG_SUN_SHAFTS _DEBUG_Z_DEPTH _DEBUG_OUTLINE
		#pragma shader_feature _USE_BRIGHTNESS_CONTRAST_OFF _USE_BRIGHTNESS_CONTRAST_BRIGHTNESS _USE_BRIGHTNESS_CONTRAST_CONTRAST _USE_BRIGHTNESS_CONTRAST_BRIGHTNESS_AND_CONTRAST
		#include "UnityCG.cginc"
		#include "UberHelpers.cginc"
		//Frame Buffer
		uniform sampler2D _ScreenRT0; uniform fixed4 _ScreenRT0_ST; uniform fixed4 _ScreenRT0_TexelSize; 
		//Normals + Depth Y Buffer
		uniform sampler2D _ScreenRT1; uniform fixed4 _ScreenRT1_ST;
		//Outline
		uniform fixed4 _OutlineColor;
		uniform fixed _OutlineNormalContribution; uniform fixed4 _ColorToFade; uniform fixed _FadeOriginalContributionToColor;
		uniform fixed _OutlineDepthContribution; 
		uniform fixed _OutlineSampleDistance; uniform fixed _OutlineExponent; uniform fixed _DepthThreshold;
		//Motion Blur
		uniform fixed4x4 _CurrentToPreviousViewProjectionMatrix; uniform fixed _MotionBlurSamples;
		//Blur & Depth Of Field
		uniform fixed _BlurRadius; uniform fixed _DoFFocalPoint;
		//Chromatic Aberration
		uniform fixed _ChromAbDistortion;
		uniform fixed _ChromAbGreenY; uniform fixed _ChromAbBlueX; uniform fixed _ChromAbBlueY;
		uniform fixed _ChromAbRedX; uniform fixed _ChromAbRedY; uniform fixed _ChromAbGreenX;
		//Sharpening
		uniform fixed _Sharpen;
		//Sunshaft & Atmospheric Fog
		uniform fixed4 _FogColor; uniform fixed4 _SunShaftColor; uniform fixed _SunShaftTightness;
		//Height Fog
		uniform fixed _HeightFogThickness;uniform fixed _HeightFogHeight; uniform fixed4 _HeightFogColor;
		//Ramp Color Grading
		uniform sampler2D _CGLookupTex;
		//Film Grain
		uniform sampler2D _GrainTex; uniform fixed4 _GrainTex_ST;  uniform fixed _GrainAmount;
		//Screen Distortion
		uniform sampler2D _DistortionTex; uniform fixed4 _DistortionTex_ST; 
		uniform fixed _DistortionAmount; uniform fixed _DistortionSpeed;
		//Vignette
		uniform fixed _VignetteSize; uniform fixed4 _VignetteColor; 
		//Image Tinting
		uniform fixed4 _ImageTint;
		//Brightness and Contrast
		uniform fixed _Brightness; uniform fixed _Contrast;
		
		struct v2f 
		{
		fixed4 pos : SV_POSITION;
		fixed2 uv : TEXCOORD0;
		fixed2 dist : TEXCOORD1;
		fixed2 tileUV : TEXCOORD2;
		fixed2 distortionTiledUV : TEXCOORD3;
		fixed2 uv1CA : TEXCOORD4;
		fixed2 uv2CA : TEXCOORD5;
		fixed4 sunShaft : TEXCOORD6;
		fixed4 heightFog : TEXCOORD7;
		fixed4 sharpenUV  : TEXCOORD8;
		fixed2 outlineUV[5] : TEXCOORD9;
		};
		struct v2f_crammed
		{
		fixed4 pos : SV_POSITION;
		fixed4 uvTileUV : TEXCOORD0;
		fixed4 distDistTileUV : TEXCOORD1;
		fixed4 uv12ChromAb : TEXCOORD2;
		fixed4 sunShaft : TEXCOORD3;
		fixed4 heightFog : TEXCOORD3;
		fixed4 sharpenUV  : TEXCOORD5;
		fixed2 outlineUV[4] : TEXCOORD6;//use uvTileUV.xy as first one
		};
		
		inline fixed CheckSame (fixed2 centerNormal, fixed centerDepth, fixed4 outlineRead)
		{
			// difference in normals
			// do not bother decoding normals - there's no need here
			fixed2 diff = abs(centerNormal - outlineRead.xy) * (_OutlineNormalContribution);
			int isSameNormal = (diff.x + diff.y) * (_OutlineNormalContribution) < 0.1;
			// difference in depth
			fixed sampleRead = outlineRead.w;
			fixed zdiff = abs(centerDepth-sampleRead);
			int isSameDepth = zdiff * _OutlineDepthContribution < 0.09 * centerDepth;
		
			// return:
			// 1 - if normals and depth are similar enough
			// 0 - otherwise
			
			return isSameNormal * isSameDepth ? 1.0 : 0.0;
		}
		v2f vert (appdata_img v)
		{
		v2f o;
		o.uv = v.texcoord;
		o.pos = UnityObjectToClipPos(v.vertex);
		
		
		#if _OUTLINE_ON
		fixed2 outlineUV = v.texcoord;
		o.outlineUV[0] = UnityStereoScreenSpaceUVAdjust(outlineUV, _ScreenRT0_ST);
		
			#if UNITY_UV_STARTS_AT_TOP
			if (_ScreenRT0_TexelSize.y < 0)
				outlineUV.y = 1-outlineUV.y;
			#endif
		
		o.outlineUV[1] = UnityStereoScreenSpaceUVAdjust(outlineUV, _ScreenRT0_ST);
		o.outlineUV[4] = UnityStereoScreenSpaceUVAdjust(outlineUV, _ScreenRT0_ST);
				
		// offsets for two additional samples
		o.outlineUV[2] = UnityStereoScreenSpaceUVAdjust(outlineUV + fixed2(-_ScreenRT0_TexelSize.x, -_ScreenRT0_TexelSize.y) * _OutlineSampleDistance, _ScreenRT0_ST);
		o.outlineUV[3] = UnityStereoScreenSpaceUVAdjust(outlineUV + fixed2(+_ScreenRT0_TexelSize.x, -_ScreenRT0_TexelSize.y) * _OutlineSampleDistance, _ScreenRT0_ST);
		#endif
		
		#if _FILM_GRAIN_ADDITIVE || _FILM_GRAIN_MULTIPLICATIVE
		o.tileUV = TRANSFORM_TEX(v.texcoord, _GrainTex);
		#endif

		#if _SCREEN_DISTORTION_ON
		o.distortionTiledUV = TRANSFORM_TEX(v.texcoord, _DistortionTex);
		#endif


		#if _SHARPEN_ON
		o.sharpenUV = fixed4(o.uv - _ScreenRT0_TexelSize.xy, o.uv + _ScreenRT0_TexelSize.xy);
		#endif
		
		#if _HEIGHT_FOG_ON || _SUN_SHAFTS_AND_ATMOS_FOG_ON
		fixed3 viewDir = normalize(-WorldSpaceViewDir(v.vertex));
		//fixed3 viewDir = mul((float3x3)unity_CameraToWorld, float3(0,0,1));
		fixed3 lightDir = normalize(_WorldSpaceLightPos0);
		#endif

		#if _HEIGHT_FOG_ON
		//fixed heightFogThickness = dot(1-_HeightFogHeight*2-.5,lightDir);
		fixed heightFogThickness = max(dot(viewDir.y + 1-_HeightFogHeight,lightDir),0.0);
		o.heightFog = lerp(fixed4 (1,1,1,1),_FogColor, heightFogThickness);
		//o.heightFog = lerp(fixed4 (1,1,1,1), _FogColor, pow(heightFogThickness,_HeightFogThickness));
		#endif

		#if _SUN_SHAFTS_AND_ATMOS_FOG_ON
		fixed sunShaftSize = dot(viewDir,lightDir);
		o.sunShaft = lerp(_FogColor, _SunShaftColor, pow(sunShaftSize, _SunShaftTightness));
		#endif

		#if _VIGNETTE_SIMPLE || _VIGNETTE_TINTED
		o.dist = (o.uv - 0.5) * 1.25;
		o.dist.x = 1 - dot(o.dist, o.dist) * _VignetteSize;
		#endif
		
		#if _CHROMATIC_ABERRATION_ON
		//o.uv0CA.x = v.texco*dX * _ScreenRT0_TexelSize.x;
		//o.uv0CA.y = v.texco*dY * _ScreenRT0_TexelSize.y;
		o.uv1CA = v.texcoord-_ChromAbRedX;
		//o.uv1CA.x = v.texco*eenX * _ScreenRT0_TexelSize.x - 0.5;
		//o.uv1CA.y = v.texco*eenY * _ScreenRT0_TexelSize.y - 0.5;
		o.uv2CA = v.texcoord-_ChromAbRedX;
		//o.uv2CA.x = v.texcoord.x + _ChromAbBlueX * _ScreenRT0_TexelSize.x - 0.5;
		//o.uv2CA.y = v.texcoord.y + _ChromAbBlueY * _ScreenRT0_TexelSize.y - 0.5;
		#endif

		return o;
		}
		fixed4 frag (v2f i) : COLOR 
		{
		#if !_SCREEN_DISTORTION_ON && !_SHARPEN_ON || _OUTLINE_ON
		fixed4 frameBuffer = tex2D(_ScreenRT0, i.uv);
		fixed3 screen = frameBuffer.rgb;
		fixed zDepth = frameBuffer.a;
		fixed4 normalsYDepthBuffer = tex2D(_ScreenRT1,i.uv);
		fixed yDepth = normalsYDepthBuffer.a;
		fixed2 normals = normalsYDepthBuffer.rg;
		#endif
		
		#if _OUTLINE_ON && !_SCREEN_DISTORTION_ON
		fixed depthCenter = tex2D (_ScreenRT0, i.outlineUV[1]).a;
		fixed3 normalsCenter = tex2D (_ScreenRT1, i.outlineUV[1]).rgb;
		fixed depth1 = tex2D (_ScreenRT0, i.outlineUV[2]).a;
		fixed3 normals1 = tex2D (_ScreenRT1, i.outlineUV[2]).rgb;
		fixed depth2 = tex2D (_ScreenRT0, i.outlineUV[3]).a;
		fixed3 normals2 = tex2D (_ScreenRT1, i.outlineUV[3]).rgb;
		
		fixed2 centerNormals = normalsCenter.rg;
		fixed3 outline = 1;
		outline *= CheckSame(centerNormals, depthCenter, fixed4(normals1,depth1));
		outline *= CheckSame(centerNormals, depthCenter, fixed4(normals2,depth2));
		#if _TINT_OUTLINE_ON
		outline = 1-((1-outline) * (1-_OutlineColor));
		#endif

		screen = lerp(screen, _ColorToFade.rgb, _FadeOriginalContributionToColor) * outline;
		#endif

		#if _SCREEN_DISTORTION_ON
		fixed2 distUV = i.distortionTiledUV + _Time.x * _DistortionSpeed;
		fixed2 distortionTex = tex2D(_DistortionTex, distUV).xy;
		distortionTex = ((distortionTex*2) - 1) * _DistortionAmount*.1;

			#if !_OUTLINE_ON
			fixed4 frameBuffer = tex2D(_ScreenRT0, i.uv + distortionTex);
			fixed3 screen = frameBuffer.rgb;
			fixed zDepth = frameBuffer.a;
			fixed4 normalsYDepthBuffer = tex2D(_ScreenRT1, i.uv + distortionTex);
			fixed2 normals = normalsYDepthBuffer.rg;
			fixed yDepth = normalsYDepthBuffer.a;
			#else
			frameBuffer = tex2D(_ScreenRT0, i.uv + distortionTex);
			screen = frameBuffer.rgb;
			zDepth = frameBuffer.a;
			normalsYDepthBuffer = tex2D(_ScreenRT1, i.uv + distortionTex);
			yDepth = normalsYDepthBuffer.a;
			 normals = normalsYDepthBuffer.rg;
			#endif

			#if _OUTLINE_ON
			fixed depthCenter = tex2D (_ScreenRT0, i.outlineUV[1]+distortionTex).a;
			fixed3 normalsCenter = tex2D (_ScreenRT1, i.outlineUV[1]+distortionTex).rgb;
			fixed depth1 = tex2D (_ScreenRT0, i.outlineUV[2]+distortionTex).a;
			fixed3 normals1 = tex2D (_ScreenRT1, i.outlineUV[2]+distortionTex).rgb;
			fixed depth2 = tex2D (_ScreenRT0, i.outlineUV[3]+distortionTex).a;
			fixed3 normals2 = tex2D (_ScreenRT1, i.outlineUV[3]+distortionTex).rgb;
			
			fixed2 centerNormals = normalsCenter.rg;
			fixed3 outline = 1;
			outline *= CheckSame(centerNormals, depthCenter, fixed4(normals1,depth1));
			outline *= CheckSame(centerNormals, depthCenter, fixed4(normals2,depth2));
				#if _TINT_OUTLINE_ON
				outline = 1-((1-outline) * (1-_OutlineColor));
				#endif
			screen = lerp(screen, _ColorToFade.rgb, _FadeOriginalContributionToColor) * outline;
			#endif
		#endif
		
		#if _SHARPEN_ON
		fixed3 unsharpened = screen;
			#if !_SCREEN_DISTORTION_ON
			screen = tex2D(_ScreenRT0, i.uv).rgb * (1+(3.2 * _Sharpen));
			screen -= tex2D(_ScreenRT0, i.sharpenUV.xy).rgb* (.8 * _Sharpen);
			screen -= tex2D(_ScreenRT0, i.sharpenUV.xw).rgb* (.8 * _Sharpen);
			screen -= tex2D(_ScreenRT0, i.sharpenUV.zy).rgb* (.8 * _Sharpen);
			screen -= tex2D(_ScreenRT0, i.sharpenUV.zw).rgb* (.8 * _Sharpen);
			#else
			screen = tex2D(_ScreenRT0, i.uv+distortionTex).rgb * (1+(3.2 * _Sharpen));
			screen -= tex2D(_ScreenRT0, i.sharpenUV.xy+distortionTex).rgb* (.8 * _Sharpen);
			screen -= tex2D(_ScreenRT0, i.sharpenUV.xw+distortionTex).rgb* (.8 * _Sharpen);
			screen -= tex2D(_ScreenRT0, i.sharpenUV.zy+distortionTex).rgb* (.8 * _Sharpen);
			screen -= tex2D(_ScreenRT0, i.sharpenUV.zw+distortionTex).rgb* (.8 * _Sharpen);
			#endif
		screen = lerp(screen,unsharpened,.5);
		#endif

		#if _BLUR_ON
		fixed2 direction = fixed2(1.0, 0.0);
		fixed2 blurDisplacementX = fixed2(1.3846153846, 1.3846153846) * direction * _BlurRadius;
		fixed2 blurDisplacementY = fixed2(3.2307692308, 3.2307692308) * direction * _BlurRadius;
		fixed2 texelSize = _ScreenRT0_TexelSize.zw; //z = texture width, w = texture height

			#if _OUTLINE_ON
			fixed3 outlineScreen = screen;
			#endif
			#if _DOF_ON
			fixed3 dofFocused = screen;
			#endif
			screen = fixed3(0.0, 0.0, 0.0);
			#if !_SCREEN_DISTORTION_ON
				screen += tex2D(_ScreenRT0, i.uv).rgb * 0.2270270270;
				screen += tex2D(_ScreenRT0, i.uv + (blurDisplacementX / texelSize)).rgb * 0.3162162162;
				screen += tex2D(_ScreenRT0, i.uv - (blurDisplacementX / texelSize)).rgb * 0.3162162162;
				screen += tex2D(_ScreenRT0, i.uv + (blurDisplacementY / texelSize)).rgb * 0.0702702703;
				screen += tex2D(_ScreenRT0, i.uv - (blurDisplacementY / texelSize)).rgb * 0.0702702703;
				#if _OUTLINE_ON
				screen = lerp(outlineScreen,screen,.5);
				#endif
				//DoF
					#if _DOF_ON
					screen = lerp(dofFocused,screen,pow(zDepth,(_DoFFocalPoint*10)));
					#endif
			#else
				screen += tex2D(_ScreenRT0, i.uv+ distortionTex).rgb * 0.2270270270;
				screen += tex2D(_ScreenRT0, i.uv + (blurDisplacementX / texelSize)+distortionTex).rgb * 0.3162162162;
				screen += tex2D(_ScreenRT0, i.uv - (blurDisplacementX / texelSize)+distortionTex).rgb * 0.3162162162;
				screen += tex2D(_ScreenRT0, i.uv + (blurDisplacementY / texelSize)+distortionTex).rgb * 0.0702702703;
				screen += tex2D(_ScreenRT0, i.uv - (blurDisplacementY / texelSize)+distortionTex).rgb * 0.0702702703;
				#if _OUTLINE_ON
				screen = lerp(outlineScreen,screen,.5);
				#endif
			//DoF
				#if _DOF_ON
				screen = lerp(dofFocused,screen,pow(zDepth,(_DoFFocalPoint*10)));
				#endif
			#endif
		#endif
		
		
		#if _HEIGHT_FOG_OFF
		#elif _HEIGHT_FOG_ON
		//screen.rgb += (yDepth*_HeightFogThickColor);
		//screen.rgb +=(i.heightFog.rgb*yDepth);
		screen.rgb +=(i.heightFog.rgb*yDepth);
		#endif

		#if _SUN_SHAFTS_AND_ATMOS_FOG_OFF
		#elif _SUN_SHAFTS_AND_ATMOS_FOG_ON
		screen.rgb += (i.sunShaft.rgb*zDepth);
		#endif

		#if _COLOR_GRADING_OFF
		#elif _COLOR_GRADING_ON
		screen.r = tex2D(_CGLookupTex, screen.rr).r;
		screen.g = tex2D(_CGLookupTex, screen.gg).g;
		screen.b = tex2D(_CGLookupTex, screen.bb).b;
		#endif

		#if _CHROMATIC_ABERRATION_ON
			

			fixed sqUVA = i.uv1CA.x * i.uv1CA.x + i.uv1CA.y * i.uv1CA.y;
			fixed2 uvA = (1.0 + sqUVA * (_ChromAbDistortion * sqUVA* .25)) * i.uv1CA+fixed2(_ChromAbRedX*1.01,_ChromAbRedX*1.023);
			fixed sqUVB = i.uv2CA.x * i.uv2CA.x + i.uv2CA.y * i.uv2CA.y;
			fixed2 uvB = (1.0 + sqUVB * (_ChromAbDistortion * sqUVB)) * i.uv2CA+fixed2(_ChromAbRedX*1.025,_ChromAbRedX*1.05);
			
			#if _SUN_SHAFTS_AND_ATMOS_FOG_ON || _BLUR_ON || _OUTLINE_ON
			fixed3 previous = screen;
			#endif

			#if !_SCREEN_DISTORTION_ON
			screen = fixed3(0.0h,0.0h,0.0h);
			screen.r = tex2D(_ScreenRT0, i.uv).r;
			screen.g = tex2D(_ScreenRT0, uvA).g;
			screen.b = tex2D(_ScreenRT0, uvB).b;
			#else
			screen = fixed3(0.0h,0.0h,0.0h);
			screen.r = tex2D(_ScreenRT0, i.uv+distortionTex).r;
			screen.g = tex2D(_ScreenRT0, uvA+distortionTex).g;
			screen.b = tex2D(_ScreenRT0, uvB+distortionTex).b;
				#if _BLUR_ON
				fixed3 distBlurScreen = screen;
				distBlurScreen = fixed4(0.0h,0.0h,0.0h,1.0h);
				distBlurScreen += tex2D(_ScreenRT0, i.uv+ distortionTex).rgb * 0.2270270270;
				distBlurScreen += tex2D(_ScreenRT0, i.uv + (blurDisplacementX / texelSize)+distortionTex).rgb * 0.3162162162;
				distBlurScreen += tex2D(_ScreenRT0, i.uv - (blurDisplacementX / texelSize)+distortionTex).rgb * 0.3162162162;
				distBlurScreen += tex2D(_ScreenRT0, i.uv + (blurDisplacementY / texelSize)+distortionTex).rgb * 0.0702702703;
				distBlurScreen += tex2D(_ScreenRT0, i.uv - (blurDisplacementY / texelSize)+distortionTex).rgb * 0.0702702703;
				screen = lerp(distBlurScreen, screen,.5);
				#endif
			#endif
			
			#if _SUN_SHAFTS_AND_ATMOS_FOG_ON || _BLUR_ON || _OUTLINE_ON
			screen = lerp(screen, previous, .5);
			#endif
		#endif
		#if _VIGNETTE_SIMPLE
		screen *=i.dist.x;
		#elif _VIGNETTE_TINTED
		fixed3 colorVignette = 1-saturate(1-i.dist.x *1-_VignetteColor.rgb);
		screen *= colorVignette;
		//failed attempt to blend
		//screen = lerp(screen,normalize(colorVignette+(1-i.dist.x*2)),.5);
		#endif
		
		#if _FILM_GRAIN_OFF
		#elif _FILM_GRAIN_ADDITIVE || _FILM_GRAIN_MULTIPLICATIVE
		fixed3 filmGrain = tex2D(_GrainTex,i.tileUV).rgb;
			#if _FILM_GRAIN_ADDITIVE
			screen += (filmGrain*_GrainAmount);
			#elif _FILM_GRAIN_MULTIPLICATIVE
			screen *= (filmGrain*_GrainAmount);
			#endif
		#endif

		#if _IMAGE_TINTING_OFF
		#elif _IMAGE_TINTING_ADDITIVE
		screen += _ImageTint;
		#elif _IMAGE_TINTING_MULTIPLICATIVE
		screen *= _ImageTint;
		#endif
		
		#if _USE_BRIGHTNESS_CONTRAST_CONTRAST
		screen = AdjustContrast(screen,_Contrast);
		#endif

		#if _COLOR_SPACE_CONVERSION_OFF
		#elif _COLOR_SPACE_CONVERSION_GAMMA_TO_LINEAR
		screen *= screen;
		#elif _COLOR_SPACE_CONVERSION_LINEAR_TO_GAMMA
		screen = sqrt(screen);
		#endif
		//return zDepth+yDepth;
		//return yDepth;
		
		#if _DEBUG_SUN_SHAFTS && _SUN_SHAFTS_AND_ATMOS_FOG_ON
		return i.sunShaft*zDepth;
		#endif
		//return i.heightFog*yDepth;
		#if _DEBUG_DEPTH_OF_FIELD && _BLUR_ON && _DOF_ON
		return pow(zDepth,_DoFFocalPoint);
		#endif
		
		#if _DEBUG_OUTLINE && _OUTLINE_ON
		return outline;
		#endif

		#if _DEBUG_Z_DEPTH
		return zDepth;
		#endif
		return fixed4(screen,zDepth);
		}

		ENDCG
		}
	}

}
