Shader "Bumped ColoredSpecular" {
    Properties
    {
        _Color("Main Color", Color) = (1,1,1,1) // RGBA 형식의 컬러 값을 나타내는 속성
        _SpecColor("Specular Color", Color) = (0.5, 0.5, 0.5, 1) // RGBA 형식의 스펙큘러 컬러를 나타내는 속성
        _Shininess("Shininess", Range(0.03, 1)) = 0.078125 // 광택 정도를 나타내는 속성
        _MainTex("Base (RGB) Gloss (A)", 2D) = "white" {} // 베이스 컬러와 광택 맵을 나타내는 속성
        _BumpMap("Normalmap", 2D) = "bump" {} // 노멀 맵 텍스쳐를 위부에서 전달 하는 노멀 맵을 나타내는 속성
        _SpecTex("Spec (RGB)", 2D) = "white" {} // 스펙큘러 맵을 나타내는 속성
    }
        SubShader{
            Tags { "RenderType" = "Opaque" } // 불투명한 오브젝트 생성
            LOD 400 // Level Of Detail 낮을 수록 높다

        CGPROGRAM
        #pragma surface surf BlinnPhong // 서피스 쉐이더는 입력과 출력을 이용하여 표면 특성을 계산 + BlinnPhong은 빛의 반사와 음영을 계산하는데 사용

        sampler2D _MainTex; // 메인텍스쳐를 나타내는 변수
        sampler2D _BumpMap; // 노멀 맵을 나타내는 변수
        sampler2D _SpecTex; // 스펙큘러 맵을 나타내는 변수
        float4 _Color; // 색상을 나타내는 변수
        float _Shininess; // 광택을 나타내는 변수

        struct Input {
            float2 uv_MainTex; // 메인텍스쳐의 uv좌표를 나타내는 변수
            float2 uv_BumpMap; // 노멀 맵의 uv 좌표를 나타내는 변수
        };

        void surf(Input IN, inout SurfaceOutput o) {
            half4 tex = tex2D(_MainTex, IN.uv_MainTex); // IN.uv._MainTex 좌표에 메인텍스쳐를 매핑하여 저장
            half4 spectex = tex2D(_SpecTex, IN.uv_MainTex); //  IN.uv._MainTex 좌표에 스펙큘러 텍스쳐를 매핑하여 저장
            _SpecColor = spectex; // 입력받은 스펙큘러 맵 텍스쳐를 _SpecColor에 저장

            o.Albedo = tex.rgb * _Color.rgb; // 메인텍스쳐에서 가져온 RGB 색상 값을  _Color.rgb 값에 곱하여 최종적인 표면 색을 할당
            o.Gloss = tex.a; // 메인텍스쳐에서 투명도 값을 할당
            o.Alpha = tex.a * _Color.a; // 투명도 값과 _Color에서 가져온 값을 곱하여 최종적은 투명도 값을 할당
            o.Specular = _Shininess; // _Shininess 변수에 저장된 광택 값을 할당
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap)); // IN.uv_BumpMap 좌표에 해당하는 _BumbMap 텍스쳐 값을 가져와 언팩 하여 할당 
        }
        ENDCG
    }

        FallBack "Specular" // 서브쉐이더가 지원되지 않을 경우 대체로 사용하도록 지정
}




    