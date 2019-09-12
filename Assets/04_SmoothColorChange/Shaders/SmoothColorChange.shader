Shader "Custom/SmoothColorChange"
{
	Properties
	{
    	_MainTex ("Sprite Texture", 2D) = "white" {}
    	_Color ("Tint", Color) = (1,1,1,1)
		_Distance ("Distance", Float) = 0
		_ClickCoordX("ClickCoordX", Float) = 0.5 
		_ClickCoordY("ClickCoordY", Float) = 0.5 
	}

    SubShader {
      Tags { "RenderType" = "Opaque" }
      CGPROGRAM
      #pragma surface surf Lambert
      
      struct Input 
      {
          float2 uv_MainTex;
          float4 color : COLOR;
      };
      
      sampler2D _MainTex;
      float _Distance;
      float _ClickCoordX;
      float _ClickCoordY;
      
      void surf (Input IN, inout SurfaceOutput o) 
      {
          o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
          
          float distance = length(float2(IN.uv_MainTex.x - _ClickCoordX, IN.uv_MainTex.y - _ClickCoordY));
          
          if (distance < _Distance)
          {
              o.Albedo *= float3(0.1f, 1.0f, 0.1f);
          }
      }
      
      ENDCG
    }
    Fallback "Diffuse"
  }