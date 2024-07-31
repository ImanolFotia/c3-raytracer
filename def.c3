module rt;

def Vec4 = double[<4>];
def Vec3 = double[<3>];
def Vec2 = double[<2>];

def Vec4i = int[<4>];
def Vec3i = int[<3>];
def Vec2i = int[<2>];

double pi = 3.1415926535897932385;

fn double degrees_to_radians(double degrees) {
    return degrees * pi / 180.0;
}
