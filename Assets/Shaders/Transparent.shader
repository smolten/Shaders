Shader "Unlit/ColorAlpha"
{
    Properties
    {
        // Color property for material inspector, default to white
        _Color ("Main Color", Color) = (1,1,1)
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
            
            // vertex shader
            // this time instead of using "appdata" struct, just spell inputs manually,
            // and instead of returning v2f struct, also just return a single output
            // float4 clip position
            float4 vert (float4 vertex : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vertex);
            }
            
            fixed4 _Color;	//Color from inspector
			float _Alpha;	//Given Alpha transparency

            // pixel shader, no inputs needed
            fixed4 frag () : SV_Target
            {
				fixed4 col = _Color;
				col.a = _Alpha;
				return col;
            }
            ENDCG
        }
    }
}