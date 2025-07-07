// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/TextureBlend"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OtherTex ("OtherTexture", 2D) = "white" {}
        _BlendAmt ("BlendAmount", Range(0,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

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

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float worldPosY : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _OtherTex;
            float4 _OtherTex_ST;
            fixed _BlendAmt;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                float4 worldPos = mul(UNITY_MATRIX_M, v.vertex);
                o.worldPosY = worldPos.y;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 colMain = tex2D(_MainTex, i.uv);
                fixed4 colOther = tex2D(_OtherTex, i.uv);
                //fixed4 col = lerp(colMain, colOther, _BlendAmt);

                float clampedPosY = clamp(-i.worldPosY, 0, 1);
                fixed4 col = lerp(colMain, colOther, clampedPosY);

                return col;
            }
            ENDCG
        }
    }
}
