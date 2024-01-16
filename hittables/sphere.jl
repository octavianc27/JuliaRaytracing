struct Sphere <: Hittable
    center1::point3
    radius::Float64
    mat::Material
    is_moving::Bool
    center_vec::vec3
    bbox::AABB

    function Sphere(center::point3, radius::Float64, material::Material)
        rvec = vec3(radius, radius, radius)
        return new(center, radius, material, false, vec3(0.0, 0.0, 0.0), AABB(center-rvec, center+rvec))
    end
    
    function Sphere(center1::point3, center2::point3, radius::Float64, material::Material)
        center_vec = center2 - center1
        rvec = vec3(radius, radius, radius)

        box1 = AABB(center1-rvec, center1+rvec)
        box2 = AABB(center2-rvec, center2+rvec)

        return new(center1, radius, material, true, center_vec, AABB(box1, box2))
    end
end

function center(sphere::Sphere, time::Float64)
    if sphere.is_moving
        return sphere.center1 + time * sphere.center_vec
    else
        return sphere.center1
    end
end

function hit(s::Sphere, r::ray, ray_int::Interval)

    sphere_center = s.is_moving ? center(s, r.time) : s.center1

    oc = r.origin - sphere_center
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
    outward_normal = (p - sphere_center) / s.radius
    face, normal = get_face_normal(r, outward_normal)
    rec = HitRecord(p, normal, s.mat, t, face)

    return true, rec
end