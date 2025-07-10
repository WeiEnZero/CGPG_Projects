// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/BubbleShield"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ScrollSpeed ("Scroll Speed", Float) = 1.0
        _Colour ("Colour", Color) = (0.5, 1.0, 1.0, 1.0)
        _FresnelWidth ("Frensel Width", Range(0.0, 5.0)) = 1.5
        _FrenselIntensity ("Frensel Intensity", Range(0.0, 10.0)) = 2.0
        _TimeScale ("Time Scale", Float) = 25.0
        _DisplacementHeight("Displacement Height", Float) = 0.15
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha

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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                fixed3 rimColor : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _ScrollSpeed;
            fixed4 _Colour;
            float _FresnelWidth;
            float _FrenselIntensity;
            float _TimeScale;
            float _DisplacementHeight;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                _MainTex_ST.z = _Time * _ScrollSpeed; //Scroll horizontally

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.x += sin(_Time * 0.01) * 0.05;
                o.uv.y += sin(_Time * 0.01) * 0.05;
                
                fixed3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
                fixed dotProduct = 1 - saturate(dot(v.normal, viewDir));
                o.rimColor = lerp(1 - _FresnelWidth, 1.0, dotProduct);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col *= _Colour;
                col.a = (col.r + col.g + col.b)/ 3.0; // alpha = blackness of pixel

                fixed fresnelFactor = saturate(lerp(0.0, 1.0, i.rimColor.r * _FrenselIntensity));
                col.a = lerp(col.a, 1.0, fresnelFactor);
                col.rgb = lerp(col.rgb, _Colour, fresnelFactor);
                //col.rgb = i.rimColor;
                //col.a = 1.0;
                return col; // We just want to see the Fresnel colour
                //return col * _Colour;
            }
            ENDCG
        }
    }
}
