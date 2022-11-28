#define PI_TWO 6.283185307180

#include "UnityCG.cginc"
fixed _Exposure;


	fixed2 Rotate( fixed2 v, fixed angRad ) 
	{
	    fixed ca = cos( angRad );
	    fixed sa = sin( angRad );
	    return fixed2( ca * v.x - sa * v.y, sa * v.x + ca * v.y );
	}
	//Corrctly Sample Panoramic IBL
	fixed2 DirToRectilinear( fixed3 dir ) 
	{
	    fixed x = atan2( dir.z, dir.x ) / PI_TWO + 0.5; // 0-1
	    fixed y = dir.y * 0.5 + 0.5; // 0-1
	    return fixed2(x,y);
	}
	fixed3 UnfoldPanoramicIBL (sampler2D ibl, fixed3 normal, fixed intensity)
	{
		return tex2Dlod(ibl, fixed4(DirToRectilinear(normalize(normal)),0,0)).xyz * intensity;
	}
	//Vertex Displacement
	fixed UnpackVertexDisplacementMap (sampler2D displacementMap, fixed2 uv)
	{
		fixed VertexDisplacementMap;
		VertexDisplacementMap = tex2Dlod(displacementMap, fixed4(uv,0,0)).r* 2 - 1;
		return VertexDisplacementMap;
	}
    fixed3 DisplaceVertex(fixed4 vertex, fixed3 vertexNormal, fixed vertexDisplacement, fixed intensity)
	{
		fixed3 vertexPos;
		return vertexPos = vertex.xyz + vertexNormal *(vertexDisplacement * intensity);
	}
	//Normal
	fixed3 GetNormal(fixed3 vertexNormal)
	{
		fixed3 inormal;
		return inormal = UnityObjectToWorldNormal(vertexNormal);
	}
	//Lambert Shading
	fixed NdotL(fixed3 normalDirection)
	{
		normalDirection = normalize(normalDirection);
		fixed3 lightDirection = normalize(_WorldSpaceLightPos0);
		fixed ndotl;
		return ndotl = max(0.0,dot(normalDirection,lightDirection))
		#if _LIGHTING_MODEL_HALF_LAMBERT
		* 0.5 + 0.5
		#endif
		;
	}
	//Ambient Lighting
	fixed3 GetAmbientLight(fixed3 normal, fixed intensity)
	{
		fixed3 ambient;
		return ambient = ShadeSH9(fixed4(normal,1)) * intensity;
	}
	//Depth for Alpha Channel
	fixed GetZDepth(fixed4 vertex 
	#if _MULTIPLY_DEPTH_ON
	, fixed multFactor
	#endif
	)
	{
		fixed zDepth;
		zDepth =-UnityObjectToViewPos(vertex).z * .015
		#if _MULTIPLY_DEPTH_ON
		*multFactor
		#else
		#endif
		;
		return zDepth;
	}
	//Tiling UVs
	fixed4 tex_ST;
	fixed2 GetUVForTiling(fixed2 uv, sampler2D tex)
	{
		fixed2 UVForTiling;
		return UVForTiling = TRANSFORM_TEX(uv, tex);
    }
	//World Position
	fixed4 GetWorldPosition(fixed4 vertex)
	{
		fixed4 worldPos;
		return worldPos = mul(unity_ObjectToWorld, vertex);
	}
	//Tangent
	fixed3 GetPerVertexTangent(fixed4 tangent)
	{
		fixed3 tan;
		return tan = UnityObjectToWorldDir(tangent.xyz);
	}
	//Bitangent
	fixed3 GetPerVertexBitangent(fixed3 normal, fixed3 FTangent, fixed4 VTangent)
	{
		fixed3 bitan;
		bitan = cross(normal,FTangent);
		bitan *= VTangent.w * unity_WorldTransformParams.w;
		return bitan;
	}
	//Custom Shadowmapping
	fixed4 ComputeCustomShadowCoords(half4x4 lightDepthVPBias, half4x4 lightDepthV, fixed4 vertex, fixed farPlane )
	{
		fixed4 ShadowCoords;
		ShadowCoords = mul(lightDepthVPBias, mul(unity_ObjectToWorld, vertex));
		ShadowCoords.z = -(mul(lightDepthV, mul(unity_ObjectToWorld, vertex)).z * farPlane);
		return ShadowCoords;
	}

	//Image Effects Misc Adjustments
	fixed3 AdjustContrast(fixed3 color, fixed contrast) 
	{
		return saturate(lerp(fixed3(0.5, 0.5, 0.5), color, contrast));
	}
	fixed3 tonemapACES(fixed3 color)
	{
		color *= _Exposure;
		
		fixed3 a = 2.51f;
		fixed3 b = 0.03f;
		fixed3 c = 2.43f;
		fixed3 d = 0.59f;
		fixed3 e = 0.14f;
		return saturate((color * (a * color + b)) / (color * (c * color + d) + e));
	}
	fixed3 tonemapPhotographic(fixed3 color)
	{
		color *= _Exposure;
		return 1.0 - exp2(-color);
	}
	fixed3 tonemapHable(fixed3 color)
	{
		const fixed a = 0.15;
		const fixed b = 0.50;
		const fixed c = 0.10;
		const fixed d = 0.20;
		const fixed e = 0.02;
		const fixed f = 0.30;
		const fixed w = 11.2;

		color *= _Exposure * 2.0;
		fixed3 curr = ((color * (a * color + c * b) + d * e) / (color * (a * color + b) + d * f)) - e / f;
		color = w;
		fixed3 whiteScale = 1.0 / (((color * (a * color + c * b) + d * e) / (color * (a * color + b) + d * f)) - e / f);
		return curr * whiteScale;
	}
	fixed3 tonemapHejlDawson(fixed3 color)
	{
		const fixed a = 6.2;
		const fixed b = 0.5;
		const fixed c = 1.7;
		const fixed d = 0.06;

		color *= _Exposure;
		color = max((0.0).xxx, color - (0.004).xxx);
		color = (color * (a * color + b)) / (color * (a * color + c) + d);
		return color * color;
	}
	fixed3 tonemapReinhard(fixed3 color)
	{
		//fixed lum = Luminance(color);
		fixed lum = color.rgb;//Luminance(color);
		fixed lumTm = lum * _Exposure;
		fixed scale = lumTm / (1.0 + lumTm);
		return color * scale / lum;
	}
	fixed3 applyLUT(sampler2D tex, fixed3 uvw, fixed3 scaleOffset)
	{
		uvw.z *= scaleOffset.z;
		fixed shift = floor(uvw.z);
		uvw.xy = uvw.xy * scaleOffset.z * scaleOffset.xy + scaleOffset.xy * 0.5;
		uvw.x += shift * scaleOffset.y;
		uvw.xyz = lerp(tex2D(tex, uvw.xy).rgb, tex2D(tex, uvw.xy + fixed2(scaleOffset.y, 0)).rgb, uvw.z - shift);
		return uvw;
	}
	//Image Effects View Direction
	fixed4 GetViewDirToFrag(fixed2 vertexUV)
	{
		fixed3 screenCoords = fixed3(vertexUV*2-1,1);
		screenCoords = screenCoords.xyzz;
		fixed4 viewDirToFrag;
		viewDirToFrag = mul(unity_CameraInvProjection, fixed4(screenCoords.xyz,-screenCoords.z));
		viewDirToFrag.xyz *= -1;
		viewDirToFrag = mul(unity_CameraToWorld, fixed4(viewDirToFrag.xyz,0));
		return viewDirToFrag;
	}