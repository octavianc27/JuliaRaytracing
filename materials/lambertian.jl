struct Lambertian <: Material
    albedo::color
end

function scatter(mat::Lambertian, r_in::ray, rec::HitRecord)
    scatter_direction = rec.normal + random_unit_vector()

    if near_zero(scatter_direction)
        scatter_direction = rec.normal
    end

    scattered = ray(rec.p, scatter_direction, time = r_in.time)
    attenuation = mat.albedo
    return true, attenuation, scattered
end