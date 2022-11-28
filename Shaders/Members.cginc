
#if _USE_BASEMAP_ON
//sampler2D _MainTex;
#endif
sampler2D _MainTex;

#ifdef TILING_ON
fixed4 _MainTex_ST;
#endif

#if _WORKFLOW_LIT || _WORKFLOW_PBR_METALLIC || _WORKFLOW_PBR_SPECULAR
	#if _USE_NORMAL_MAP_ON
	sampler2D _NormalMap;
		#if _USE_NORMAL_INTENSITY_ON
		fixed _NormalIntensity;
		#endif
	#endif
#endif

#if _USE_VERTEX_DISPLACEMENT_ON
sampler2D _DisplacementMap;
fixed _DisplacementIntensity;
#endif

#if _WORKFLOW_LIT || _WORKFLOW_PBR_METALLIC || _WORKFLOW_PBR_SPECULAR
	#if _USE_SPECULAR_TERM_ON
		#if _SPECULAR_TYPE_MAP
		sampler2D _SpecularMap;
		#endif
		
		#if _SPECULAR_TYPE_COLOR
		fixed4 _SpecularColor;
		#endif
		
		#if _SPECULAR_TYPE_VALUE
		fixed _SpecularValue;
		#endif
	#endif
#endif

#if _WORKFLOW_PBR_METALLIC
sampler2D _MetallicMap;
#endif

#if _IBL_INPUT_TYPE_CUBEMAP
samplerCUBE _DiffuseIBLTex;
#endif

#if _IBL_INPUT_TYPE_PANORAMIC
sampler2D _DiffuseIBLTex;
sampler2D _SpecularIBLTex;
#endif

#if _USE_RT_SHADOWS_ON || _RECEIVE_UNITY_SHADOWS_ON
uniform fixed _DirectionalLightShadowIntensity;
uniform fixed4 _ShadowColor;
#endif
#if _USE_RT_SHADOWS_ON
uniform fixed _DirectionalLightShadowBias;
uniform fixed _SpotlightShadowBias;
uniform fixed _SpotlightShadowIntensity;
uniform fixed _DirectionalLightFarPlane;
uniform fixed _DirectionalLightShadowmapScale;
uniform float4x4 _DirectionalLightDepthV;
uniform float4x4 _DirectionalLightDepthVPBias;
uniform sampler2D _DirectionalLightStaticShadowmap;
uniform sampler2D _SpotlightShadowmap;
#endif
#if _USE_DISSOLVE_ON
fixed _DissolveAmount;
#endif
#if _MULTIPLY_DEPTH_ON
fixed _DepthMultiplicationFactor;
#endif
#if _USE_BASEMAP_TINT_ON
fixed4 _Color;
#endif

float4 _HDR_Tex;
fixed _RoughnessValue;
fixed _GlossinessValue;
fixed4 _ColorCorrection;
fixed _DiffuseIBLIntensity;
fixed _AmbientIntensity;
fixed _SpecIBLIntensity;

