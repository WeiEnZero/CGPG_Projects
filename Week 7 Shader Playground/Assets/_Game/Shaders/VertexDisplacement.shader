Shader "Custom/Shaders/VertexDisplacement"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TimeScale ("Time Scale", Float) = 25.0
        _DisplacementHeight("Displacement Height", Float) = 0.15
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
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"


            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };
            
            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                fixed4 diff : COLOR0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _TimeScale;
            float _DisplacementHeight;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o, o.vertex);

                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = nl * _LightColor0;
                o.diff.rgb += ShadeSH9(half4(worldNormal,1));


                float4 localPos=v.vertex;
                //localPos.y += 1.0;
                //localPos.y += sin(_Time * 25.0);
                //localPos.y += sin(_Time * _TimeScale);
                if (localPos.y > 0) {
                localPos.y += sin(localPos.x + _Time * _TimeScale) * _DisplacementHeight;
                localPos.y += cos(localPos.z + _Time * _TimeScale) * _DisplacementHeight;
                }
                float4 worldPos = mul(UNITY_MATRIX_M, localPos);
                float4 viewPos = mul(UNITY_MATRIX_V, worldPos);
                o.vertex = mul(UNITY_MATRIX_P, viewPos);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                UNITY_APPLY_FOG(i.fogCoord, col);
                col *= i.diff;
                col.rgb += 0.25;
                return col;
            }
            ENDCG
        }
    }
}
