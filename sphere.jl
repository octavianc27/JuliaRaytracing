 struct Sphere <: Hittable
    center::point3
    radius::Float64
    mat::Material
end

 function hit(s::Sphere, r::ray, ray_int::Interval)
    oc = r.origin - s.center
    a = dot(r.direction, r.direction)
    half_b = dot(oc, r.direction)
    c = dot(oc, oc) - s.radius * s.radius

    discriminant = half_b * half_b - a * c
    if discriminant < 0
        return false, nothing
    end

    sqrtd = sqrt(discriminant)

    root = (-half_b - sqrtd) / a
    if !surrounds(ray_int, root)
        root = (-half_b + sqrtd) / a
        if !surrounds(ray_int, root)
            return false, nothing
        end
    end

    t = root
    p = r.origin + root * r.direction
    outward_normal = (p - s.center) / s.radius
    face , normal = get_face_normal(r, outward_normal)
    rec = HitRecord(p, normal, s.mat, t, face)

    return true, rec
end