 abstract type Material end

 struct EmptyMaterial <: Material
end

function scatter(mat::Material, r_in::ray, rec::HitRecord)
    
end