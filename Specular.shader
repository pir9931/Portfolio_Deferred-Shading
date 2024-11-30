Shader "Bumped ColoredSpecular" {
    Properties
    {
        _Color("Main Color", Color) = (1,1,1,1) // RGBA ������ �÷� ���� ��Ÿ���� �Ӽ�
        _SpecColor("Specular Color", Color) = (0.5, 0.5, 0.5, 1) // RGBA ������ ����ŧ�� �÷��� ��Ÿ���� �Ӽ�
        _Shininess("Shininess", Range(0.03, 1)) = 0.078125 // ���� ������ ��Ÿ���� �Ӽ�
        _MainTex("Base (RGB) Gloss (A)", 2D) = "white" {} // ���̽� �÷��� ���� ���� ��Ÿ���� �Ӽ�
        _BumpMap("Normalmap", 2D) = "bump" {} // ��� �� �ؽ��ĸ� ���ο��� ���� �ϴ� ��� ���� ��Ÿ���� �Ӽ�
        _SpecTex("Spec (RGB)", 2D) = "white" {} // ����ŧ�� ���� ��Ÿ���� �Ӽ�
    }
        SubShader{
            Tags { "RenderType" = "Opaque" } // �������� ������Ʈ ����
            LOD 400 // Level Of Detail ���� ���� ����

        CGPROGRAM
        #pragma surface surf BlinnPhong // ���ǽ� ���̴��� �Է°� ����� �̿��Ͽ� ǥ�� Ư���� ��� + BlinnPhong�� ���� �ݻ�� ������ ����ϴµ� ���

        sampler2D _MainTex; // �����ؽ��ĸ� ��Ÿ���� ����
        sampler2D _BumpMap; // ��� ���� ��Ÿ���� ����
        sampler2D _SpecTex; // ����ŧ�� ���� ��Ÿ���� ����
        float4 _Color; // ������ ��Ÿ���� ����
        float _Shininess; // ������ ��Ÿ���� ����

        struct Input {
            float2 uv_MainTex; // �����ؽ����� uv��ǥ�� ��Ÿ���� ����
            float2 uv_BumpMap; // ��� ���� uv ��ǥ�� ��Ÿ���� ����
        };

        void surf(Input IN, inout SurfaceOutput o) {
            half4 tex = tex2D(_MainTex, IN.uv_MainTex); // IN.uv._MainTex ��ǥ�� �����ؽ��ĸ� �����Ͽ� ����
            half4 spectex = tex2D(_SpecTex, IN.uv_MainTex); //  IN.uv._MainTex ��ǥ�� ����ŧ�� �ؽ��ĸ� �����Ͽ� ����
            _SpecColor = spectex; // �Է¹��� ����ŧ�� �� �ؽ��ĸ� _SpecColor�� ����

            o.Albedo = tex.rgb * _Color.rgb; // �����ؽ��Ŀ��� ������ RGB ���� ����  _Color.rgb ���� ���Ͽ� �������� ǥ�� ���� �Ҵ�
            o.Gloss = tex.a; // �����ؽ��Ŀ��� ���� ���� �Ҵ�
            o.Alpha = tex.a * _Color.a; // ���� ���� _Color���� ������ ���� ���Ͽ� �������� ���� ���� �Ҵ�
            o.Specular = _Shininess; // _Shininess ������ ����� ���� ���� �Ҵ�
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap)); // IN.uv_BumpMap ��ǥ�� �ش��ϴ� _BumbMap �ؽ��� ���� ������ ���� �Ͽ� �Ҵ� 
        }
        ENDCG
    }

        FallBack "Specular" // ���꽦�̴��� �������� ���� ��� ��ü�� ����ϵ��� ����
}




    