Shader "Custom/06_WaterShader"
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
                // debug stuff
                float3 worldNormal : TAXCOORD1;
                float3 worldViewDir : TAXCOORD2;

                // x - vertex X offset
                // y - normal X offset
                // z - tangent X offset
                float3 debug : TAXCOORD3;
            };

            float waveOffset(float value)
            {
                float speed = 1.0;
                float depth = 0.5;

                return sin(_Time.y * speed  - value) * depth;
            }

            v2f vert (appdata v)
            {
                v2f o;
                float depth = 0.5;

                float4 v0 = v.vertex;
                float4 v1 = v0 + float4(1.0, 0, 0, 0);
                float4 v2 = v0 + float4(0, 0, -0.5, 0);

                float offsetY_0 = waveOffset(v0.x);
                float offsetY_1 = waveOffset(v1.x);

                v0.y += offsetY_0;
                v1.y += offsetY_1;
                v2.y += waveOffset(v2.x);

                float4 tangent = normalize(v1 - v0);
                float4 bitangent = normalize(v2 - v0);
                float4 normal = float4(normalize(cross(tangent.xyz, bitangent.xyz)), 0);

                //o.offset = v.vertex;
                //o.offset.y = offsetY / depth;
                o.debug = float3(0, 0, 0);
                //o.debug.xyz = normalize(tangent.xyz);
                //o.debug.xyz = normalize(bitangent.xyz);
                //o.debug.x = normal.x;
                //o.debug.y = -normal.x;
                //o.debug.y = normal.y;
                //o.debug.x = offsetY_1 / depth;
                /*o.debug.x = normalize(offsetY_1);*/
                /*o.debug.y = normalize(-offsetY_1);*/
 
                float4 vertex = v0;

                o.position = UnityObjectToClipPos(vertex);

                float3 worldPos = mul(unity_ObjectToWorld, vertex).xyz;
                float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
                float3 worldNormal = normalize(UnityObjectToWorldNormal(normal));

                o.debug.x = worldNormal.x;
                o.debug.y = -worldNormal.x;


                o.worldReflection = reflect(-worldViewDir, worldNormal);

                // debug
                o.worldNormal = worldNormal;
                o.worldViewDir = worldViewDir;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, i.worldReflection);
                half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);

                fixed4 color = 0;
                color.rgb = skyColor;
                //color.rgb = i.worldNormal;
                //color.r = i.worldNormal.x;
                //color.g = i.worldNormal.y;
                //color.rgb = i.worldViewDir;
                //color = fixed4(i.debug.x, i.debug.y, i.debug.z, 1.0);
                return color;
            }
            ENDCG
        }
    }
}
