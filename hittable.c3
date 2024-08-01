module hittable;

import rt;
import ray;
import std::io;
import primitive;

import std::collections::list;

struct HitRecord{
    rt::Vec3 p;
    rt::Vec3 n;
    double t;
    bool front_face;
}

interface IHittable {

    fn bool hit(Ray* ray, double t_min, double t_max, HitRecord* hit_record);
}

struct HittableList (IHittable) {
    List(<Sphere>) objects;
}

fn void HitRecord.set_face_normal(HitRecord* this, Ray* ray, rt::Vec3 out_normal){
    this.front_face = ray.direction.dot(out_normal) < 0.0;
    this.n = this.front_face ? out_normal : -out_normal;
}

fn void HittableList.clear(HittableList* this) {
    this.objects.free();
}

fn void HittableList.add(HittableList* this, Sphere object) {
    this.objects.push(object);
}

fn bool HittableList.hit(HittableList* this, Ray* ray, double t_min, double t_max, HitRecord* hit_record) @dynamic {

    bool hit_anything = false;
    double closest_so_far = t_max;

    foreach(&object: this.objects) {
        if(object.hit(ray, t_min, closest_so_far, hit_record)) {
            hit_anything = true;
            closest_so_far = hit_record.t;
        }
    }

    return hit_anything;
}
