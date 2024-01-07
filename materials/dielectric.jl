 struct dielectric <: Material
    ir::Float64
end

 function reflectance(cosine::Float64, ref_idx::Float64) 
    # Schlick's approximation for reflectance
    r0 = (1-ref_idx) / (1+ref_idx)
    r0 = r0*r0
    return r0 + (1-r0)*(1 - cosine)^5
end

 function scatter(mat::dielectric, r_in::ray, rec::HitRecord)
    attenuation = color(1.0, 1.0, 1.0)
    refraction_ratio = rec.front_face ? (1.0/mat.ir) : mat.ir

    unit_direction = unit_vector(r_in.direction)

    cos_theta = min(dot(-1*unit_direction, rec.normal), 1.0)
    sin_theta = sqrt(1-cos_theta^2)

    cannot_refract = refraction_ratio * sin_theta >1.0

    if cannot_refract || reflectance(cos_theta, refraction_ratio) > rand()
        direction = reflect(unit_direction, rec.normal)
    else
        direction = refract(unit_direction, rec.normal, refraction_ratio)
    end

    scattered = ray(rec.p, direction)
    test = true
    return test, attenuation, scattered
end