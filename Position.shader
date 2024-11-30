Shader "Unlit/Show UVs"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert // vert ��� �̸��� vertex ���̴� ���
            #pragma fragment frag // frag ��� �̸��� fragment ���̴� ���

            struct v2f {
                float2 uv : TEXCOORD0; // �ؽ��� ��ǥ�� ��Ÿ���� uv ���� ���� >> TEXCOORD0 �ø�ƽ ��� >> UV��ǥ �ޱ�
                float4 pos : SV_POSITION; // ���ؽ��� ��ġ�� ��Ÿ���� pos ���� ���� >> SV_POSITION �ø�ƽ ��� >> ���ؽ��� ��ġ ����
                // SV_POSITION �ø�ƽ�� ���ؽ� ���̴����� ��µ� ���ؽ��� ��ġ�� ��Ÿ���� ������ ������ �� ���
            };

            v2f vert(
                float4 vertex : POSITION, // ���ؽ��� ��ġ�� ��Ÿ���� vertex ���� ���� �� POSITION �ø�ƽ�� �����Ͽ� �ش� ������ ���ؽ��� ��ġ������ �޾ƿ�
                float2 uv : TEXCOORD0 // �ؽ��� ��ǥ�� ��Ÿ���� uv ���� ���� �� TEXCOORD0 �ø�ƽ�� �����Ͽ� ���ؽ� ���̴��κ��� �ؽ��� ��ǥ�� ���
                )
            {
                v2f o; // ���ؽ� ���̴��κ��� ���� ����� �����׸�Ʈ ���̴��� �����ϱ� ���� ����ü
                o.pos = UnityObjectToClipPos(vertex); // �ش� �Լ��� �̿��Ͽ� vertex ������ ��ǥ�� Ŭ�� �������� ��ȯ �� �����׸�Ʈ ���̴��� ����
                o.uv = uv; // �Է¹��� uv ������ UV ��� ������ �Ҵ�
                return o;
            }

            fixed4 frag(v2f i) : SV_Target // SV_Target �ø�ƽ�� �Լ��� ��ȯ ���� ȭ�鿡 ��µǴ� �ȼ��� ���� ���� ����
            {
                return fixed4(i.uv, 0, 0); // �Է¹��� uv ��� ���� ���� ����Ͽ� ���� ���� ����ϰ� ��ȯ��
            }
            ENDCG
        }
    }
}



