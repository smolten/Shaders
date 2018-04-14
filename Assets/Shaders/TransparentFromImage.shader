Shader "Unlit/ImageAlpha"
{
    Properties
    {
        // Image texture and transparency
        [NoScaleOffset] _MainTex ("AlphaTexture", 2D) = "white" { }
        [NoScaleOffset] _DrawTex ("DrawTexture", 2D) = "white" { }
		_Alpha("Alpha", Range(0, 1.0)) = 1.0
    }
    SubShader
    {
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha	//Blend [Source Amount] [Destination Amount]
										//		A	+	1-A		=	 1

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
			struct v2f {
                float2 uv : TEXCOORD0;	//Texture coordinate to get color from texture
                float4 vertex : SV_POSITION;
            };

			sampler2D _MainTex; //Color from given texture image
			sampler2D _DrawTex;
            float4 _MainTex_ST;	//Needed for TRANSFORM_TEX
			float _Alpha;	//Given Alpha transparency

            // vertex shader
            // this time instead of using "appdata" struct, just spell inputs manually,
            // and instead of returning v2f struct, also just return a single output
            // float4 clip position
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            

            // pixel shader, no inputs needed
            fixed4 frag (v2f i) : SV_Target
            {
				float value = tex2D(_MainTex, i.uv).r;
				fixed4 col = tex2D(_DrawTex, i.uv);

				//Only show values above cutoff
				if ( value < _Alpha) { col.a = 1.0; }
				else { col.a = 0.0; }

				return col;
            }
            ENDCG
        }
    }
}