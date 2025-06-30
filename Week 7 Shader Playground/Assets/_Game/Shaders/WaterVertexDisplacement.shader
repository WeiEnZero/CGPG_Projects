Shader "Custom/Shaders/WaterVertexDisplacement"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TimeScale ("Time Scale", Float) = 25.0
        _DisplacementHeight("Displacement Height", Float) = 0.15
        _Color ("Tint Color", Color) = (0.0, 0.4, 1.0, 1.0)
    }
        
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        //LOD 100
        LOD 200
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"


            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };
            
            struct v2f
            {
                float2 uv : TEXCOORD0;
                //UNITY_FOG_COORDS(1)
                UNITY_FOG_COORDS(3)
                SHADOW_COORDS(4)
                float4 vertex : SV_POSITION;
                fixed4 diff : COLOR0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _TimeScale;
            float _DisplacementHeight;
            fixed4 _Color;

      
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
                
                localPos.y += sin(localPos.x + _Time * _TimeScale) * _DisplacementHeight;
                localPos.y += cos(localPos.y + _Time * _TimeScale) * _DisplacementHeight;
                float4 worldPos = mul(UNITY_MATRIX_M, localPos);
                float4 viewPos = mul(UNITY_MATRIX_V, worldPos);
                o.vertex = mul(UNITY_MATRIX_P, viewPos);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col *= _Color;  // Apply blue tint
                UNITY_APPLY_FOG(i.fogCoord, col);
                col *= i.diff;
                return col;
            }

            ENDCG
        }
    }
}
