Shader "Custom/MyToon" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
        _MainTex ("MainTex (RGB)", 2D) = "white" {}
        _CelShadingLevels ("Cel Shading Levels", Range(1, 30)) = 10
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Toon fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		fixed4 _Color;
        sampler2D _MainTex;
        fixed _CelShadingLevels;

		struct Input {
			fixed2 uv_MainTex;
		};

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

        fixed4 LightingToon(SurfaceOutput s, fixed3 lightDir, fixed atten) {
            fixed NdotL = dot(s.Normal, lightDir);
            NdotL = floor(NdotL*_CelShadingLevels) / _CelShadingLevels; //tex2D(_RampTex, fixed2(NdotL, 0.5));
            fixed4 c;
            c.rgb = s.Albedo*_LightColor0.rgb*NdotL*atten;
            c.a = s.Alpha;
            return c;
        }

		ENDCG
	}
	FallBack "Diffuse"
}
