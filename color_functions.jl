function ray_color(r::ray, world::HittableList, depth::Int)
    if depth<0
        return color(0, 0, 0)
    end

    has_hit, rec = hit(world, r, Interval(0.0001, Inf64))

    if has_hit
        has_scattered, attenuation, scattered = scatter(rec.mat, r, rec)
        if has_scattered
            return attenuation * ray_color(scattered, world, depth-1)
        end
        return color(0.0, 0.0, 0.0)
    end

    unit_direction = unit_vector(r.direction)
    a = 0.5 * (1 + unit_direction.y)
    return (1.0-a) * color(1.0, 1.0, 1.0) + a * color(0.5, 0.7, 1.0)
end

function write_color(file::IO, pixel_color::color, samples_per_pixel::Int)
    r = pixel_color.x
    g = pixel_color.y
    b = pixel_color.z

    scale = 1.0/samples_per_pixel

    # Divide the color by the number of samples and gamma-correct for gamma=2.0.
    r = sqrt(r*scale)
    g = sqrt(g*scale)
    b = sqrt(b*scale)

    r = trunc(Int, 256*clamp(r, 0, 0.9999))
    g = trunc(Int, 256*clamp(g, 0, 0.9999))
    b = trunc(Int, 256*clamp(b, 0, 0.9999))
    println(file, "$r $g $b")
end