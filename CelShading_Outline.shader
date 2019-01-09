// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/CelShadingOutline" {
	Properties{
		_Color("Color", Color) = (0, 0, 0, 1)
		_MainTex("Albedo (RGB)", 2D) = "black" {}
		_OutlineThickness("Outline Thickness", Range(0.0, 0.05)) = 0.03
		_OutlineColor("Outline Color", Color) = (0,0,0,1)
	}
	
	SubShader{
		Tags{
		  "RenderType" = "Opaque"
	    }
		LOD 200

		//CelShading			
			CGPROGRAM
	
			#pragma surface surf CelShadingForward addshadow
			#pragma target 5.0
			#include "AutoLight.cginc"
			#define UnityStandardBRDFCustom.cginc

			struct Input {
				float2 uv_MainTex;
			};


			half4 LightingCelShadingForward(SurfaceOutput s, half3 lightDir, half atten) {
				half NdotL = dot(s.Normal, lightDir);

				if (NdotL <= 0.5) NdotL = 0.0;
				else NdotL = 1;

				half4 c;
				c.rgb = s.Albedo * _LightColor0.rgb * NdotL  * atten * 2;
				c.a = s.Alpha;

				return c;
			}

			uniform sampler2D _MainTex;
			uniform fixed4 _Color;
			
			void surf(Input IN, inout SurfaceOutput o) {

				fixed4 texColor = tex2D(_MainTex, IN.uv_MainTex);
				fixed4 finalColor = texColor +  _Color;
		
				o.Albedo = finalColor.rgb;
				o.Alpha = _Color.a;
			}
			ENDCG

		//Outline
		Pass {
			Cull Front
			
			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert 
			#pragma fragment frag 


			float _OutlineThickness;
			half4 _OutlineColor;

			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 pos : POSITION;
				float4 color : COLOR;
			};


			v2f vert(appdata v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

			    float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
                float2 offset = TransformViewToProjection(norm.xy);
 
				o.pos.xy += offset * o.pos.z * _OutlineThickness;
				o.color = _OutlineColor;
				return o;
			}

			half4 frag(v2f i) : COLOR{
				return i.color;
			}

			ENDCG
		}
	}
	Fallback "VertexLit"
}