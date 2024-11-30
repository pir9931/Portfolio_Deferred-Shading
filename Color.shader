Shader "Unlit/ColorBuffer"
{
    Properties // �ν����� â ǥ��
    {
        _MainTex("Texture", 2D) = "" {} // �ν����Ϳ� Texture��� �Ӽ� ����
        _Color("Color", Color) = (1,1,1,1)
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM // CG�� �̿��Ͽ� ���̴� �ۼ�
            #pragma vertex vert // vertex �ڵ�� vert
            #pragma fragment frag // fragment �ڵ�� frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "UnityDeferredLibrary.cginc"
            #include "UnityGBuffer.cginc"  // ������ ��� ���� �ڵ����� ���
            sampler2D _CameraGBufferTexture0;
            struct appdata // ������ ���� ����ü
            {
                // �ø�ƽ : �׷��Ƚ����� API���� ���Ǵ� �±� ��ġ : POSITION / ���� : NORMAL
                float4 vertex : POSITION; // 4���� �Ǽ� ���� ������ ���͸� ��Ÿ���� �ڷ��� x,y,z,w
                float2 uv : TEXCOORD0; // �ؽ��� ��ǥ�� ���� ������ ��ġ ���е��� ���� ������ ǥ��
            };

            struct v2f
            {
                float2 uv : TEXCOORD0; // ���ؽ� ���̴����� �Է¹��� �ؽ��� ��ǥ �����͸� float2 ������ UV ������ ����
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION; // �����Ϳ� �� ���ؽ� ��ġ�� ����
            };  // SystemValue �����׸�Ʈ ���̴��� ���޵Ǵ� ���ؽ��� ��ġ�� ��Ÿ��

            sampler2D _MainTex; // 2D �ؽ�ó�� ��Ÿ���� ���� ���� ����
            float4 _MainTex_ST;


            v2f vert(appdata v) //3D ���� �� ���ؽ����� ����Ǵ� ���α׷�
            {
                v2f o; // �ȼ� ���̴��� ������ ���� �ʱ�ȭ
                o.vertex = UnityObjectToClipPos(v.vertex); // �� ���ؽ��� ȭ�鿡 ��ġ
                o.uv = TRANSFORM_TEX(v.uv, _MainTex); // �ؽ�ó ��ǥ�� ��ȯ�Ͽ� o�� uv����� �Ҵ�
                return o;
            }
            // ��� X
            fixed4 frag(v2f i) : SV_Target // ����� ��� ������ ������ ����
            {
                half4 gbuffer = tex2D(_CameraGBufferTexture0,float2(i.uv.x, 1 - i.uv.y));
                return gbuffer;
            }
           ENDCG
        }
    }
}