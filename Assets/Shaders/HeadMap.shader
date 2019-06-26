Shader "Custom/Heatmap" 
{
    Properties 
    {
    }
    
    SubShader 
    {
        Tags {"Queue"="Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha // Alpha blend
 
        Pass 
        {
            CGPROGRAM
            #pragma vertex vert             
            #pragma fragment frag
         
            struct vertInput 
            {
                float4 pos : POSITION;
            };  
 
            struct vertOutput 
            {
                float4 pos : POSITION;
                fixed3 worldPos : TEXCOORD1;
            };
 
            vertOutput vert(vertInput input) 
            {
                vertOutput o;
                o.pos = UnityObjectToClipPos(input.pos);
                o.worldPos = mul(unity_ObjectToWorld, input.pos).xyz;
                return o;
            }
    
            uniform int _Points_Length = 0;
            uniform float4 _Points [100];
            uniform float _Radiuses [100];
            uniform float _Strength;
 
            half4 frag(vertOutput output) : COLOR 
            {
                half h = 0;
                
                for (int i = 0; i < _Points_Length; i ++)
                {
                    half di = distance(output.worldPos, _Points[i].xyz);
                    
                    if (_Strength <= 0.01)
                    {
                        _Strength = 0.01;
                    }
                    
                    // h += 1 - saturate(di / (_Radiuses[i] * _Strength));
                    h += _Strength * 1 / di;
                }
                
                return half4(h, 0, 0, 1);
            }
            
            ENDCG
        }
    } 
    Fallback "Diffuse"
}