Shader "Unlit/ColorBuffer"
{
    Properties // 인스펙터 창 표시
    {
        _MainTex("Texture", 2D) = "" {} // 인스펙터에 Texture라는 속성 생성
        _Color("Color", Color) = (1,1,1,1)
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM // CG언어를 이용하여 쉐이더 작성
            #pragma vertex vert // vertex 코드는 vert
            #pragma fragment frag // fragment 코드는 frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "UnityDeferredLibrary.cginc"
            #include "UnityGBuffer.cginc"  // 지정된 경로 안의 코드파일 사용
            sampler2D _CameraGBufferTexture0;
            struct appdata // 데이터 선언 구조체
            {
                // 시맨틱 : 그래픽스에서 API에서 사용되는 태그 위치 : POSITION / 법선 : NORMAL
                float4 vertex : POSITION; // 4개의 실수 값을 가지는 벡터를 나타내는 자료형 x,y,z,w
                float2 uv : TEXCOORD0; // 텍스쳐 좌표와 같은 임의의 위치 정밀도가 높은 데이터 표시
            };

            struct v2f
            {
                float2 uv : TEXCOORD0; // 버텍스 쉐이더에서 입력받은 텍스쳐 좌표 데이터를 float2 형식의 UV 변수로 선언
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION; // 데이터에 각 버텍스 위치가 포함
            };  // SystemValue 프래그먼트 쉐이더로 전달되는 버텍스의 위치를 나타냄

            sampler2D _MainTex; // 2D 텍스처를 나타내는 변수 선언 구문
            float4 _MainTex_ST;


            v2f vert(appdata v) //3D 모델의 각 버텍스에서 실행되는 프로그램
            {
                v2f o; // 픽셀 쉐이더에 전달할 정보 초기화
                o.vertex = UnityObjectToClipPos(v.vertex); // 각 버텍스를 화면에 배치
                o.uv = TRANSFORM_TEX(v.uv, _MainTex); // 텍스처 좌표를 변환하여 o의 uv멤버에 할당
                return o;
            }
            // 사용 X
            fixed4 frag(v2f i) : SV_Target // 결과를 어떠한 렌더에 보낼지 설정
            {
                half4 gbuffer = tex2D(_CameraGBufferTexture0,float2(i.uv.x, 1 - i.uv.y));
                return gbuffer;
            }
           ENDCG
        }
    }
}