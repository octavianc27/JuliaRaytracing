 struct ray
    origin::point3
    direction::vec3

    function ray(origin::point3, direction::vec3)
        new(origin, direction)
    end
end

 function at(r::ray, t::Float64)
    return origin(r) + t * direction(r)
end

