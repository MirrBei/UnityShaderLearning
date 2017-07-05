Shader "My/Normal" {
	Properties {
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
        _NormalTex ("Normal Map (XYZ)", 2D) = "bump" {}
        _NormalMapIntensity ("Normal Intensity", Range(0,1)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			float2 uv_NormalTex;
		};

		sampler2D _NormalTex;
        fixed4 _MainTint;
        fixed _NormalMapIntensity;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed3 normal = UnpackNormal(tex2D (_NormalTex, IN.uv_NormalTex));
            normal.x *= _NormalMapIntensity;
            normal.y *= _NormalMapIntensity;
            o.Normal = normalize(normal);
			o.Albedo = _MainTint.rgb;
			o.Alpha = _MainTint.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
