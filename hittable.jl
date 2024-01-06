abstract type Hittable end

function hit(h::Hittable, r::ray, ray_tmin::Float64, ray_tmax::Float64)
    @error "Function 'hit' not implemented for type Hittable"
end

