Shader "PS Vita/Internal/Normals, Y & Z Depth"
{
Properties {
    _MainTex ("", 2D) = "white" {}
    _Cutoff ("", Float) = 0.5
    _Color ("", Color) = (1,1,1,1)
}

SubShader {
    Tags { "RenderType"="Opaque" }
    Pass {
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
struct v2f {
    fixed4 pos : SV_POSITION;
    fixed3 normal : TEXCOORD0;
    fixed yDepth : TEXCOORD1;
    fixed zDepth : TEXCOORD2;
};
v2f vert( appdata_base v ) {
    v2f o;
    o.pos = UnityObjectToClipPos(v.vertex);
    o.normal = COMPUTE_VIEW_NORMAL;
    o.yDepth =-UnityObjectToViewPos(v.vertex).y*.25;
    o.zDepth =-UnityObjectToViewPos(v.vertex).z*.015;
;
    return o;
}
fixed4 frag(v2f i) : SV_Target 
{
	fixed3 normal = i.normal;
	normal.xy = EncodeViewNormalStereo (normal);
    return fixed4(normal.rg,i.yDepth,i.zDepth);
}
ENDCG
    }
}

}
