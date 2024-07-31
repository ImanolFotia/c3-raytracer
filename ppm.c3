module ppm;

import std::io;
import std::io::file;

def Color = double[<3>];

fn void! write_color(OutStream out, Color color){
    color *= 255.999;
    int[<3>] iColor = (int[<3>])color;
    usz! num_bytes = io::fprintfn(out, "%d %d %d", iColor.x, iColor.y, iColor.z);
}

fn void write_header(OutStream out, int w, int h) {
    io::fprintfn(out, "P3\n%d %d\n255", w, h);
}


fn void save_ppm(String path, int w, int h) {
    io::File! image_file = io::file::open(path, "w");
    defer image_file.close()!!;
    image_file.write("P3\n255 255\n255\n")!!;
    for(int y = 0; y < h; y++)
    	for(int x = 0; x < w; x++) {
	   Color color = {(double)x / (w-1.0), (double)y / (h-1.0), 0};
	   write_color(&image_file, color)!!;
	}
}

