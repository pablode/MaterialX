void mx_normalmap(vec3 value, int map_space, float normal_scale, vec3 N, vec3 T, vec3 B, out vec3 result)
{
    // TODO: do we want to add this 0-check to the other backends, too?
    vec3 n = (value == vec3(0.0f)) ? vec3(0.0, 0.0, 1.0) : value * 2.0 - 1.0;

    if (map_space == 0)
    {
        n = T * n.x * normal_scale + B * n.y * normal_scale + N * n.z;
    }

    result = normalize(n);
}
