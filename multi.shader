Shader "Deferred (Metallic Gloss)"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)  // Albedo ������ ��Ÿ���� 
		_Metallic("Metallic", Range(0, 1)) = 1  // �ݼ����� Ư���� ��Ÿ����
		_Gloss("Gloss", Range(0, 1)) = 0.8  // ������ ������ ��Ÿ����, ���� Ŭ���� ǥ���� �Ų����� �ݻ� Ư���� ��������
	}
		SubShader
	{
		Pass
		{
			Tags {"LightMode" = "Deferred"}  // ����Ʈ��带 Deferred ����Ʈ���� ����

			CGPROGRAM
			#pragma vertex vertex_shader  // 'vertex_shader' ��� �̸��� ���ؽ� ���̴� �Լ� ����
			#pragma fragment pixel_shader  // 'pixel_shader' ��� �ȼ� ���̴� �Լ� ����
			#pragma exclude_renderers nomrt  // Multiple Render Targets �� �������� �ʴ� ���������� ���̴��� ������� �ʵ��� ����
			#pragma multi_compile ___ UNITY_HDR_ON  // High Dynamic Range��带 ����ϴ� ��쿡�� ���̴� ������
			#pragma target 3.0  // ���̴��� �������� ��� �÷��� ���� ����

			#include "UnityPBSLighting.cginc" // �ش� ������ ���� ���̴��� ���Խ�Ű�� ���ù�
			// (Physically Bassed Shading : ������ݼ��̵� = ǥ���� ������ ���� ���� �ݻ簡 ���������� ��� �̷�������� �ùķ��̼�) 

			float4 _Color;  //  RGBA ���� ���� ��Ÿ���� ���� : �˺����� ��Ÿ����
			float _Metallic;  //  �ݼ� ���� ��Ÿ���� ���� : 1�� �������� �ݼ����� Ư���� ���´�
			float _Gloss;  //   �Ų������� ��Ÿ���� ���� : 1�� �������� �Ų����� ����

			struct structureVS // structureVS ����ü ����
			{
				float4 screen_vertex : SV_POSITION; // ���ؽ��� ��ġ�� ��Ÿ���� screen_vertex ���� ���� : SV_POSITION �ø�ƽ�� ����Ͽ� ���ؽ��� ��ġ ���� 
				float4 world_vertex : TEXCOORD0;  // ����������� ���ؽ��� ��ġ�� ��Ÿ���� ���� ���� 
				float3 normal : TEXCOORD1;  // 3���� float ���� ������ �븻 ���͸� ��Ÿ���� ���� ����
			};

			struct structurePS  // structurePS ����ü ����
			{
				half4 albedo : SV_Target0;  // �˺��� ���� ��Ÿ���� ���� 
				half4 specular : SV_Target1; // ����ŧ�� ���� ��Ÿ���� ����
				half4 normal : SV_Target2;  // �븻 ���͸� ��Ÿ���� ����
				half4 emission : SV_Target3;  // �̹̼� ���� ��Ÿ���� ����
			};
			
			// half4 : �� ���е��� ����Ͽ� 4���� ��Ҹ� ���� ���͸� ��Ÿ���� ������ Ÿ��

			structureVS vertex_shader(float4 vertex : POSITION,float3 normal : NORMAL) \
			// vertex_shader ��� �Լ� ���� >> vertex : POSITION, normal : NORMAL ���� �Է¹޴´�
			{
				structureVS vs; // structureVS ����ü�� �ν��Ͻ� 'vs' ����
				vs.screen_vertex = UnityObjectToClipPos(vertex);  // �Էµ� ���ؽ� ���� Ŭ�� �������� ��ȯ�ϰ� �� ���� ����

				vs.world_vertex = mul(unity_ObjectToWorld, vertex);  
				// �Էµ� ���ؽ� ���� ���� ��ǥ�� ��ȯ�� ���� ���� >> unity_ObjectToWorld ��İ� vertex ���͸� ���Ͽ� ��ȯ�� �� ����
				
				vs.normal = UnityObjectToWorldNormal(normal);  
				// �Էµ� �븻���͸� ���� ��ü�� ��ǥ���� ���� �º��� �븻 ���ͷ� ��ȯ�� ���� ����
				return vs; // 'vs' ����ü�� ��ȯ�Ѵ� >> ��ȯ�� ���ؽ� ���� ���
			}

			structurePS pixel_shader(structureVS vs) // structureVS ����ü�� �Է����� �ް� structurePS ����ü�� ��ȯ
			{
				structurePS ps; // structurePS ����ü�� �ν��Ͻ� 'ps' ����
				float3 normalDirection = normalize(vs.normal); 
				// vs.normal�� ����ȭ�Ͽ� normalDirection�� ���� >> �븻 ������ ������ ǥ��ȭ�Ͽ� ��꿡 ����ϱ� ����
				
				half3 specular;  
				half specularMonochrome; // half Ÿ���� ���� ����

				half3 diffuseColor = DiffuseAndSpecularFromMetallic(_Color.rgb, _Metallic, specular, specularMonochrome); 
				// DiffuseAndSpecularFromMetallic �Լ��� ����Ͽ� 3���� ���� ���޹޾� �÷� ���� ����Ͽ� diffusecolor �� ����
				
				ps.albedo = half4(diffuseColor, 1.0); // ���� �÷��� diffuseColor���� 1.0�� �����Ͽ� �˺��� �÷� �� ����
				ps.specular = half4(specular, _Gloss); // specular ���� _Gloss ���� �����Ͽ� ����ŧ�� �� ����
				ps.normal = half4(normalDirection * 0.5 + 0.5, 1.0);  // ����ȭ�� �븻 ���Ͱ��� 0�� 1������ ������ ����
				ps.emission = half4(0,0,0,1); // half4(0,0,0,1) ���� �����Ͽ� emission �� �ʱ�ȭ

				#ifndef UNITY_HDR_ON  // ���Ǻ� ���ù� >> HDR�� Ȱ��ȭ ���� �ʴ� ��쿡 �Ʒ� �ڵ� ����
					ps.emission.rgb = exp2(-ps.emission.rgb); // ps.emission.rgb ���� exp2(-ps.emission.rgb)�� ����
				#endif 
				return ps; // ps ����ü�� ��ȯ�Ͽ� �ȼ� ���̴��� ��� ���� ����
			}
			ENDCG
		}
	}
		FallBack "Diffuse"
}
