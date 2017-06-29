Shader "Custom/MyPhong" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SpecularColor ("Specular Color (RGB)", Color) = (1,1,1)
        _SpecularPower ("Specular Power", Range(1, 30)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Phong

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		fixed4 _Color;
		sampler2D_half _MainTex;
        fixed3 _SpecularColor;
        fixed _SpecularPower;

		struct Input {
			float2 uv_MainTex;
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

        fixed4 LightingPhong(SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten) {
            fixed NdotL = max(0, dot(lightDir, s.Normal));
            fixed3 halfVector = normalize(viewDir + lightDir);
            fixed spec = pow(max(0, dot(s.Normal, halfVector)), _SpecularPower);

            fixed4 c;
            c.rgb = s.Albedo*_LightColor0.rgb*NdotL*atten + _SpecularColor*_LightColor0.rgb*spec;
            c.a = s.Alpha;
            return c;
        }

		ENDCG
	}
	FallBack "Diffuse"
}
