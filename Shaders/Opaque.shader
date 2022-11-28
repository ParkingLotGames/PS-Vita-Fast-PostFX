Shader "PS Vita/Uber/Opaque" {
    Properties 
	{
		[Header(_______________________________________________________________________________)]
		[Header(PS Vita Opaque Uber)]
		[Header(_______________________________________________________________________________)]
		[Header(Base Pass)]
		[Header(_______________________________________________________________________________)]
		
		[Header(Material Workflow)]
		
		
		[KeywordEnum(Unlit,Lit,PBR Specular,PBR Metallic)]_WORKFLOW("Material Workflow",Float)=0
		[Header(_______________________________________________________________________________)]
		
		[Header(Shadows)]
		[Toggle]_USE_RT_SHADOWS ("Receive Custom Realtime Shadows", Float) =1
		[Toggle]_RECEIVE_UNITY_SHADOWS ("Receive Unity Shadows", Float)=1
		_DirectionalLightShadowIntensity ("Shadow Intensity", Range(0,5))=.5
		[Toggle]_TINT_SHADOWS ("Enable Shadow Tint",Float)=0
		[HDR]_ShadowColor ("Shadow Tint",Color)= (0,0,0,1)
		[Header(_______________________________________________________________________________)]
		
		
		[Header(Lighting Calculations (Non PBR))]
		[Toggle]_USE_DIFFUSE_TERM ("Enable Diffuse Term Calculations", Float) =1
		[KeywordEnum(Lambert, Half Lambert, NdotL Lookup, Wrapped NdotL Lookup)]_DIFFUSE_TERM_LIGHTING_MODEL("Diffuse Term Model", Float)=0
		[KeywordEnum(Per Vertex,Per Pixel)]_DIFFUSE_PROCESSING("Diffuse Term Quality", Float) =0
		[Toggle]_USE_SPECULAR_TERM ("Enable Specular Term Calculations", Float) =0
		[KeywordEnum(Phong, Blinn Phong, NdotH Lookup, GGX Lookup)]_SPECULAR_TERM_LIGHTING_MODEL("Specular Term Model", Float)=3
		[KeywordEnum(Per Vertex,Per Pixel)]_SPECULAR_PROCESSING("Specular Term Quality", Float) =0
		//[Toggle]_USE_LOOKUP_LIGHTING ("Enable Lighting Lookup", Float) =1
		//[KeywordEnum(GGX, Specular, Vita, Double Ramp)]_LOOKUP_LIGHTING_TYPE("Lookup Lighting Type", Float)=0
		[Header(_______________________________________________________________________________)]
		[Header(Lighting Lookup)]
        [NoScaleOffset] _LightLookupTex ("Lighting Lookup Texture", 2D) = "black" {}
		[Header(_______________________________________________________________________________)]
		



		[Header(Realtime Lighting)]
		[Toggle]_USE_RT_LIGHTING ("Enable Realtime Lighting", Float) =1
		//[Toggle]_USE_RT_DIFFUSE ("Enable Realtime Diffuse Contribution", Float) =1
		[Toggle]_USE_RT_SPECULAR ("Receive Specular Contribution", Float) =1
		//[KeywordEnum(Diffuse Per Vertex,Specular Per Vertex, Diffuse Per Pixel, Vertex Per Pixel, PBR Per Vertex, PBR Per Pixel)]_RT_LIGHTING_TYPE("Real Time Lighting Type", Float)=0
		//[KeywordEnum(Lambert, Phong, Blinn Phong, Half Lambert)]_RT_LIGHTING_MODEL("Lighting Model", Float)=0
		[Header(_______________________________________________________________________________)]
		[Header(Matcap)]
		[Toggle]_USE_MATCAP_LIGHTING ("Enable Matcap", Float) =1
		[Toggle]_USE_MATCAP_DIFFUSE ("Receive Diffuse Contribution", Float) =1
		[Toggle]_USE_MATCAP_SPECULAR ("Receive Specular Contribution", Float) =1
		//[Toggle]_MATCAP_USE_RT_LIGHTING ("Use RT Light Settings", Float) =0
		//[KeywordEnum(Unlit,Diffuse Per Vertex,Specular Per Vertex,Diffuse Per Pixel,Specular Per Pixel)]_MATCAP_LIGHTING_TYPE("Matcap Lighting Type", Float)=0
		//[KeywordEnum(Lambert, Phong, Blinn Phong, Half Lambert)]_MATCAP_LIGHTING_MODEL("Matcap Lighting Model", Float)=0
        [NoScaleOffset] _MatcapTex ("Matcap Texture", 2D) = "black" {}
		[Header(_______________________________________________________________________________)]
		
		
		[Header(Ambient Lighting)]
		[Toggle]_USE_AMBIENT_LIGHT ("Use Ambient Light", Float) =1
		[KeywordEnum(Per Vertex,Per Pixel)]_AMBIENT_LIGHT_PROCESSING("Ambient Light Quality", Float) =0
		[Toggle]_MULTIPLY_AMBIENT_LIGHT ("Multiply Ambient Light", Float) =1
		_AmbientIntensity ("Ambient Light Intensity", Range (0,8)) = 1
		[Header(_______________________________________________________________________________)]
		
		[Header(Image Based Lighting)]
		[Toggle]_USE_IBL ("Use Image Based Lighting", Float) =1
		[KeywordEnum(Diffuse, Diffuse and Specular, Specular)]_IBL_MODE ("IBL Mode", Float) =0
		[KeywordEnum(Cubemap, Panoramic)]_IBL_INPUT_TYPE ("IBL Input Type", Float) =0
		[KeywordEnum(Per Vertex, Per Pixel)]_IBL_DIFFUSE_LIGHTING_TYPE ("IBL Diffuse Lighting Processing Mode", Float) =0
		[KeywordEnum(Per Vertex, Per Pixel)]_IBL_SPECULAR_LIGHTING_TYPE ("IBL Specular Lighting Processing Mode", Float) =0
        [NoScaleOffset] _DiffuseIBLTex ("Diffuse IBL Map", 2D) = "black" {}
        _DiffuseIBLIntensity ("Diffuse IBL Intensity", Range(0,5)) = 1
        [NoScaleOffset] _SpecularIBLTex ("Specular IBL Map", 2D) = "black" {}
		[Toggle]_PIXEL_IBL_SPEC_FRESNEL ("Use Fresnel on Specular IBL", Float) =1
		[Toggle]_MULTIPLY_IBL ("Multiply IBL", Float) =1
        _SpecularIBLIntensity ("Specular IBL Intensity", Range(0,5)) = 1
		[Header(_______________________________________________________________________________)]
		
		[Header(Rimlight)]
		[Toggle]_USE_RIM_LIGHT ("Enable Rimlight", Float) =1
		[KeywordEnum(Per Vertex, Per Pixel)]_RIM_LIGHT_TYPE("Lookup Lighting Type", Float)=0
        [HDR] _RimLightColor ("Rimlight Color", Color) = (1,1,1,1)
		[Header(_______________________________________________________________________________)]
		[Space]
		[Header(_______________________________________________________________________________)]
		
		
		[Header(Texture Inputs)]
		[Header(Base)]
		[Toggle]_USE_BASEMAP("Enable Base Map", Float)=1
        [NoScaleOffset]_MainTex ("Base Map (RGB) Glossiness (A)", 2D) = "grey" {}
        //[NoScaleOffset]_MainTex ("Base Map (RGB) Roughness (A)", 2D) = "grey" {}
		[Toggle]_USE_BASEMAP_TINT ("Enable Base Map Tinting", Float) =1
        [HDR]_Color ("Tint", Color) = (1,1,1,1)
		[Header(_______________________________________________________________________________)]
		
		[Header(Specular)]
        [KeywordEnum(Map, Color, Value)]_SPECULAR_TYPE ("Specular Input Type", Float) =0
        [NoScaleOffset]_SpecularMap ("Specular Map(RGB)", 2D) = "black" {}
        _SpecularColor ("Specular Color", Color) = (.5,.5,.5,.5)
        _SpecularValue ("Specular Value", Range(0.01,10)) =1
		[Toggle]_USE_GLOSSINESS_VALUE ("Use Glossiness Value", Float) =1
        _GlossinessValue ("Specular Value", Range(0.01,10)) =1
		[Toggle]_MULTIPLY_SPECULAR_MAP_BY_VALUE  ("Multiply Spec Map by Value", Float) =1
        [NoScaleOffset]_SpecularMapMultiply ("Specular Map Multiplication Value", Range(0.01,10)) =1
		[Toggle]_MULTIPLY_GLOSSINESS_MAP_BY_VALUE  ("Multiply Gloss Map by Value", Float) =1
        [NoScaleOffset]_GlossinessMapMultiply ("Glossiness Multiplication Value", Range(0.01,10)) =1
		[Header(_______________________________________________________________________________)]
		
		[Header(Metallic)]
        [KeywordEnum(Map, Color, Value)]_METALLIC_TYPE ("Metallic Input Type", Float) =0
        [NoScaleOffset]_MetallicMap ("Metallic Map(RGB)", 2D) = "black" {}
        _MetallicColor ("Metallic Color", Color) = (.5,.5,.5,.5)
        _MetallicValue ("Metallic Value", Range(0.01,10)) =1
		[Toggle]_USE_ROUGHNESS_VALUE ("Use Roughness Value", Float) =1
        _RoughnessValue ("Specular Value", Range(0.01,10)) =1
		[Toggle]_MULTIPLY_METALLIC_MAP_BY_VALUE  ("Multiply Metal Map by Value", Float) =1
        [NoScaleOffset]_MetallicMapMultiply ("Metallic Map Multiplication Value", Range(0.01,10)) =1
		[Toggle]_MULTIPLY_ROUGHNESS_MAP_BY_VALUE  ("Multiply Rough Map by Value", Float) =1
        [NoScaleOffset]_RoughnessMapMultiply ("Roughness Multiplication Value", Range(0.01,10)) =1
		[Header(_______________________________________________________________________________)]
		
		[Header(Normals)]
        [Toggle]_USE_NORMAL_MAP ("Enable Normal Map", Float)=1
		[NoScaleOffset]_NormalMap ("Normal Map", 2D) = "bump" {}
        [Toggle]_USE_NORMAL_MAP_INTENSITY ("Enable Normal Map Intensity", Float)=0
        _NormalMapIntensity ("Normal Map Intensity", Float)=1
		[Header(_______________________________________________________________________________)]
		
		[Header(Displacement)]
        [Toggle]_USE_VERTEX_DISPLACEMENT ("Use Vertex Displacement", Float)=0
        [NoScaleOffset]_DisplacementMap ("Displacement Map (R)", 2D) = "gray" {}
        _DisplacementIntensity ("Displacement Value", Float)=1
		[Header(_______________________________________________________________________________)]
		
		[Header(Emission)]
        [NoScaleOffset]_EmissionMap ("Emission Map (RGB)", 2D) = "black" {}
        [HDR]_EmissionColor ("Emission Color", Color)=(0,0,0,1)
		[Header(_______________________________________________________________________________)]
		
		[Header(Z Depth)]
		[Toggle]_MULTIPLY_DEPTH ("Multiply Depth",Float)=0
		_DepthMultiplicationFactor ("Depth Multiplication Factor",Float)=0

		//_ColorCorrection ("Color Correction", Color) = (1,1,1,1)
        //_Color ("Tint", Color) = (1,1,1,1)
		}
    SubShader {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" "Thermal" = "Inanimated"}
		LOD 400

        // Base pass
        Pass {
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#pragma multi_compile_fwdbase
	
		#pragma shader_feature _WORKFLOW_UNLIT _WORKFLOW_LIT _WORKFLOW_PBR_METALLIC _WORKFLOW_PBR_SPECULAR
		#pragma shader_feature _USE_DIFFUSE_TERM_ON
		#pragma shader_feature _USE_BASEMAP_ON
		#pragma shader_feature _USE_SPECULAR_TERM_ON
		#pragma shader_feature _DIFFUSE_PROCESSING_PER_VERTEX _DIFFUSE_PROCESSING_PER_PIXEL
		#pragma shader_feature _SPECULAR_PROCESSING_PER_VERTEX _SPECULAR_PROCESSING_PER_PIXEL
			
			//#define TILING_ON
            #define BASE_PASS
			//Base Map
			#pragma shader_feature _USE_BASEMAP_TINT_ON
			#pragma shader_feature _MULTIPLY_IBL_ON
			//Real Time Lighting
			#pragma shader_feature _USE_RT_LIGHTING_ON
		#pragma shader_feature _DIFFUSE_TERM_LIGHTING_MODEL_LAMBERT _DIFFUSE_TERM_LIGHTING_MODEL_HALF_LAMBERT _DIFFUSE_TERM_LIGHTING_MODEL_NDOTL_LOOKUP _DIFFUSE_TERM_LIGHTING_MODEL_WRAPPED_NDOTL_LOOKUP
		#pragma shader_feature _SPECULAR_TERM_LIGHTING_MODEL_PHONG _SPECULAR_TERM_LIGHTING_MODEL_BLINN_PHONG _SPECULAR_TERM_LIGHTING_MODEL_NDOTH_LOOKUP _SPECULAR_TERM_LIGHTING_MODEL_GGX_LOOKUP
			//Real Time Shadows
			#pragma shader_feature _USE_RT_SHADOWS_ON
			#pragma shader_feature _RECEIVE_UNITY_SHADOWS_ON
			#pragma shader_feature _TINT_SHADOWS_ON
			//Matcap
			#pragma shader_feature _USE_MATCAP_LIGHTING_ON
			//Lookup Lighting
			#pragma shader_feature _USE_LOOKUP_LIGHTING_ON
			//Ambient Light
			#pragma shader_feature _USE_AMBIENT_LIGHT_ON
			#pragma shader_feature _MULTIPLY_AMBIENT_LIGHT_ON
			#pragma shader_feature _AMBIENT_LIGHT_PROCESSING_PER_VERTEX _AMBIENT_LIGHT_PROCESSING_PER_PIXEL
			//IBL
			#pragma shader_feature _USE_IBL_ON
			#pragma shader_feature _IBL_MODE_DIFFUSE _IBL_MODE_DIFFUSE_AND_SPECULAR _IBL_MODE_SPECULAR
			#pragma shader_feature _PIXEL_IBL_SPEC_FRESNEL
			#pragma shader_feature _IBL_INPUT_TYPE_PANORAMIC _IBL_INPUT_TYPE_CUBEMAP
			#pragma shader_feature _IBL_DIFFUSE_LIGHTING_TYPE_PER_VERTEX _IBL_DIFFUSE_LIGHTING_TYPE_PER_PIXEL
			#pragma shader_feature _IBL_SPECULAR_LIGHTING_TYPE_PER_VERTEX _IBL_SPECULAR_LIGHTING_TYPE_PER_PIXEL
			//Normal Mapping
			#pragma shader_feature _USE_NORMAL_MAP_ON
			#pragma shader_feature _USE_NORMAL_MAP_INTENSITY_ON
			//Specular
			#pragma shader_feature _SPECULAR_TYPE_MAP _SPECULAR_TYPE_COLOR _SPECULAR_TYPE_VALUE
			#pragma shader_feature _MULTIPLY_SPECULAR_MAP_BY_VALUE_ON
			#pragma shader_feature _MULTIPLY_GLOSSINESS_MAP_BY_VALUE
			//Metallic Workflow
			#pragma shader_feature _METALLIC_TYPE_MAP _METALLIC_TYPE_COLOR _METALLIC_TYPE_VALUE
			#pragma shader_feature _MULTIPLY_METALLIC_MAP_BY_VALUE
			#pragma shader_feature _MULTIPLY_ROUGHNESS_MAP_BY_VALUE
			//Depth Multiply
			#pragma shader_feature _MULTIPLY_DEPTH_ON
			//Vertex Displacement
			#pragma shader_feature _USE_VERTEX_DISPLACEMENT_ON
			//Dissolve
			#pragma shader_feature _USE_DISSOLVE_ON
			
			#pragma shader_feature _CUSTOM_LIGHTING
			//#define COLOR_GRADING
			//#define GAMMA_TO_LINEAR
			//#define LINEAR_TO_GAMMA
			#include "DarkParadigmUber.cginc"
            ENDCG
        }
        
        // Add pass
        Pass {
            Tags { "LightMode" = "ForwardAdd" }
            Blend One One // src*1 + dst*1
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd
			#pragma shader_feature _USE_RT_LIGHTING_ON
			#pragma shader_feature _RT_LIGHTING_TYPE_DIFFUSE_PER_PIXEL
            #include "DarkParadigmUber.cginc"
            ENDCG
        }
		Pass {
            Tags { "LightMode" = "ShadowCaster" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "DarkParadigmUber.cginc"

			ENDCG
        }
    }
}