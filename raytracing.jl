using Distributed
# addprocs(4)

include("vec3.jl")
include("ray.jl")
include("hittable.jl")
include("interval.jl")
include("hittable_list.jl")
include("camera.jl")
include("hit_record.jl")
include("materials/material.jl")
include("materials/lambertian.jl")
include("materials/metal.jl")
include("materials/dielectric.jl")
include("sphere.jl")
include("color_functions.jl")

# Three spheres world 

# Hittable list
# world = HittableList(Hittable[])

# material_ground = Lambertian(color(0.8, 0.8, 0.0))
# material_center = Lambertian(color(0.7, 0.3, 0.3))
# material_left = dielectric(1.5)
# material_right = metal(color(0.8, 0.6, 0.2), 1.0)

# add!(world, Sphere(point3(0, -100.5, -1.0), 100.0, material_ground))
# add!(world, Sphere(point3(0, 0, -1.0), 0.5, material_center))
# add!(world, Sphere(point3(-1, 0, -1.0), 0.5, material_left))
# add!(world, Sphere(point3(1, 0, -1.0), 0.5, material_right))

#cam = Camera(aspect_ratio = 16.0/9.0, vfov = 20.0, lookfrom = vec3(-2, 2, 1), lookat = vec3(0, 0, -1), vup = vec3(0, 1, 0), defocus_angle = 10.0, focus_dist = 3.4) 

#######################
# Book cover image
world = HittableList(Hittable[])

# Ground material
ground_material = Lambertian(color(0.5, 0.5, 0.5))
add!(world, Sphere(point3(0, -1000, 0), 1000, ground_material))

# Randomly generated spheres
for a = -11:10
    for b = -11:10
        choose_mat = rand()

        center = point3(a + 0.9 * rand(), 0.2, b + 0.9 * rand())

        if norm(center - point3(4, 0.2, 0)) > 0.9
            sphere_material = nothing

            if choose_mat < 0.8
                # Diffuse
                albedo = random_vec()
                sphere_material = Lambertian(albedo)
                add!(world, Sphere(center, 0.2, sphere_material))
            elseif choose_mat < 0.95
                # Metal
                albedo = random_vec()
                fuzz = rand_float(0.0, 0.5)
                sphere_material = metal(albedo, fuzz)
                add!(world, Sphere(center, 0.2, sphere_material))
            else
                # Glass
                sphere_material = dielectric(1.5)
                add!(world, Sphere(center, 0.2, sphere_material))
            end
        end
    end
end

# Additional spheres with different materials
material1 = dielectric(1.5)
add!(world, Sphere(point3(0, 1, 0), 1.0, material1))

material2 = Lambertian(color(0.4, 0.2, 0.1))
add!(world, Sphere(point3(-4, 1, 0), 1.0, material2))

material3 = metal(color(0.7, 0.6, 0.5), 0.0)
add!(world, Sphere(point3(4, 1, 0), 1.0, material3))


# Camera
cam = Camera(aspect_ratio=16.0 / 9.0, image_width=1200, samples_per_pixel=100, max_depth=50, vfov=20.0, lookfrom=point3(13, 2, 3), lookat=point3(0, 0, 0), vup=vec3(0, 1, 0), defocus_angle=0.6, focus_dist=10.0)

render(cam, world)
