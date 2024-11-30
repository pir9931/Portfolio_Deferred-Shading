Shader "Debug/Normals" {
    SubShader{
        Pass {
            CGPROGRAM
            #pragma vertex vert // vertex ���̴� ��� + �Լ��̸� = vert 
            #pragma fragment frag 
            #include "UnityCG.cginc" // ������ ��� ���� �ڵ����� ���

            struct appdata // ������ ���� ����ü
            { 
                float4 vertex : POSITION; // 4���� �Ǽ� ���� ������ ���͸� ��Ÿ���� �ڷ��� x,y,z,w
                float3 normal : NORMAL; // 3���� �Ǽ� �� ������ ���� �ڷ���
            };

            struct v2f {
                float4 pos : SV_POSITION; // ������ ��ġ�� ��Ÿ���� 'pos' ���� + �ø�ƽ : ���ؽ��� ��ġ��ȯ > ��ũ�� ��ǥ 
                fixed4 color : COLOR; // ���� �Ҽ��� ���� ������ ���͸� ��Ÿ���� �ڷ��� + ���������� ��Ÿ���� �ø�ƽ
            };

            v2f vert(appdata v) //3D ���� �� ���ؽ����� ����Ǵ� ���α׷�
            {
                v2f o;// �ȼ� ���̴��� ������ ���� �ʱ�ȭ
                o.pos = UnityObjectToClipPos(v.vertex); // ���ؽ��� ��ġ�� ��ȯ > Ŭ����ǥ �������� ��ȯ > o.pos ����
                o.color.xyz = v.normal * 0.5 + 0.5; // �븻���� ���� 0.5�� ���ϰ� 0.5�� ���ؼ� ���� 0~1������ ������ ����
                // ���ؽ��� �븻���͸� ������� 0����1������ ���� ������ ��ȯ
                o.color.w = 1.0; // w : ���� 0 = ���� 1 = ������
                return o;
            }

            fixed4 frag(v2f i) : SV_Target { return i.color; } // �������� ���� �� ��ȯ
            // SV_Target �ø�ƽ �ȼ��� ������ ���� ����
            ENDCG
        }
    }
}