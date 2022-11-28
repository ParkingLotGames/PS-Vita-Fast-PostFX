#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"

struct appdata
{
    fixed4 vertex : POSITION;
    fixed2 uv : TEXCOORD0;
    fixed3 normal : NORMAL;
    fixed4 tangent : TANGENT;
};

struct v2f 
{
    fixed4 pos : SV_POSITION;
    fixed2 uv : TEXCOORD0;
	fixed3 normal : TEXCOORD1;
	#if _WORKFLOW_LIT || _WORKFLOW_PBR_METALLIC || _WORKFLOW_PBR_SPECULAR
		#if _USE_NORMAL_MAP_ON
		fixed3 tangent : TEXCOORD2;
		fixed3 bitangent : TEXCOORD3;
		#endif
		#if _USE_DIFFUSE_TERM_ON && _DIFFUSE_PROCESSING_PER_PIXEL || _USE_SPECULAR_TERM_ON && _SPECULAR_PROCESSING_PER_PIXEL || _USE_NORMAL_MAP_ON
		fixed3 worldPos : TEXCOORD4;
		#endif
	#endif
	
	fixed3 diffuseTerm : COLOR;
	fixed depth : TEXCOORD5;
	#if _USE_RT_SHADOWS_ON
	fixed4 RTShadowCoords : TEXCOORD6;
	#endif
	LIGHTING_COORDS(7,8)
};