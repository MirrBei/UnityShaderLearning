Shader "Vertex/AnimatingVertices" {
	Properties {
        _MainTex    ("Base (RGB)", 2D) = "white" {}
        _TintAmount ("Tint Amount", Range(0,1)) = 0.5
        _ColorA     ("Color A", Color) = (1,1,1,1)
        _ColorB     ("Color B", Color) = (1,1,1,1)
        _Speed      ("Wave Speed", Range(0,80)) = 5
        _Frequency  ("Wave Frequency", Range(0,5)) = 2
        _Amplitude  ("Wave Amplitude", Range(-1,1)) = 1
        _OffsetVal  ("Offset", Range(0,1)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0


		struct Input {
            float2 uv_MainTex;
            float gray;
		};

        sampler2D _MainTex;
        float _TintAmount;
        fixed4 _ColorA;
        fixed4 _ColorB;
        fixed _Speed;
        half _Frequency;
        float _Amplitude;
        float _OffsetVal;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

        void vert (inout appdata_full v, out Input o) {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            fixed time = _Time.x * _Speed;
            float s = sin(time + v.vertex.x*_Frequency);
            float waveValueA = s * _Amplitude;
            v.vertex.y += waveValueA;
            o.gray = (s+1)/2;
        }

		void surf (Input IN, inout SurfaceOutput o) {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 tint = lerp(_ColorA, _ColorB, IN.gray) * _TintAmount;
            o.Albedo = c.rgb * tint;
            o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
