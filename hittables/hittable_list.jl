 mutable struct HittableList <: Hittable
    objects::Vector{Hittable}
    bbox::AABB
end

function HittableList(objects::Vector{Hittable})
    return HittableList(objects, AABB())
end

function HittableList()
    return HittableList(Hittable[], AABB())
end

 function HittableList(object::Hittable)
    return HittableList([object], AABB())
end

 function clear!(hl::HittableList)
    empty!(hl.objects)
end

 function add!(hl::HittableList, object::Hittable)
    hl.bbox = AABB(hl.bbox, object.bbox)
    push!(hl.objects, object)
end

 function hit(hl::HittableList, r::ray, ray_int::Interval)
    rec = HitRecord()
    hit_anything = false
    closest_so_far = ray_int.max

    for object in hl.objects
        has_hit, record =  hit(object, r, Interval(ray_int.min, closest_so_far))
        if has_hit
            hit_anything = true
            closest_so_far = record.t
            rec = record
        end
    end

    return hit_anything, rec
end
