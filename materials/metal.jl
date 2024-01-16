 struct metal <: Material
    albedo::color
    fuzz::Float64
end

 function scatter(mat::metal, r_in::ray, rec::HitRecord)
    reflected = reflect(unit_vector(r_in.direction), rec.normal)
    scattered = ray(rec.p, reflected + mat.fuzz * random_in_unit_sphere(), time = r_in.time)
    attenuation = mat.albedo

    test = dot(scattered.direction, rec.normal)>0
    return test, attenuation, scattered
end