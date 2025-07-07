// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/UVManipulation"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                //_MainTex_ST.xy = fixed2(0.5, 0.5); //Change Tiling Values
               // _MainTex_ST.wz = fixed2(0.0, 0.5); //Change Offset Values
                _MainTex_ST.xy = fixed2(
                    (fixed)sin(_Time * 10.0),
                    (fixed)cos(_Time * 10.0));
                _MainTex_ST.wz = fixed2(
                    (fixed)sin(_Time * 10.0),
                    (fixed)cos(_Time * 10.0));
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //o.uv.r += sin(_Time * 25.0);
                //o.uv.g += sin(_Time * 20.0);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                //fixed4 col = fixed4(i.uv.r, i.uv.g, 1.0, 0.0);

                //fixed4 col = fixed4(i.uv.rg, 1.0, 1.0);
                return col;


            }
            ENDCG
        }
    }
}
