Shader "Deferred (Metallic Gloss)"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)  // Albedo 색상을 나타낸다 
		_Metallic("Metallic", Range(0, 1)) = 1  // 금속적인 특성을 나타낸다
		_Gloss("Gloss", Range(0, 1)) = 0.8  // 재질의 광택을 나타낸다, 값이 클수록 표면이 매끄럽고 반사 특성이 강해진다
	}
		SubShader
	{
		Pass
		{
			Tags {"LightMode" = "Deferred"}  // 라이트모드를 Deferred 라이트모드로 설정

			CGPROGRAM
			#pragma vertex vertex_shader  // 'vertex_shader' 라는 이름의 버텍스 셰이더 함수 지정
			#pragma fragment pixel_shader  // 'pixel_shader' 라는 픽셀 셰이더 함수 지정
			#pragma exclude_renderers nomrt  // Multiple Render Targets 를 지원하지 않는 렌더러에서 셰이더를 사용하지 않도록 지정
			#pragma multi_compile ___ UNITY_HDR_ON  // High Dynamic Range모드를 사용하는 경우에만 셰이더 컴파일
			#pragma target 3.0  // 셰이더를 컴파일할 대상 플랫폼 버전 지정

			#include "UnityPBSLighting.cginc" // 해당 파일을 현재 셰이더에 포함시키는 지시문
			// (Physically Bassed Shading : 물리기반셰이딩 = 표면의 재질에 따른 빛의 반사가 물리적으로 어떻게 이루어지는지 시뮬레이션) 

			float4 _Color;  //  RGBA 색상 값을 나타내는 변수 : 알베도를 나타낸다
			float _Metallic;  //  금속 값을 나타내는 변수 : 1에 가까울수록 금속적인 특성을 갖는다
			float _Gloss;  //   매끄러움을 나타내는 변수 : 1에 가까울수록 매끄러워 진다

			struct structureVS // structureVS 구조체 선언
			{
				float4 screen_vertex : SV_POSITION; // 버텍스의 위치를 나타내는 screen_vertex 변수 선언 : SV_POSITION 시맨틱을 사용하여 버텍스의 위치 저장 
				float4 world_vertex : TEXCOORD0;  // 월드공간에서 버텍스의 위치를 나타내는 변수 선언 
				float3 normal : TEXCOORD1;  // 3개의 float 값을 가지는 노말 벡터를 나타내는 변수 선언
			};

			struct structurePS  // structurePS 구조체 선언
			{
				half4 albedo : SV_Target0;  // 알베도 값을 나타내는 변수 
				half4 specular : SV_Target1; // 스펙큘러 값을 나타내는 변수
				half4 normal : SV_Target2;  // 노말 벡터를 나타내는 변수
				half4 emission : SV_Target3;  // 이미션 값을 나타내는 변수
			};
			
			// half4 : 반 정밀도를 사용하여 4개의 요소를 가진 벡터를 나타내는 테이터 타입

			structureVS vertex_shader(float4 vertex : POSITION,float3 normal : NORMAL) \
			// vertex_shader 라는 함수 정의 >> vertex : POSITION, normal : NORMAL 값을 입력받는다
			{
				structureVS vs; // structureVS 구조체의 인스턴스 'vs' 생성
				vs.screen_vertex = UnityObjectToClipPos(vertex);  // 입력된 버텍스 값을 클립 공간으로 변환하고 그 값을 저장

				vs.world_vertex = mul(unity_ObjectToWorld, vertex);  
				// 입력된 버텍스 값을 월드 좌표로 변환한 값을 저장 >> unity_ObjectToWorld 행렬과 vertex 벡터를 곱하여 변환된 값 저장
				
				vs.normal = UnityObjectToWorldNormal(normal);  
				// 입력된 노말벡터를 현재 객체의 좌표에서 월드 좌뵤의 노말 벡터로 변환한 값을 저장
				return vs; // 'vs' 구조체를 반환한다 >> 변환된 버텍스 값을 출력
			}

			structurePS pixel_shader(structureVS vs) // structureVS 구조체를 입력으로 받고 structurePS 구조체를 반환
			{
				structurePS ps; // structurePS 구조체의 인스턴스 'ps' 생성
				float3 normalDirection = normalize(vs.normal); 
				// vs.normal을 정규화하여 normalDirection에 저장 >> 노말 벡터의 방향을 표준화하여 계산에 사용하기 위함
				
				half3 specular;  
				half specularMonochrome; // half 타입의 변수 선언

				half3 diffuseColor = DiffuseAndSpecularFromMetallic(_Color.rgb, _Metallic, specular, specularMonochrome); 
				// DiffuseAndSpecularFromMetallic 함수를 사용하여 3개의 값을 전달받아 컬러 값을 계산하여 diffusecolor 에 저장
				
				ps.albedo = half4(diffuseColor, 1.0); // 계산된 컬러값 diffuseColor값과 1.0을 대입하여 알베도 컬러 값 설정
				ps.specular = half4(specular, _Gloss); // specular 값과 _Gloss 값을 대입하여 스펙큘러 값 설정
				ps.normal = half4(normalDirection * 0.5 + 0.5, 1.0);  // 정규화된 노말 벡터값을 0과 1사이의 값으로 설정
				ps.emission = half4(0,0,0,1); // half4(0,0,0,1) 값을 대입하여 emission 값 초기화

				#ifndef UNITY_HDR_ON  // 조건부 지시문 >> HDR이 활성화 되지 않는 경우에 아래 코드 실행
					ps.emission.rgb = exp2(-ps.emission.rgb); // ps.emission.rgb 값을 exp2(-ps.emission.rgb)로 변경
				#endif 
				return ps; // ps 구조체를 반환하여 픽셀 셰이더의 출력 값을 설정
			}
			ENDCG
		}
	}
		FallBack "Diffuse"
}
