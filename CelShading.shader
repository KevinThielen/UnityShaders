// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/CelShading" {
	Properties{
		_Color("Color", Color) = (0, 0, 0, 1)
		_MainTex("Albedo (RGB)", 2D) = "black" {}
	_intensity("Intensity", Range(0,1)) = 0
	}
		SubShader{
		Tags{
		"RenderType" = "Opaque"
	}
		LOD 200




		CGPROGRAM
#pragma surface surf CelShadingForward fullforwardshadows
#pragma target 3.0
#include "AutoLight.cginc"
#define UnityStandardBRDFCustom.cginc


		half _intensity;


	half4 LightingCelShadingForward(SurfaceOutput s, half3 lightDir, half atten) {
		half NdotL = dot(s.Normal, lightDir);

		if (NdotL <= 0.5) NdotL = 0.0;
	//	else if (NdotL <= 0.5) NdotL = 0.5;
		else NdotL = 1;

		half4 c;
		c.rgb = s.Albedo * _LightColor0.rgb * (NdotL  * atten);
		c.a = s.Alpha;

		return c;
	}

	sampler2D _MainTex;
	fixed4 _Color;

	struct Input {
		float2 uv_MainTex;
	};

	void surf(Input IN, inout SurfaceOutput o) {
		fixed4 texColor = tex2D(_MainTex, IN.uv_MainTex);
		fixed4 finalColor = texColor +  _Color;
		o.Albedo = finalColor.rgb;
		o.Alpha = finalColor.a-texColor.a;
	}
	ENDCG

	



	}
	Fallback "Diffuse"
}