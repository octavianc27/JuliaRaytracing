 struct HitRecord
    p::point3
    normal::vec3
    mat #material
    t::Float64
    front_face::Bool
end

 function HitRecord()
    return HitRecord(point3(0.0, 0.0, 0.0), vec3(0., 0., 0.), EmptyMaterial(), 0, false)
end

 function get_face_normal(r::ray, outward_normal::vec3)
    front_face = dot(direction(r), outward_normal)<0
    normal = front_face ? outward_normal : -1*outward_normal
    return front_face, normal
end
