//
//  Shaders.metal
//  Ayna
//
//  Created by Saumya Lahera on 5/8/23.
//

#include <metal_stdlib>
using namespace metal;

//There needs to be some work done here
struct SLColor {
    float4 color;
};

struct SLVertexOut {
    vector_float4 position [[position]];
    vector_float4 color;
    float2 uv [[ user(texturecoord) ]];
};

struct SLNodeUniform {
    float2 size;
    float4 backgroundColor;
    float radius;
    float time;
};


float random (float2 _st) {
    return fract(sin(dot(_st.xy,
                         float2(12.9898,78.233)))*
        43758.5453123);
}

float noise (float2 _st) {
    float2 i = floor(_st);
    float2 f = fract(_st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + float2(1.0, 0.0));
    float c = random(i + float2(0.0, 1.0));
    float d = random(i + float2(1.0, 1.0));

    float2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

float fbm (float2 _st) {
    float v = 0.0;
    float a = 0.5;
    float2 shift = float2(100.0);
    
    // Rotate to reduce axial bias
    float2x2 rot(cos(0.5), sin(0.5),
                    -sin(0.5), cos(0.50));
    for (int i = 0; i < 5; ++i) {
        v += a * noise(_st);
        _st = rot * _st * 2.0 + shift;
        a *= 0.68;
    }
    return v;
}

float4 smoke(float2 st, float u_time) {
    
    float3 color = float3(0.0);

        float2 q = float2(0.);
        q.x = fbm( st + 0.00*u_time);
        q.y = fbm( st + float2(1.0));

        float2 r = float2(0.);
        r.x = fbm( st + 1.0*q + float2(1.7,9.2)+ 0.15*u_time );
        r.y = fbm( st + 1.0*q + float2(8.3,2.8)+ 0.126*u_time);

        float f = fbm(st+r);

        color = mix(float3(0.101961,0.619608,0.666667),
                    float3(0.666667,0.666667,0.498039),
                    clamp((f*f)*4.0,0.0,1.0));

        color = mix(color,
                    float3(0,0,0.164706),
                    clamp(length(q),0.0,1.0));

        color = mix(color,
                    float3(0.666667,1,1),
                    clamp(length(r),0.0,1.0));

        return float4((f*f*f+.6*f*f+.5*f)*color,1.);
    
}

vertex SLVertexOut vertexShader(const constant vector_float2 *vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]], constant SLColor &constants [[buffer(1)]], device const float2 *textureCoords [[ buffer(2)]]){
    vector_float2 currentVertex = vertexArray[vid];
    SLVertexOut output;
    output.position = vector_float4(currentVertex.x, currentVertex.y, 0, 1);
    float4 colors = constants.color;
    output.color = colors;
    output.uv = textureCoords[vid];
    return output;
}

fragment vector_float4 fragmentShader(SLVertexOut interpolated [[stage_in]], constant SLNodeUniform &uniform [[ buffer(0)]]){
    float2 coords = interpolated.uv;
    coords-=float2(0.5);
    return interpolated.color;
}


