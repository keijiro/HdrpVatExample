//
// Helper functions for SideFx Labs VAT (Vertex Animation Texture)
//

// Rotate a vector with a unit quaternion.
float3 VAT_RotateVector(float3 v, float4 q)
{
    return v + cross(2 * q.xyz, cross(q.xyz, v) + q.w * v);
}

// Calculate a texture sample point for a given vertex.
int3 VAT_GetSamplePoint(Texture2D map, float2 uv, float current, float total)
{
    int t_w, t_h;
    map.GetDimensions(t_w, t_h);

    int frame = clamp(current, 0, total - 1); 
    int stride = t_h / total;

    return int3(uv.x * t_w, uv.y * t_h - frame * stride, 0);
}

// Coordinate system conversion (right hand Z-up -> left hand Y-up)
float3 VAT_ConvertSpace(float3 v)
{
    return v.xzy * float3(-1, 1, 1);
}

// Decode an alpha-packed 3D vector.
float3 VAT_UnpackAlpha(float a)
{
    float a_hi = floor(a * 32);
    float a_lo = a * 32 * 32 - a_hi * 32;

    float2 n2 = float2(a_hi, a_lo) / 31.5 * 4 - 2;
    float n2_n2 = dot(n2, n2);
    float3 n3 = float3(sqrt(1 - n2_n2 / 4) * n2, 1 - n2_n2 / 2);

    return clamp(n3, -1, 1);
}

// Vertex function for cloth VAT
void ClothVAT_float(
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
    int3 tsp = VAT_GetSamplePoint(positionMap, uv1, currentFrame, totalFrame);
    float4 p = positionMap.Load(tsp);

    // Position 
    outPosition = position + VAT_ConvertSpace(lerp(bounds.x, bounds.y, p.xyz));

#ifdef _PACKED_NORMAL_ON
    // Alpha-packed normal
    outNormal = VAT_ConvertSpace(VAT_UnpackAlpha(p.w));
#else
    // Normal vector from normal map
    outNormal = VAT_ConvertSpace(normalMap.Load(tsp).xyz);
#endif
}

// Vertex function for fluid VAT
void FluidVAT_float(
    float2 uv0,
    Texture2D positionMap,
    Texture2D normalMap,
    float2 bounds,
    float totalFrame,
    float currentFrame,
    out float3 outPosition,
    out float3 outNormal
)
{
    int3 tsp = VAT_GetSamplePoint(positionMap, uv0, currentFrame, totalFrame);
    float4 p = positionMap.Load(tsp);

    // Position 
    outPosition = VAT_ConvertSpace(lerp(bounds.x, bounds.y, p.xyz));

#ifdef _PACKED_NORMAL_ON
    // Alpha-packed normal
    outNormal = VAT_ConvertSpace(VAT_UnpackAlpha(p.w));
#else
    // Normal vector from normal map
    outNormal = VAT_ConvertSpace(normalMap.Load(tsp).xyz);
#endif
}

// Vertex function for rigid VAT
void RigidVAT_float(
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
    int3 tsp = VAT_GetSamplePoint(positionMap, uv1, currentFrame, totalFrame);
    float4 p = positionMap.Load(tsp);
    float4 r = rotationMap.Load(tsp);

    // Position offset
    float3 offs = VAT_ConvertSpace(lerp(bounds.x, bounds.y, p.xyz));

    // Pivot from vertex color
    float3 pivot = VAT_ConvertSpace(lerp(bounds.z, bounds.w, color));

    // Rotation quaternion
    float4 rot = (r * 2 - 1).xzyw * float4(-1, 1, 1, 1);

    // Output
    outPosition = VAT_RotateVector(position - pivot, rot) + pivot + offs;
    outNormal = VAT_RotateVector(normal, rot);
}
