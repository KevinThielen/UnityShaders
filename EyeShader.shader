// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/EyeShader" {
	Properties{
		_Color("Color", Color) = (0, 0, 0, 1)
		_EyeOffset("Eye Offset", float) = 0.01
	}
	SubShader{
		Tags{
			"RenderType" = "Opaque"
			"Queue" = "Geometry-1"
			}
		LOD 200

		Pass {
			Cull Back
			
			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag

			struct appdata {
				float4 vertex : POSITION;
			};

			struct v2f {
				float4 position : POSITION;
				float4 color : COLOR;
			};

			fixed4 _Color;
			float _EyeOffset;

			v2f vert(appdata v) {
				v2f o;
				o.color = _Color;
		
				o.position = UnityObjectToClipPos(v.vertex);
				o.position.z -= _EyeOffset;
			//	float3 depthOffset = normalize(WorldSpaceViewDir(v.vertex));
			//	o.position += float4(depthOffset, 1);

				return o;
			}

			fixed4 frag(v2f input) : COLOR {
				return input.color;	
			}
		ENDCG
		}
	}
	Fallback "Diffuse"
}