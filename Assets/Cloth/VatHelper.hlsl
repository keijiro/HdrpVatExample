void GetVertexFromVat_float(
    float3 position,
    float2 uv1,
    Texture2D positionMap,
    Texture2D normalMap,
    float2 bounds,
    float totalFrame,
    float currentFrame,
    out float3 outPosition,
    out float3 outNormal
)
{
    // UV, Frame -> Texture sample point
    int t_w, t_h;
    positionMap.GetDimensions(t_w, t_h);
    int v_offs = (int)clamp(currentFrame, 0, totalFrame - 1) * (int)(t_h / totalFrame);
    int3 tsp = int3(uv1 * float2(t_w, t_h), 0) - int3(0, v_offs, 0);

    // Position sample and coordinate system conversion (Houdini -> Unity)
    float4 p_sample = positionMap.Load(tsp);
    float3 p = lerp(bounds.x, bounds.y, p_sample.xyz);
    outPosition = position + p.xzy * float3(-1, 1, 1);

#ifdef _PACKED_NORMAL_ON

    // Packed normal vector decoding

    float a_hi = floor(p_sample.w * 32);
    float a_lo = p_sample.w * 32 * 32 - a_hi * 32;

    float2 n2 = float2(a_hi, a_lo) / 31.5 * 4 - 2;
    float n2_n2 = dot(n2, n2);
    float3 n3 = float3(sqrt(1 - n2_n2 / 4) * n2, 1 - n2_n2 / 2);

    outNormal = clamp(n3, -1, 1).xzy * float3(-1, 1, 1);

#else

    // Normal vector sample and coordinate system conversion
    float4 n_sample = normalMap.Load(tsp);
    outNormal = n_sample.xzy * float3(-1, 1, 1);

#endif
}
