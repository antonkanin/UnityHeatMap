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
            uniform float4 _Points [20]; // (x, y, z) = position
            uniform float _Radiuses [20]; // x = radius, y = intensity
 
            half4 frag(vertOutput output) : COLOR 
            {
                // Loops over all the points
                half h = 0;
                
                for (int i = 0; i < _Points_Length; i ++)
                {
                    // Calculates the contribution of each point
                    half di = distance(output.worldPos, _Points[i].xyz);
                    
                    // h += 0.2 / di;
                    h += 1 - saturate(di / _Radiuses[i]);
                    // h += _Radiuses[i] / di;
                }
                
                if (h < 0.7)
                {
                    h = 0.0;
                }                
                
                return half4(h, 0, 0, 1.0);
            }
            
            ENDCG
        }
    } 
    Fallback "Diffuse"
}