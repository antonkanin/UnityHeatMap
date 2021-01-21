Shader "Custom/06_WaterShaderVertex"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal: NORMAL;
            };

            struct v2f
            {
                float3 worldReflection : TEXCOORD0;
                float4 position: SV_POSITION;
            };

            float waveOffset(float value)
            {
                float speed = 1.0;
                float depth = 1.0;

                return sin(_Time.y * speed  - value) * depth;
            }

            v2f vert (appdata v)
            {
                v2f o;

                float4 v0 = mul(unity_ObjectToWorld, v.vertex);
                float4 v1 = v0 + float4(1.0, 0,    0, 0);
                float4 v2 = v0 + float4(  0, 0, -1.0, 0);

                v0.y += waveOffset(v0.x);
                v1.y += waveOffset(v1.x);
                v2.y += waveOffset(v2.x);

                float3 tangent = (v1 - v0).xyz;
                float3 bitangent = (v2 - v0).xyz;
                float3 worldNormal = normalize(cross(tangent, bitangent));
                float3 worldViewDir = v0 - _WorldSpaceCameraPos;

                o.position = mul(UNITY_MATRIX_VP, v0);
                o.worldReflection = reflect(-worldViewDir, worldNormal);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, i.worldReflection);
                half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);

                fixed4 color = 0;
                color.rgb = skyColor;
                return color;
            }
            ENDCG
        }
    }
}
