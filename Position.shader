Shader "Unlit/Show UVs"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert // vert 라는 이름의 vertex 쉐이더 사용
            #pragma fragment frag // frag 라는 이름의 fragment 쉐이더 사용

            struct v2f {
                float2 uv : TEXCOORD0; // 텍스쳐 좌표를 나타내는 uv 변수 선언 >> TEXCOORD0 시맨틱 사용 >> UV좌표 받기
                float4 pos : SV_POSITION; // 버텍스의 위치를 나타내는 pos 변수 선언 >> SV_POSITION 시맨틱 사용 >> 버텍스의 위치 지정
                // SV_POSITION 시맨틱은 버텍스 쉐이더에서 출력된 버텍스의 위치를 나타내는 변수를 지정할 때 사용
            };

            v2f vert(
                float4 vertex : POSITION, // 버텍스의 위치를 나타내는 vertex 변수 선언 후 POSITION 시맨틱을 지정하여 해당 변수가 버텍스의 위치정보를 받아옴
                float2 uv : TEXCOORD0 // 텍스쳐 좌표를 나타내는 uv 변수 선언 후 TEXCOORD0 시맨틱을 지정하여 버텍스 쉐이더로부터 텍스쳐 좌표를 출력
                )
            {
                v2f o; // 버텍스 쉐이더로부터 계산된 결과를 프레그먼트 쉐이더로 전달하기 위한 구조체
                o.pos = UnityObjectToClipPos(vertex); // 해당 함수를 이용하여 vertex 변수의 좌표를 클립 공간으로 변환 후 프레그먼트 쉐이더로 전달
                o.uv = uv; // 입력받은 uv 변수를 UV 멤버 변수에 할당
                return o;
            }

            fixed4 frag(v2f i) : SV_Target // SV_Target 시맨틱은 함수의 반환 값이 화면에 출력되는 픽셀의 색상 값을 지정
            {
                return fixed4(i.uv, 0, 0); // 입력받은 uv 멤버 변수 값을 사용하여 색상 값을 계산하고 반환함
            }
            ENDCG
        }
    }
}



