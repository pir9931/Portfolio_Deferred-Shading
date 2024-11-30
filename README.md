# Portfolio_Deferred-Shading

중부대학교 게임소프트웨어학과 91913256_김재훈

## G-buffer

### Normal.shder  

3D 모델의 Normal Vector  정보를 기반으로 색상 계산  

각 픽셀의 Vector 정보를 활용하여 광원의 방향과 상호작용을 계산  
> 광원의 위치에 따라 픽셀의 밝기를 계산하는데 활용

### Color.shader  
Unity의 G-buffer 에서 기본 데이터(색상, 반사율 등)을 저장하는 텍스처  
데이터를 읽고 화면에 출력하는 역할
> Deferred Rendering Pipeline 에서 G-buffer 데이터를 읽어 화면에 출력

### Position.shader  
버텍스의 UV 좌표를 화면에 표시  
 * UV 좌표 : 텍스처 맵핑에 사용하는 2D 좌표로 (0,0)은 텍스처의 좌측하단, (1,1)은 우측 상단을 나타냄
> 텍스처 이미지의 특정 위치를 참조하는데 활용

### Specular.shader  
표면에서 반사되는 하이라이트 영역의 밝기 값에 따라 반사의 강도 조정  
표면의 미세한 디테일을 표현하기 위해 사용
> 물체 표면이 빛을 반사하는 정도를 나타내는데 활용

<table align="center">
  <tr>
    <th style="text-align: center;">Normal</th>
    <th style="text-align: center;">Color</th>
    <th style="text-align: center;">Position</th>
    <th style="text-align: center;">Specular</th>
  </tr>
  <tr>
    <td><img src="asset/Normal.png" width="420" height="300"></td>
    <td><img src="asset/Color.png" width="420" height="300"></td>
    <td><img src="asset/Position.png" width="420" height="300"></td>
    <td><img src="asset/Specular.png" width="420" height="300"></td>
  </tr>
</table>

## Deferred Shading (multi.shader)

### Deferred Rendering에서 G-buffer의 구성 및 셰이더 코드의 역할  
G-buffer가 포함하는 데이터  
 * Diffuse Color (색상) : 표면의 기본 색상 (Color.shader : 텍스쳐 데이터를 읽어 출력 및 디버깅)
 * Specular (반사광) : 반사광의 강도 (Specular.shader : 반사광 데이터를 계산하고 G-buffer에 저장)
 * Normal (법선) : 표면의 방향 Vector (Normal.shader : Normal 데이터를 계산하고 G-buffer에 저장)
 * Depth (깊이) : G-buffer의 내부 텍스처, 카메라로부터의 거리
   
### Physically Based Shading  
물체의 금속성(Metallic) 및 광택(Gloss)을 기반으로 빛의 반응 계산  

### Structure  
Vertex Shader  
* 객체의 각 vertex를 처리하여 화면 좌표로 변환하고 Normal Vector와 World Position을 계산하여 전달
Fragment Shader
* Vertex Shader에서 전달받은 데이터를 기반으로 픽셀 데이터 계산 후 G-buffer에 필요한 데이터(color, normal, specular 등)를 생성하고 저장
Physically Based Shading
* Metallic 및 Gloss를 활용하여 표면 확산 반사(Diffuse)와 Specular를 계산

<table align="center">
  <tr>
    <th style="text-align: center;">Before Shading</th>
    <th style="text-align: center;">Metallic 0 & Gloss 0</th>
    <th style="text-align: center;">Metallic 1 & Gloss 1</th>
  </tr>
  <tr>
    <td><img src="asset/DeferredNormal.png" width="300" height="300"></td>
    <td><img src="asset/Deferred00.png" width="300" height="300"></td>
    <td><img src="asset/Deferred11.png" width="300" height="300"></td>
  </tr>
</table>


