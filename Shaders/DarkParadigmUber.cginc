#include "UberMath.cginc"
#include "UberHelpers.cginc"
#include "Core.cginc"
#include "Members.cginc"

v2f vert (appdata v) 
{
	v2f o;
    
	#ifdef TILING_ON
	o.uv = GetUVForTiling(v.uv, _MainTex);
	#else
    o.uv = v.uv;
	#endif

	#if _USE_VERTEX_DISPLACEMENT_ON
    fixed vertexDisplacement = tex2Dlod(_DisplacementMap, fixed4(o.uv,0,0)).r* 2 - 1;
	v.vertex.xyz = DisplaceVertex(v.vertex, v.normal, vertexDisplacement, _DisplacementIntensity);
	//v.vertex.xyz = v.normal *(vertexDisplacement * _DisplacementIntensity);
	#endif
	
	o.pos = UnityObjectToClipPos(v.vertex);
	fixed3 normal = GetNormal(v.normal);
	#if _USE_AMBIENT_LIGHT_ON && _AMBIENT_LIGHT_PROCESSING_PER_VERTEX
	fixed3 ambient = GetAmbientLight(normal, _AmbientIntensity);
	#endif
	o.normal = normal;

	#if _USE_IBL_ON
		#if _IBL_DIFFUSE_LIGHTING_TYPE_PER_VERTEX
		
			#if _IBL_INPUT_TYPE_PANORAMIC
			fixed3 vertexDiffuseIBL = UnfoldPanoramicIBL(_DiffuseIBLTex, o.normal, _DiffuseIBLIntensity);
			#elif _IBL_INPUT_TYPE_CUBEMAP
			//fixed3 vertexDiffuseIBL = texCUBE(_DiffuseIBLTex, o.pos.xyz).xyz * _DiffuseIBLIntensity;
			fixed3 vertexDiffuseIBL = fixed3(1,1,1);	
			//float4 c = DecodeHDR(vertexDiffuseIBL, _HDR_Tex);	
				#endif

		#endif
	#endif
	
	#if _WORKFLOW_LIT || _WORKFLOW_PBR_METALLIC || _WORKFLOW_PBR_SPECULAR
		#if _USE_NORMAL_MAP_ON || _DIFFUSE_PROCESSING_PER_PIXEL
		o.worldPos = GetWorldPosition(v.vertex);
		#endif
		#if _USE_NORMAL_MAP_ON
		o.tangent = GetPerVertexTangent(v.tangent);
		o.bitangent = GetPerVertexBitangent(normal, o.tangent, v.tangent);
		#endif
	#endif
	
		#if _USE_DIFFUSE_TERM_ON
		
			#if _DIFFUSE_PROCESSING_PER_PIXEL
			o.worldPos = GetWorldPosition(v.vertex);
			#elif _DIFFUSE_PROCESSING_PER_VERTEX
			fixed diffuse = NdotL(normal)
				#if _DIFFUSE_TERM_LIGHTING_MODEL_LAMBERT
				#elif _DIFFUSE_TERM_LIGHTING_MODEL_HALF_LAMBERT
				*0.5 + 0.5
				#endif
			;
				#if _DIFFUSE_TERM_LIGHTING_MODEL_HALF_LAMBERT && _USE_AMBIENT_LIGHT_ON && _AMBIENT_LIGHT_PROCESSING_PER_VERTEX

				ambient *= 0.5 + 0.5;
				#endif
		#endif
	#endif

	#if _USE_RT_SHADOWS_ON 
	o.RTShadowCoords = ComputeCustomShadowCoords(_DirectionalLightDepthVPBias, _DirectionalLightDepthV, v.vertex,_DirectionalLightFarPlane);
	#endif

	
		
		#if _USE_DIFFUSE_TERM_ON && _DIFFUSE_PROCESSING_PER_VERTEX
	o.diffuseTerm = diffuse
			#if _USE_RT_LIGHTING_ON
			* _LightColor0
			#endif
		#endif



		#if _USE_AMBIENT_LIGHT_ON && _AMBIENT_LIGHT_PROCESSING_PER_VERTEX
			#if !_USE_DIFFUSE_TERM_ON
				#if _MULTIPLY_AMBIENT_LIGHT_ON
				o.diffuseTerm = 1 *
				ambient
				#else
				o.diffuseTerm = 
				ambient
				#endif
			#else
				#if _MULTIPLY_AMBIENT_LIGHT_ON
				* ambient 
				#else
				+ ambient
				#endif
			#endif
		#endif
		
		#if _USE_IBL_ON
			#if _MULTIPLY_IBL_ON
			* vertexDiffuseIBL
			#else
			+ vertexDiffuseIBL
			#endif
		#endif
		
		#if _COLOR_CORRECTION_ON
			#if _MULTIPLY_COLOR_CORRECTION
			* _ColorCorrection
			#else
			+ _ColorCorrection
			#endif
		#endif
	;
    
	TRANSFER_VERTEX_TO_FRAGMENT(o);
	o.depth = GetZDepth(v.vertex
	#if _MULTIPLY_DEPTH_ON
	,_DepthMultiplicationFactor
	#endif
	);
	return o;
}

