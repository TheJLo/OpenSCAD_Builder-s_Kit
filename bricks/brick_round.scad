// ==============================================
// = Rounded Brick                              =
// = Jacob Loss                                 =
// = 02/27/2022                                 =
// = GNU GPLv3.0                                =
// ==============================================

// Generic Brick to be used as a template for the future
module brick_round(
    size,
    radius = 0.25    
    ){

    // Undefined global protection
    // These only sometimes work?
    size = is_undef(size) ? $bs     : size;
    // No randomness to this one
    //seed = is_undef(seed) ? $seed   : seed;

    if($d){                                                 // Debug mode (just a cube)
        cube(size);
    } else {                                                // Run mode
        intersection(){ 
        difference(){
            cube(size, center=false);
            // Cutter
            union(){
                
                translate([0, radius, radius])
                rotate([180, 0, 0])
                difference(){
                    cube([size[0], radius, radius]);
                    rotate([0, 90, 0])
                    cylinder(r = radius, h = size[0]);
                }
                
                translate([0, size[1] - radius, radius])
                rotate([-90, 0, 0])
                difference(){
                    cube([size[0], radius, radius]);
                    rotate([0, 90, 0])
                    cylinder(r = radius, h = size[0]);
                }
                
                translate([0, radius, size[2] - radius])
                rotate([90, 0, 0])
                difference(){
                    cube([size[0], radius, radius]);
                    rotate([0, 90, 0])
                    cylinder(r = radius, h = size[0]);
                }
                
                translate([0, size[1] - radius, size[2] - radius])
                rotate([0, 0, 0])
                difference(){
                    cube([size[0], radius, radius]);
                    rotate([0, 90, 0])
                    cylinder(r = radius, h = size[0]);
                }
                
                translate([radius, 0, radius])
                rotate([0, 180, 0])
                difference(){
                    cube([radius, size[1], radius]);
                    rotate([-90, 0, 0])
                    cylinder(r = radius, h = size[1]);
                }
                
                translate([size[0] - radius, 0, radius])
                rotate([0, 90, 0])
                difference(){
                    cube([radius, size[1], radius]);
                    rotate([-90, 0, 0])
                    cylinder(r = radius, h = size[1]);
                }
                
                translate([size[0] - radius, 0, size[2] - radius])
                rotate([0, 0, 0])
                difference(){
                    cube([radius, size[1], radius]);
                    rotate([-90, 0, 0])
                    cylinder(r = radius, h = size[1]);
                }
                
                translate([radius, 0, size[2] - radius])
                rotate([0, -90, 0])
                difference(){
                    cube([radius, size[1], radius]);
                    rotate([-90, 0, 0])
                    cylinder(r = radius, h = size[1]);
                }
                
                translate([radius, radius, 0])
                rotate([0, 0, 180])
                difference(){
                    cube([radius, radius, size[2]]);
                    rotate([0, 0, 0])
                    cylinder(r = radius, h = size[2]);
                }
                
                translate([radius, size[1] - radius, 0])
                rotate([0, 0, 90])
                difference(){
                    cube([radius, radius, size[2]]);
                    rotate([0, 0, 0])
                    cylinder(r = radius, h = size[2]);
                }
                
                translate([size[0] - radius, size[1] - radius, 0])
                rotate([0, 0, 0])
                difference(){
                    cube([radius, radius, size[2]]);
                    rotate([0, 0, 0])
                    cylinder(r = radius, h = size[2]);
                }
                
                translate([size[0] - radius, radius, 0])
                rotate([0, 0, -90])
                difference(){
                    cube([radius, radius, size[2]]);
                    rotate([0, 0, 0])
                    cylinder(r = radius, h = size[2]);
                }
                
                translate([radius, radius, radius])
                rotate([0, 90, 180])
                difference(){
                    cube([radius, radius, radius]);
                    sphere(r = radius * 1.01);
                }
                
                translate([size[0] - radius, size[1] - radius, radius])
                rotate([0, 90, 0])
                difference(){
                    cube([radius, radius, radius]);
                    sphere(r = radius * 1.01);
                }
                
                translate([radius, size[1] - radius, radius])
                rotate([0, 90, 90])
                difference(){
                    cube([radius, radius, radius]);
                    sphere(r = radius * 1.01);
                }
                
                translate([size[0] - radius, radius, radius])
                rotate([0, 90, -90])
                difference(){
                    cube([radius, radius, radius]);
                    sphere(r = radius * 1.01);
                }
                
                translate([size[0] - radius, size[1] - radius, size[2] - radius])
                rotate([0, 0, 0])
                difference(){
                    cube([radius, radius, radius]);
                    sphere(r = radius * 1.01);
                }
                
                translate([radius, size[1] - radius, size[2] - radius])
                rotate([0, 0, 90])
                difference(){
                    cube([radius, radius, radius]);
                    sphere(r = radius * 1.01);
                }
                
                translate([radius, radius, size[2] - radius])
                rotate([0, 0, 180])
                difference(){
                    cube([radius, radius, radius]);
                    sphere(r = radius * 1.01);
                }
                
                translate([size[0] - radius, radius, size[2] - radius])
                rotate([0, 0, -90])
                difference(){
                    cube([radius, radius, radius]);
                    sphere(r = radius * 1.01);
                }
            }
            }

            translate(size * 0.0005)
            cube(size = size * 0.999, center = false);

        }
    }
}

module _OSBK_test_suite(){
    $d = false;
    $bs = [1, 2, 1];
    $fn = 50;   
 
    for(i = [0 : 10]){
         
        //$seed = r_vals[i];
        
        translate([0, i * 2, 0])
        children(0);
    }

}

module _OSBK_test_brick_generic(){
    _OSBK_test_suite()
    brick_round();
}
_OSBK_test_brick_generic();
