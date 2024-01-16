struct BVHNode <: Hittable
    left::Hittable
    right::Hittable
    bbox::AABB
end

function BVHNode(list::HittableList)
    return BVHNode(list.objects, 1, length(list.objects))
end

function BVHNode(objects, start::Int, stop::Int)
    axis = rand(1:3)

    comparator = begin
        if axis == 0
            box_x_compare
        elseif axis == 1
            box_y_compare
        else
            box_z_compare
        end
    end

    object_span = stop - start

    if object_span == 1
        left = right = objects[start]
    elseif object_span == 2
        if comparator(objects[start], objects[start+1])
            left = objects[start]
            right = objects[start+1]
        else
            left = objects[start+1]
            right = objects[start]
        end
    else
        objects[start:stop] = sort(objects[start:stop], lt=comparator)
        mid = start + object_span ÷ 2
        left = BVHNode(objects, start, mid)
        right = BVHNode(objects, mid + 1, stop)
    end
    
    bbox = AABB(left.bbox, right.bbox)

    return BVHNode(left, right, bbox)
end

function box_compare(a::Hittable, b::Hittable, axis::Int64)
    if axis == 0
        return a.bbox.x.min < b.bbox.x.min
    elseif axis == 1
        return a.bbox.y.min < b.bbox.y.min
    else
        return a.bbox.z.min < b.bbox.z.min
    end
end

function box_x_compare(a::Hittable, b::Hittable)
    return box_compare(a, b, 0)
end

function box_y_compare(a::Hittable, b::Hittable)
    return box_compare(a, b, 1)
end

function box_z_compare(a::Hittable, b::Hittable)
    return box_compare(a, b, 2)
end

function hit(obj::BVHNode, r::ray, ray_t::Interval)
    bbox_hit, bbox_rec = hit(obj.bbox, r, ray_t)

    if !bbox_hit
        return false, nothing
    end

    hit_left, rec_left = hit(obj.left, r, ray_t)
    hit_right, rec_right = hit(obj.right, r, Interval(ray_t.min, hit_left ? rec_left.t : ray_t.max))

    if hit_left
        return true, rec_left
    end

    if hit_right
        return true, rec_right
    end

    return false, nothing
end
