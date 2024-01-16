struct AABB
    x::Interval
    y::Interval
    z::Interval

    function AABB()
        new(Interval(), Interval(), Interval())
    end

    function AABB(ix::Interval, iy::Interval, iz::Interval)
        new(ix, iy, iz)
    end

    function AABB(a::point3, b::point3)
        x = Interval(min(a.x, b.x), max(a.x, b.x))
        y = Interval(min(a.y, b.y), max(a.y, b.y))
        z = Interval(min(a.z, b.z), max(a.z, b.z))
        new(x, y, z)
    end

    function AABB(a::AABB, b::AABB)
        x = Interval(a.x, b.x)
        y = Interval(a.y, b.y)
        z = Interval(a.z, b.z)
        new(x, y, z)
    end
end

function axis(obj::AABB, n::Int)
    if n == 2
        return obj.y
    elseif n == 3
        return obj.z
    else
        return obj.x
    end
end

function hit(obj::AABB, r::ray, ray_t::Interval)
    for a in 1:3
        invD = 1 / r.direction[a]
        orig = r.origin[a]

        t0 = (axis(obj, a).min - orig) * invD
        t1 = (axis(obj, a).max - orig) * invD
        
        r_min = ray_t.min
        r_max = ray_t.max

        if invD < 0
            t0, t1 = t1, t0
        end

        if t0 > r_min
            r_min = t0
        end

        if t1 < r_max
            r_max = t1
        end

        if r_max <= r_min
            return false, nothing
        end
    end
    return true, nothing
end