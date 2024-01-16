 struct ray
    origin::point3
    direction::vec3
    time::Float64

    function ray(origin::point3, direction::vec3; time::Float64 = 0.0)
        new(origin, direction, time)
    end
end

function at(r::ray, t::Float64)
    return origin(r) + t * direction(r)
end

function direction(r::ray)
    return r.direction
end
