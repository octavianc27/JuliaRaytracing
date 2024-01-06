struct ray
    origin::point3
    direction::vec3

    function ray(origin::point3, direction::vec3)
        new(origin, direction)
    end
end

function origin(ray::ray)
    return ray.origin
end

function direction(ray::ray)
    return ray.direction
end

function at(ray::ray, t::Float64)
    return origin(ray) + t * direction(ray)
end

