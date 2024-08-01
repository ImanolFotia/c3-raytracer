//c3c compile raytracer.c3 ppm.c3 def.c3 ray.c3 sphere.c3 hittable.c3

import std::io;
import ppm;
import ray;
import rt;
import hittable;
import primitive;

HitRecord hit_record;


fn ppm::Color ray_color(Ray* ray, HittableList* world) {
    HitRecord hit_record;

    if(world.hit(ray, 0.0, double.max, &hit_record)) {
        return 0.5*(hit_record.n + 1.0);
    }

    rt::Vec3 unit_direction = ray.direction.normalize();
    double a = 0.5 * (unit_direction.y + 1.0);
    return (1.0 - a)*rt::Vec3{1.0, 1.0, 1.0} + a * rt::Vec3{0.5, 0.7, 1.0};
}

fn void main() {
    File! image_output = io::file::open("image.ppm", "w");
    defer image_output.close()!!;
    double aspect_ratio = 16.0 / 9.0;
    int width = 400;
    int height = (int)(width / aspect_ratio);
    height = (height < 1) ? 1 : height;

    HittableList world;

    world.add({{0.0, 0.0, -1.0}, 0.5});
    world.add({{0.0, -100.5, -1.0}, 100.0});
    
    double focal_length = 1.0;
    double viewport_height = 2.0;
    double viewport_width = viewport_height * ((double)(width)/height);
    rt::Vec3 camera_center = {0.0, 0.0, 0.0};

    rt::Vec3 viewport_u = {viewport_width, 0.0, 0.0};
    rt::Vec3 viewport_v = {0, -viewport_height, 0};

    rt::Vec3 pixel_delta_u = viewport_u / width;
    rt::Vec3 pixel_delta_v = viewport_v / height;

    rt::Vec3 viewport_upper_left = camera_center - {0.0, 0.0, focal_length} - viewport_u/2.0 - viewport_v / 2.0;
    rt::Vec3 pixel00_loc = viewport_upper_left + 0.5 * (pixel_delta_u + pixel_delta_v);

    (void) ppm::write_header(&image_output, width, height);

    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            rt::Vec3 pixel_center = pixel00_loc + (x * pixel_delta_u) + (y * pixel_delta_v);
            rt::Vec3 ray_direction = pixel_center - camera_center;

            Ray ray = {camera_center, ray_direction};

            ppm::Color pixel_color = ray_color(&ray, &world);
            (void) ppm::write_color(&image_output, pixel_color);
	    }
    }
}
