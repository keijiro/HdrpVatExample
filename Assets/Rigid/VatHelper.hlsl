int3 VAT_GetSamplePoint(Texture2D map, float2 uv, float current, float total)
{
    int t_w, t_h;
    map.GetDimensions(t_w, t_h);

    int frame = clamp(current, 0, total - 1); 
    int stride = t_h / total;

    return int3(uv.x * t_w, uv.y * t_h - frame * stride, 0);
}

float3 VAT_RotateVector(float3 v, float4 q)
{
    return v + cross(2 * q.xyz, cross(q.xyz, v) + q.w * v);
}

void GetVertexFromVat_float(
    float3 position,
    float3 normal,
    float3 color,
    float2 uv1,
    Texture2D positionMap,
    Texture2D rotationMap,
    float4 bounds,
    float totalFrame,
    float currentFrame,
    out float3 outPosition,
    out float3 outNormal
)
{
    // Texture sample point
    int3 tsp = VAT_GetSamplePoint(positionMap, uv1, currentFrame, totalFrame);

    // Position/rotation samples
    float4 p_sample = positionMap.Load(tsp);
    float4 r_sample = rotationMap.Load(tsp);

    // Position offset
    float3 offs = lerp(bounds.x, bounds.y, p_sample.xyz).xzy * float3(-1, 1, 1);

    // Pivot from vertex color
    float3 pivot = lerp(bounds.z, bounds.w, color).xzy * float3(-1, 1, 1);

    // Rotation quaternion
    float4 rot = (r_sample * 2 - 1).xzyw * float4(-1, 1, 1, 1);

    // Output
    outPosition = VAT_RotateVector(position - pivot, rot) + pivot + offs;
    outNormal = VAT_RotateVector(normal, rot);
}
