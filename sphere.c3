module primitive;

import rt;
import hittable;
import ray;

import std::io;

struct Sphere (IHittable) {
    rt::Vec3 center;
    float radius;
}

fn bool Sphere.hit(Sphere* this, Ray* ray, double t_min, double t_max, HitRecord* hit_record) @dynamic {
    rt::Vec3 oc = this.center - ray.position;
    double a = ray.direction.dot(ray.direction);
    double h = ray.direction.dot(oc);
    double c = oc.dot(oc) - (double)(this.radius * this.radius);
    double discriminant = h*h - a*c;
    if(discriminant < 0) {
        return false;
    }

    double sqrtd = $$sqrt(discriminant);
    double root = (h - sqrtd) / a;

    if(root <= t_min || t_max <= root) {
        root = (h + sqrtd) / a;
        if(root <= t_min || t_max <= root) {
            return false;
        }
    }

    hit_record.t = root;
    hit_record.p = ray.at(hit_record.t);
    rt::Vec3 out_normal = (hit_record.p - this.center) / this.radius;
    hit_record.set_face_normal(ray, out_normal.normalize());

    return true;
}
