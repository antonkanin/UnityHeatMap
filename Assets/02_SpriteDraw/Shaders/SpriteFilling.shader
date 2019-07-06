Shader "Custom/SpriteFilling"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		
		_HorizontalFilling ("Horizontal Filling", Range(0, 1)) = 1.0
		[Toggle] _HorizontalDirection("Horizontal Direction", float) = 1
		 
		_VerticalFilling ("Vertical Filling ", Range(0, 1)) = 1.0
		[Toggle] _VerticalDirection("Vertical Direction", float) = 1
	}

	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha

		Pass
		{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _ PIXELSNAP_ON
			#include "UnityCG.cginc"
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
			};
			
			fixed4 _Color;
			
			half _HorizontalFilling;
			float _HorizontalDirection;

			half _VerticalFilling;
			float _VerticalDirection;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			sampler2D _MainTex;
			sampler2D _AlphaTex;
			float _AlphaSplitEnabled;

			fixed4 SampleSpriteTexture (float2 uv)
			{
				fixed4 color = tex2D (_MainTex, uv);

#if UNITY_TEXTURE_ALPHASPLIT_ALLOWED
				if (_AlphaSplitEnabled)
					color.a = tex2D (_AlphaTex, uv).r;
#endif //UNITY_TEXTURE_ALPHASPLIT_ALLOWED

				return color;
			}

			fixed4 frag(v2f IN) : SV_Target
			{
        		fixed4 c = SampleSpriteTexture (IN.texcoord) * IN.color;
				c.rgb *= c.a;
								
				if ((_HorizontalDirection == 1 && IN.texcoord.x > _HorizontalFilling) ||
				  (_HorizontalDirection == 0 && IN.texcoord.x < (1 - _HorizontalFilling)) ||
				  ((_VerticalDirection == 1 && IN.texcoord.y > _VerticalFilling) ||
				  (_VerticalDirection == 0 && IN.texcoord.y < 1 - _VerticalFilling)))
    		    {
				    c.rgb = 0;
			    }
				
				return c;
			}
		ENDCG
		}
	}
}