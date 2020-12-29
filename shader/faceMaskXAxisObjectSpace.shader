// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "face impact mask"
{
	Properties
	{
		_mainTex("mainTex", 2D) = "white" {}
		_faceMask("faceMask", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}
	
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float3 ase_normal : NORMAL;
			};

			uniform sampler2D _faceMask;
			uniform float4 _faceMask_ST;
			uniform sampler2D _mainTex;
			uniform float4 _mainTex_ST;
			float uvfliplogicsimple153( float lightDot )
			{
				return (lightDot<0);
			}
			
			float masktoxaxis( float maskX , float flip )
			{
				float axisX = maskX * 2 - 1;
				if (flip)
				{
					axisX = -axisX;
				}
				return axisX;
			}
			
			inline float softdot44( float In0 )
			{
				return In0*.5+.5;
			}
			
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord.xyz = ase_worldPos;
				float3 objectSpaceLightDir = ObjSpaceLightDir(v.vertex);
				o.ase_texcoord1.xyz = objectSpaceLightDir;
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.zw = 0;
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				fixed4 finalColor;
				float3 ase_worldPos = i.ase_texcoord.xyz;
				float3 worldSpaceLightDir = UnityWorldSpaceLightDir(ase_worldPos);
				float3 objectSpaceLightDir = i.ase_texcoord1.xyz;
				float dotResult93 = dot( float3(1,0,0) , objectSpaceLightDir );
				float lightDot153 = dotResult93;
				float localuvfliplogicsimple153 = uvfliplogicsimple153( lightDot153 );
				float2 uv_faceMask = i.ase_texcoord2.xy * _faceMask_ST.xy + _faceMask_ST.zw;
				float2 appendResult135 = (float2((( localuvfliplogicsimple153 > 0.0 ) ? uv_faceMask.x :  -uv_faceMask.x ) , uv_faceMask.y));
				float maskX39 = tex2D( _faceMask, appendResult135 ).a;
				float flip39 = localuvfliplogicsimple153;
				float localmasktoxaxis39 = masktoxaxis( maskX39 , flip39 );
				float3 appendResult55 = (float3(( ( localmasktoxaxis39 + i.ase_normal.x ) * 0.5 ) , i.ase_normal.y , i.ase_normal.z));
				float3 normalizeResult56 = normalize( appendResult55 );
				float4 transform152 = mul(unity_ObjectToWorld,float4( normalizeResult56 , 0.0 ));
				float dotResult42 = dot( float4( worldSpaceLightDir , 0.0 ) , transform152 );
				float In044 = dotResult42;
				float localsoftdot44 = softdot44( In044 );
				float2 uv_mainTex = i.ase_texcoord2.xy * _mainTex_ST.xy + _mainTex_ST.zw;
				
				
				finalColor = float4( ( saturate( (0.25 + (localsoftdot44 - 0.0) * (1.0 - 0.25) / (1.0 - 0.0)) ) * (tex2D( _mainTex, uv_mainTex )).rgb ) , 0.0 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=15401
0;561;1047;274;2794.021;699.3331;2.027344;True;True
Node;AmplifyShaderEditor.CommentaryNode;118;-1633.267,-556.3178;Float;False;280.5317;180.2986;is light side;2;93;101;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;146;-2146.579,-669.7512;Float;True;Property;_faceMask;faceMask;1;0;Create;True;0;0;False;0;4d0f51749e08d2a44bd2be3197e62ba9;4d0f51749e08d2a44bd2be3197e62ba9;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.Vector3Node;101;-1628.816,-519.3489;Float;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjSpaceLightDirHlpNode;76;-2121.206,-311.6871;Float;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;83;-2037.341,-919.0376;Float;False;0;146;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;93;-1468.816,-519.3489;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;111;-1014.779,-719.4416;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;153;-1242.807,-544.3987;Float;False;return (lightDot<0)@;1;False;1;True;lightDot;FLOAT;0;In;;uv flip logic simple;True;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;132;-864.7901,-799.4149;Float;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;135;-821.2829,-633.0786;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;36;-661.3084,-698.7945;Float;True;Property;_mask;mask;1;0;Create;True;0;0;False;0;4d0f51749e08d2a44bd2be3197e62ba9;4d0f51749e08d2a44bd2be3197e62ba9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;39;-844.5214,-348.7258;Float;False;float axisX = maskX * 2 - 1@$if (flip)${$	axisX = -axisX@$}$return axisX@;1;False;2;True;maskX;FLOAT;0;In;;True;flip;FLOAT;0;In;;mask to x axis;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;144;-599.1816,-434.4774;Float;False;271.9291;148.7906;average x axis;2;142;141;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalVertexDataNode;35;-2118.044,-471.8946;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;141;-583.1816,-386.4774;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-455.7272,-386.4774;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;-584.9379,-263.9947;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;143;-39.95585,-921.5085;Float;False;585.4312;275.0375;simple toon ramp;6;51;42;50;44;45;152;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalizeNode;56;-431.2105,-266.4415;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;45;-7.547638,-889.1564;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;152;-34.11668,-801.8283;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;42;152.9234,-746.2858;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;44;238.3858,-885.7208;Float;False;In0*.5+.5;1;False;1;True;In0;FLOAT;0;In;;soft dot;True;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;-305.4084,-102.3945;Float;True;Property;_mainTex;mainTex;0;0;Create;True;0;0;False;0;f8547299372dd7f4cb494a08b4f4d695;f8547299372dd7f4cb494a08b4f4d695;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;50;275.0319,-814.9315;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.25;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;23;11.94027,-16.66128;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;127;-1641.735,-778.43;Float;False;295.5018;199.3831;is object side;2;128;130;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;119;-1638.507,-357.4798;Float;False;299.538;152.2535;is uv side;2;104;107;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;51;405.1677,-881.8991;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;128;-1465.735,-730.43;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;89;100.4163,-212.0969;Float;False;In0*.5+.5;3;False;1;True;In0;FLOAT3;0,0,0;In;;soft dot;True;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;264.0612,-96.44273;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode;104;-1448.407,-303.9171;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-1626.06,-312.0231;Float;False;Constant;_Float8;Float 8;3;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;130;-1625.735,-730.43;Float;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;False;0;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;145;480.3078,-186.5628;Float;False;True;2;Float;ASEMaterialInspector;0;1;face impact mask;0770190933193b94aaa3065e307002fa;0;0;SubShader 0 Pass 0;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;-1;False;-1;-1;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque;True;2;0;False;False;False;False;False;False;False;False;False;False;0;;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;83;2;146;0
WireConnection;93;0;101;0
WireConnection;93;1;76;0
WireConnection;111;0;83;1
WireConnection;153;0;93;0
WireConnection;132;0;153;0
WireConnection;132;2;83;1
WireConnection;132;3;111;0
WireConnection;135;0;132;0
WireConnection;135;1;83;2
WireConnection;36;0;146;0
WireConnection;36;1;135;0
WireConnection;39;0;36;4
WireConnection;39;1;153;0
WireConnection;141;0;39;0
WireConnection;141;1;35;1
WireConnection;142;0;141;0
WireConnection;55;0;142;0
WireConnection;55;1;35;2
WireConnection;55;2;35;3
WireConnection;56;0;55;0
WireConnection;152;0;56;0
WireConnection;42;0;45;0
WireConnection;42;1;152;0
WireConnection;44;0;42;0
WireConnection;50;0;44;0
WireConnection;23;0;22;0
WireConnection;51;0;50;0
WireConnection;128;0;130;0
WireConnection;128;1;35;0
WireConnection;89;0;56;0
WireConnection;20;0;51;0
WireConnection;20;1;23;0
WireConnection;104;0;83;1
WireConnection;104;1;107;0
WireConnection;145;0;20;0
ASEEND*/
//CHKSM=04FD2F99DAE0EDBED4D212C5450F8EADBAA50A1C