fixed4 frag (v2f i) : SV_Target 
{
 #if _USE_BASEMAP_ON
    fixed3 albedo = tex2D( _MainTex, i.uv );
 #else
	fixed3 albedo = 1;
 #endif

	fixed attenuation = LIGHT_ATTENUATION(i);
	#if _USE_AMBIENT_LIGHT_ON && _AMBIENT_LIGHT_PROCESSING_PER_PIXEL
	fixed3 ambient = ShadeSH9(fixed4(i.normal,1))*_AmbientIntensity;
	#endif
	#if _USE_BASEMAP_TINT_ON
    albedo *= _Color.rgb;
    #endif
	
	#if _RECEIVE_UNITY_SHADOWS_ON
	fixed unityShadows = SHADOW_ATTENUATION(i);
		#if _TINT_SHADOWS_ON
		fixed subShadows = unityShadows;
		unityShadows += _ShadowColor * (1-subShadows)*_DirectionalLightShadowIntensity;
		#else
		unityShadows *= _DirectionalLightShadowIntensity;
		#endif
	#endif

	#if _USE_RT_SHADOWS_ON
	float shadowMap = DecodeFloatRGBA(tex2D(_DirectionalLightStaticShadowmap, i.RTShadowCoords.xy));
	float3 customShadows = max(step(i.RTShadowCoords.z - _DirectionalLightShadowBias, shadowMap), 1-_DirectionalLightShadowIntensity);
		
		#if _TINT_SHADOWS_ON
		fixed subCShadows = customShadows;

		customShadows += _ShadowColor * (1-subCShadows)*_DirectionalLightShadowIntensity;
		#else
		customShadows *= _DirectionalLightShadowIntensity;
		#endif

	#endif
	
	#if _IBL_SPECULAR_LIGHTING_TYPE_PER_PIXEL
    fixed3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
	#endif    
	
#if _WORKFLOW_LIT || _WORKFLOW_PBR_METALLIC || _WORKFLOW_PBR_SPECULAR

	#if _USE_NORMAL_MAP_ON
    
	fixed3 tangentNormals = UnpackNormal( tex2D( _NormalMap, i.uv ) );
		
		#if _USE_NORMAL_INTENSITY_ON
		tangentNormals = normalize( lerp( fixed3(0,0,1), tangentNormals, _NormalIntensity ) );
		#endif
		
	fixed3x3 tangentToWorldSpace = 
	{
		i.tangent.x, i.bitangent.x, i.normal.x,
		i.tangent.y, i.bitangent.y, i.normal.y,
		i.tangent.z, i.bitangent.z, i.normal.z 
	};

	#endif
	#if _USE_DIFFUSE_TERM_ON
		#if _DIFFUSE_PROCESSING_PER_PIXEL
		
			#if _USE_NORMAL_MAP_ON
			fixed3 normal = mul(tangentToWorldSpace, tangentNormals);
			#else	
	        fixed3 normal = normalize(i.normal);
			#endif
	
	        fixed3 lightDir = normalize( UnityWorldSpaceLightDir( i.worldPos ) );
	
			
	        fixed3 diffuseTerm = saturate(dot(normal, lightDir ))
			#if _RT_LIGHTING_MODEL_HALF_LAMBERT
			 *.5 + .5 
			#endif
			;
	
	        #ifdef BASE_PASS
	            #if _IBL_DIFFUSE_LIGHTING_TYPE_PER_PIXEL
				fixed3 diffuseIBL = tex2Dlod( _DiffuseIBLTex, fixed4(DirToRectilinear( normal ),0,0) ).xyz * _DiffuseIBLIntensity;
					#if _LINEAR_TO_GAMMA
					diffuseLight = sqrt(diffuseLight * diffuseIBL); // adds the indirect diffuse lighting
					#else
					diffuseLight *= diffuseIBL; // adds the indirect diffuse lighting
					#endif
				#endif
	        #endif
	





			#if _IBL_SPECULAR_LIGHTING_TYPE_PER_PIXEL
	        // specular lighting
	        
	        fixed3 H = normalize(lightDir + viewDir);
	        //fixed3 R = reflect( -lightDir, normal ); // uses for Phong
	        fixed3 specularIBLLight = saturate(dot(H, normal)) * (diffuseTerm > 0); // Blinn-Phong
	
	        fixed specularExponent = exp2( _Gloss * 11 ) + 2;
	        specularIBLLight = pow( specularIBLLight, specularExponent ) * _Gloss * attenuation * shadows; // specular exponent
	        specularIBLLight *= _LightColor0.xyz;
	    
				#ifdef BASE_PASS
					#if _PIXEL_IBL_SPEC_FRESNEL
					fixed fresnel = pow(1-saturate(dot(viewDir,normal)),5);
					#endif
			
					fixed3 viewRefl = reflect( -viewDir, normal );
					fixed mip = (1-_Gloss)*6;
					fixed3 specularIBL = tex2Dlod( _SpecularIBL, fixed4(DirToRectilinear( viewRefl ),mip,mip) ).xyz;
	
					#if _PIXEL_IBL_SPEC_FRESNEL
				    specularIBLLight += specularIBL * _SpecIBLIntensity * fresnel;
					#else
				    specularIBLLight += specularIBL * _SpecIBLIntensity;
					#endif
		
				#endif
	    
			#endif
	    
			//#if _IBL_SPECULAR_LIGHTING_TYPE_PER_PIXEL
	  //      return fixed4( diffuseLight * albedo + specularIBLLight, i.depth );
			//#else
	  //      return fixed4( diffuseLight * albedo,  i.depth );
			//#endif
	
		#elif _DIFFUSE_PROCESSING_PER_PIXEL
	
			#if _USE_NORMAL_MAP_ON
			fixed3 normal = mul( tangentToWorldSpace, tangentNormals );
	        fixed3 lightDir = normalize( UnityWorldSpaceLightDir( i.worldPos ) );
			albedo *=dot(normal,lightDir);
			#endif    
	
		#endif
	#endif
#endif	
	

	albedo = albedo 
	#if _USE_DIFFUSE_TERM_ON && _DIFFUSE_PROCESSING_PER_VERTEX || _USE_IBL_ON 
	*i.diffuseTerm 
	#endif
	#if _USE_DIFFUSE_TERM_ON && _DIFFUSE_PROCESSING_PER_PIXEL
	* diffuseTerm
	#endif
	#if _USE_AMBIENT_LIGHT_ON && _AMBIENT_LIGHT_PROCESSING_PER_PIXEL
		#if _MULTIPLY_AMBIENT_LIGHT_ON
		* ambient
		#else
		+ ambient
		#endif
	#endif
	#if _USE_RT_SHADOWS_ON
	* customShadows
	#endif
	;

	#if _GAMMA_TO_LINEAR
	albedo *= albedo; // adds the indirect diffuse lighting
	#else
		
		#if _LINEAR_TO_GAMMA
		albedo = sqrt(albedo); // adds the indirect diffuse lighting
		#else
		albedo = albedo; // adds the indirect diffuse lighting
		#endif
	#endif
	
	return fixed4(albedo,i.depth);
} 