Shader "Custom/06_WaterShaderFragment"
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
                //float3 worldReflection : TEXCOORD0;
                float4 position: SV_POSITION;
                float3 worldPosition: TEXCOORD0;
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

                o.worldPosition = mul(unity_ObjectToWorld, v.vertex).xyz;

                float4 v0 = mul(unity_ObjectToWorld, v.vertex);
                v0.y += waveOffset(v0.x);
                o.position = mul(UNITY_MATRIX_VP, v0);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 v0 = i.worldPosition;
                float3 v1 = v0 + float3(1.0, 0,    0);
                float3 v2 = v0 + float3(  0, 0, -1.0);

                v0.y += waveOffset(v0.x);
                v1.y += waveOffset(v1.x);
                v2.y += waveOffset(v2.x);

                float3 tangent = (v1 - v0).xyz;
                float3 bitangent = (v2 - v0).xyz;
                float3 normal = normalize(cross(tangent, bitangent));

                float3 worldViewDir = v0 - _WorldSpaceCameraPos;
                float3 worldReflection = reflect(-worldViewDir, normal);

                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldReflection);
                half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);

                fixed4 color = 0;
                color.rgb = skyColor;
                return color;
            }
            ENDCG
        }
    }
}
