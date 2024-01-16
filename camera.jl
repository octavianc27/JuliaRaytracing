 struct Camera
    aspect_ratio::Float64
    image_width::Int64
    image_height::Int64
    center::point3
    pixel00_loc::point3
    pixel_delta_u::vec3
    pixel_delta_v::vec3
    samples_per_pixel::Int64
    max_depth::Int64
    vfov::Float64
    lookfrom::point3
    lookat::point3
    vup::vec3
    defocus_angle::Float64
    focus_dist::Float64
    defocus_disk_u::vec3
    defocus_disk_v::vec3
end

 function Camera(; aspect_ratio::Float64=1.0, image_width::Int64=400, samples_per_pixel::Int64=100, max_depth::Int64=50, vfov::Float64=90.0, lookfrom::point3=point3(0.0, 0.0, -1.0), lookat::point3=point3(0.0, 0.0, 0.0), vup::vec3=vec3(0.0, 1.0, 0.0), defocus_angle::Float64=0.0, focus_dist::Float64=10.0)
    image_height = trunc(image_width / aspect_ratio)
    image_height = (image_height < 1) ? 1 : image_height

    center = lookfrom

    theta = deg2rad(vfov)
    h = tan(theta / 2)
    viewport_height = 2 * h * focus_dist
    viewport_width = viewport_height * (1.0 * image_width / image_height)

    w = unit_vector(lookfrom - lookat)
    u = unit_vector(cross(vup, w))
    v = cross(w, u)

    viewport_u = viewport_width * u
    viewport_v = -viewport_height * v

    pixel_delta_u = viewport_u / image_width
    pixel_delta_v = viewport_v / image_height

    viewport_upper_left = center - focus_dist * w - viewport_u / 2 - viewport_v / 2

    pixel00_loc = viewport_upper_left + 0.5 * (pixel_delta_u + pixel_delta_v)

    # Calculate the camera defocus disk basis vectors.
    defocus_radius = focus_dist * tan(deg2rad(defocus_angle / 2))
    defocus_disk_u = u * defocus_radius
    defocus_disk_v = v * defocus_radius

    return Camera(aspect_ratio, image_width, image_height, center, pixel00_loc, pixel_delta_u, pixel_delta_v, samples_per_pixel, max_depth, vfov, lookfrom, lookat, vup, defocus_angle, focus_dist, defocus_disk_u, defocus_disk_v)
end

 function defocus_disk_sample(cam::Camera)
    # Returns a random point in the camera defocus disk.
    p = random_in_unit_disk()
    return cam.center + (p.x * cam.defocus_disk_u) + (p.y * cam.defocus_disk_v)
end

 function pixel_sample_square(cam::Camera)
    px = -0.5 + rand()
    py = -0.5 + rand()
    return (px * cam.pixel_delta_u) + (py * cam.pixel_delta_v)
end

 function get_ray(cam::Camera, i::Int64, j::Int64)
    pixel_center = cam.pixel00_loc + i * cam.pixel_delta_u + j * cam.pixel_delta_v
    pixel_sample = pixel_center + pixel_sample_square(cam)

    ray_origin = (cam.defocus_angle <= 0) ? cam.center : defocus_disk_sample(cam)
    ray_direction = pixel_sample - ray_origin

    time = rand()

    return ray(ray_origin, ray_direction, time = time)
end

 function render(cam::Camera, world::HittableList)
    open("out.ppm", "w") do file
        # Write PPM header
        println(file, "P3")
        println(file, "$(cam.image_width) $(cam.image_height)")
        println(file, "255")

        # Write pixel colors
        for j in 1:cam.image_height
            println("Lines remaining: $(cam.image_height-j)")
            for i in 1:cam.image_width
                pixel_color = color(0, 0, 0)
                for s in 1:cam.samples_per_pixel
                    r = get_ray(cam, i, j)
                    pixel_color+=ray_color(r, world, cam.max_depth)
                end
                write_color(file, pixel_color, cam.samples_per_pixel)
            end
        end
        println("Done.")
    end
end