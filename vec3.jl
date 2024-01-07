 struct vec3
    x::Float64
    y::Float64
    z::Float64

    function vec3(x::Number, y::Number, z::Number)
        new(Float64(x), Float64(y), Float64(z))
    end

end

 Base.:+(v1::vec3, v2::vec3) = vec3(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z)

 Base.:-(v1::vec3, v2::vec3) = vec3(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z)

 Base.:*(scalar::Real, v::vec3) = vec3(scalar * v.x, scalar * v.y, scalar * v.z)
 Base.:*(v::vec3, u::vec3) = vec3(u.x * v.x, u.y * v.y, u.z * v.z)
 Base.:*(v::vec3, scalar::Real) = scalar * v

 Base.:/(v::vec3, scalar::Real) = vec3(v.x / scalar, v.y / scalar, v.z / scalar)

 function dot(v1::vec3, v2::vec3)
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
end

 function cross(v1::vec3, v2::vec3)
    return vec3(v1.y * v2.z - v1.z * v2.y, v1.z * v2.x - v1.x * v2.z, v1.x * v2.y - v1.y * v2.x)
end

 function length_squared(v::vec3)
    return v.x^2 + v.y^2 + v.z^2
end

 function norm(v::vec3)
    return sqrt(length_squared(v))
end

 function unit_vector(v::vec3)
    return v / norm(v)
end

 function random_vec()
    return vec3(rand(), rand(), rand())
end

 function rand_float(a::Float64, b::Float64)
    return a + (b - a) * rand()
end

 function random_vec(a::Float64, b::Float64)
    return vec3(rand_float(a, b), rand_float(a, b), rand_float(a, b))
end

 function random_in_unit_sphere()
    while true
        p = random_vec(-1.0, 1.0)
        if length_squared(p) >= 1.0
            continue
        end
        return p
    end
end

 function random_unit_vector()
    return unit_vector(random_in_unit_sphere())
end

 function random_in_hemisphere(normal::vec3)
    in_unit_sphere = random_in_unit_sphere()

    if dot(in_unit_sphere, normal) >= 0
        return in_unit_sphere
    end

    return -1 * in_unit_sphere
end

 function random_in_unit_disk()
    while (true)
        p = vec3(rand_float(-1.0, 1.0), rand_float(-1.0, 1.0), 0)
        if (length_squared(p) < 1)
            return p
        end
    end
end

 function near_zero(vec::vec3)
    s = 1e-8
    return abs(vec.x) < s && abs(vec.y) < s && abs(vec.z) < s
end

 function reflect(v::vec3, n::vec3)
    return v - 2 * dot(v, n) * n
end

 function refract(uv::vec3, n::vec3, etai_over_etat::Float64)
    cos_theta = min(dot(-1 * uv, n), 1.0)
    r_out_perp = etai_over_etat * (uv + cos_theta * n)
    r_out_parallel = -sqrt(abs(1.0 - length_squared(r_out_perp))) * n
    return r_out_parallel + r_out_perp
end


 const point3 = vec3
 const color = vec3
