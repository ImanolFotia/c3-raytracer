module ray;

import rt;
import primitive;

struct Ray {
    Vec3 position;
    Vec3 direction;
}

fn Vec3 Ray.at(Ray* this, double t) {
    return this.position + this.direction * t;
}

