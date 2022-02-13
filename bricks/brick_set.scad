// ======================
// = Set-o-Bricks       =
// = Jacob Loss         =
// = 01/30/2022         =
// = GNU GPLv3.0        =
// ======================

// Get generic brick (mostly for the test suite)
use <brick_generic.scad>

// Default Brick Set
// Format : [stlSize, stlFile]
_pbs_test_bricks = [
                        [[1, 2, 1], "test_brick_set/brick0.stl"],
                        [[1, 2, 1], "test_brick_set/brick1.stl"],
                        [[1, 2, 1], "test_brick_set/brick3.stl"],
                    ];

// Place a Brick based on a set of bricks
module brick_set( 
    size = [1, 2, 1],               // Size of brick
    set = _pbs_test_bricks,         // Set of brick, Entry: [[size_x, size_y, size_z], "FileName.stl"]
    stdev = 0.75,                   // Standard Deviation for random brick laying
    ){
    
    // Undefined global protection
    size = is_undef(size) ? $bs     : size;
    seed = is_undef(seed) ? $seed   : seed;
    
    if($d){

        cube(size);

    } else {
        intersection(){
            union(){
                // Random values from the $seed      
                r_vals = rands(0, 10000, 4, $seed);
     
                // Select Brick
                i       = round(r_vals[0]) % len(set);
           
                // Get Rotations
                r_x     = round(r_vals[1]) % 2;
                r_y     = round(r_vals[2]) % 4;
                r_z     = round(r_vals[3]) % 2;

                // Get all brick values and transforms
                c_brick = set[i];
                s_brick = [size[0] / c_brick[0][0], size[1] / c_brick[0][1], size[2] / c_brick[0][2]];
                r_brick = [r_x * 180, r_y * 90, r_z * 180];   
                
                // Generate Brick 
                scale(s_brick)
                translate(c_brick[0] / 2)
                rotate([r_x * 180, r_y * 90,  r_z * 180])
                import(c_brick[1]);
            }
            cube(size);
        }
    }
}

module _OSBK_test_brick_set(){

    _OSBK_test_suite()
    brick_set();

}
_OSBK_test_brick_set();
