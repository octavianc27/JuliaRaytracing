include("vec3.jl")
include("camera.jl")
include("ray.jl")
include("materials/material.jl")   
include("hit_record.jl")
include("materials/lambertian.jl")
include("materials/metal.jl")
include("interval.jl")
include("hittable.jl")
include("hittable_list.jl")
include("sphere.jl")
include("color_functions.jl")


# Set image characteristics
aspect_ratio = 16.0 / 9.0
image_width = 1920
image_height = round(Int, image_width / aspect_ratio)
samples_per_pixel = 100
max_depth = 50

if image_height < 1
    image_height = 1
end

# Hittable list
world = HittableList(Hittable[])

material_ground = Lambertian(color(0.8, 0.8, 0.0))
material_center = Lambertian(color(0.7, 0.3, 0.3))
material_left = metal(color(0.8, 0.8, 0.8), 0.3)
material_right = metal(color(0.8, 0.6, 0.2), 1.0)

add!(world, Sphere(point3(0, -100.5, -1.0), 100.0, material_ground))
add!(world, Sphere(point3(0, 0, -1.0), 0.5, material_center))
add!(world, Sphere(point3(-1, 0, -1.0), 0.5, material_left))
add!(world, Sphere(point3(1, 0, -1.0), 0.5, material_right))

# Camera
cam = camera()

open("out.ppm", "w") do file
    # Write PPM header
    println(file, "P3")
    println(file, "$image_width $image_height")
    println(file, "255")

    # Write pixel colors
    for j in 1:image_height
        println("Lines remaining :$(image_height-j)")
        for i in 1:image_width
            pixel_color = color(0, 0, 0)

            for s in 1:samples_per_pixel
                u = (i + rand())/(image_width-1)
                v = (j + rand())/(image_height-1)

                r = get_ray(cam, u, v)

                pixel_color+= ray_color(r, world, max_depth)
    
            end
            write_color(file, pixel_color, samples_per_pixel)
        end
    end
    println("Done.")
end