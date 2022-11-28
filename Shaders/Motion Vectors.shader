Shader "PS Vita/RenderMotionVector" 
{
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			float4x4 _Previous_MV;
			
			struct v2f 
			{
				float4 pos : SV_POSITION;
				float4 curPos : TEXCOORD0;
				float4 lastPos : TEXCOORD1;
			};
			
			v2f vert(appdata_full v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos( v.vertex);
				o.curPos = o.pos;
				o.lastPos = mul( UNITY_MATRIX_P, mul( _Previous_MV, v.vertex ) );
				
				return o;
			}
	  
			float4 frag(v2f i) : COLOR
			{
				float2 a = (i.curPos.xy / i.curPos.w) * 0.5 + 0.5;
				float2 b = (i.lastPos.xy / i.lastPos.w) * 0.5 + 0.5;
				float2 oVelocity = a - b;
				return float4( oVelocity.x, -oVelocity.y, 0, 1 );
			}
			ENDCG
		}
	}
}