struct camera
    aspect_ratio::Float64
    viewport_height::Float64
    viewport_width::Float64
    focal_length::Float64
    origin::point3
    horizontal::vec3
    vertical::vec3
    lower_left_corner::vec3
end

function camera()
    return camera(
        16.0 / 9.0,
        2.0,
        (2.0) * (16.0 / 9.0),
        1.0,
        point3(0.0, 0.0, 0.0),
        vec3((2.0) * (16.0 / 9.0), 0.0, 0.0),
        vec3(0.0, -2.0, 0.0),
        point3(0.0, 0.0, 0.0) - vec3((2.0) * (16.0 / 9.0), 0.0, 0.0) / 2 - vec3(0.0, -2.0, 0.0) / 2 - vec3(0, 0, 1.0)
    )
end

function get_ray(cam::camera, u::Float64, v::Float64)
    return ray(cam.origin, cam.lower_left_corner + u * cam.horizontal + v * cam.vertical - cam.origin)
end
