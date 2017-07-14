Shader "My/Anisotropic" {
    Properties {
        _MainTint ("Diffuse Tint", Color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _SpecularColor ("specular Color", Color) = (1,1,1,1)
        _Specular ("Specular Amount", Range(0,1)) = 0.5
        _SpecPower ("Specular Power", Range(0.01,1)) = 0.5
        _AnisoDir ("Anisotropic Direction", 2D) = "" {}
        _AnisoOffset ("Anisotropic Offset", Range(-1,1)) = -0.2
    }
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200 
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Anisotropic

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

        sampler2D _AnisoDir;
        sampler2D _MainTex;
        float4 _MainTint;
        float4 _SpecularColor;
        float _AnisoOffset;
        float _Specular;
        fixed _SpecPower;

        struct Input {
            float2 uv_MainTex;
        };

        struct SurfaceAnisoOutput
        {
            fixed3 Albedo;
            fixed Alpha;
            fixed3 Emission;
            fixed3 Normal;
            fixed3 AnisoDirection;
        };

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceAnisoOutput o) {
            half4 c = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
            float3 anisoTex = UnpackNormal(tex2D(_AnisoDir,
                IN.uv_MainTex));
            o.AnisoDirection = anisoTex;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
		}

        fixed4 LightingAnisotropic(SurfaceAnisoOutput s, half3 lightDir, half3 viewDir, fixed atten) {
            fixed3 anisoDir = normalize(s.Normal + s.AnisoDirection);
            float AdotL = max(0, dot(anisoDir, lightDir));
            fixed3 reflectionDir = AdotL * 2 * anisoDir - lightDir;
            fixed RdotV = dot(reflectionDir, viewDir);
            float aniso = max(0, sin(radians((RdotV + _AnisoOffset) * 180)));
            float spec = saturate(pow(aniso, _SpecPower * 128) * _Specular);
            fixed4 c;
            c.rgb = ((s.Albedo * _LightColor0.rgb * max(0, dot(s.Normal, lightDir))) + (_LightColor0.rgb * _SpecularColor.rgb * spec)) * atten;
            c.a = s.Alpha;
            return c;
        }

		ENDCG
	}
	FallBack "Diffuse"
}
