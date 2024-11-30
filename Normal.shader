Shader "Debug/Normals" {
    SubShader{
        Pass {
            CGPROGRAM
            #pragma vertex vert // vertex 쉐이더 사용 + 함수이름 = vert 
            #pragma fragment frag 
            #include "UnityCG.cginc" // 지정된 경로 안의 코드파일 사용

            struct appdata // 데이터 선언 구조체
            { 
                float4 vertex : POSITION; // 4개의 실수 값을 가지는 벡터를 나타내는 자료형 x,y,z,w
                float3 normal : NORMAL; // 3개의 실수 값 가지는 벡터 자료형
            };

            struct v2f {
                float4 pos : SV_POSITION; // 정점의 위치를 나타내는 'pos' 변수 + 시맨틱 : 버텍스의 위치변환 > 스크린 좌표 
                fixed4 color : COLOR; // 고정 소수점 값을 가지는 벡터를 나타내는 자료형 + 색상정보를 나타내는 시맨틱
            };

            v2f vert(appdata v) //3D 모델의 각 버텍스에서 실행되는 프로그램
            {
                v2f o;// 픽셀 쉐이더에 전달할 정보 초기화
                o.pos = UnityObjectToClipPos(v.vertex); // 버텍스의 위치를 변환 > 클립좌표 공간으로 변환 > o.pos 저장
                o.color.xyz = v.normal * 0.5 + 0.5; // 노말벡터 값에 0.5를 곱하고 0.5를 더해서 값을 0~1사이의 범위로 조정
                // 버텍스의 노말벡터를 기반으로 0에서1까지의 색상 값으로 변환
                o.color.w = 1.0; // w : 투명도 0 = 투명 1 = 불투명
                return o;
            }

            fixed4 frag(v2f i) : SV_Target { return i.color; } // 최종적인 색상 값 반환
            // SV_Target 시맨틱 픽셀의 색상의 색상 정의
            ENDCG
        }
    }
}