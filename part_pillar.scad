// ======================
// = Pillar Builder     =
// = Jacob Loss         =
// = 02/12/2022         =
// = GNU GPLv3.0        =
// ======================

// Imports/Use
use <bricks/OSBK_bricks.scad>

// Default Values
_ppb_height     = 10;
_ppb_b_size     = [1, 2, 1];
_ppb_sides      = [1, 1, 1, 1, 1, 0];
_ppb_depth      = 0.15;
_ppb_v_gap      = 0;           
_ppb_v_off      = 0;
_ppb_int_block  = true;
_ppb_exp_factor = 0.01;
_ppb_seed       = 1234567890;

module build_pillar(
    height      = _ppb_height,          // Height of pillar 
                                        //  : double (0, inf]
    b_size      = _ppb_b_size,          // Size of bricks
                                        //  : double vector3, (0, inf], [x, y, z]
    b_sides     = _ppb_sides,           // Bricked Sides, note that if trim is on cut sides will not show brick.
                                        //  : Vector6, boolean, [x+, x-, y+, y-, z+, z-]
    depth       = _ppb_depth,           // Depth factor of internal cube. Closer to 0.5 -> small cube, closer to 0 -> larger cube. At 0.5, there will be no cube
                                        //  : double (0, 0.5]
    v_gap       = _ppb_v_gap,           // Vertical gap factor, makes a gap of v_gap * b_size.z between bricks
                                        //  : double [0, inf]
    v_off       = _ppb_v_off,           // Vertical offset factor, changes the vertical offset of the bricks such that they are vertical displaced
                                        //  : double [0, height / b_size[2]]
    int_block   = _ppb_int_block,       // Interior block trigger, if false, no interior block is generated and b_sides is ignored
                                        //  : boolean [true = on, false = off]    
    exp_factor  = _ppb_exp_factor,      // Expansion factor of b_sides (as percen tage of brick size in that direction)
                                        //  : double [0, 1]
    seed        = _ppb_seed             // Seed used for random generation. Save see to get the same bricks
                                        //  : double [-inf, inf]
    ){

    // Variable checks
    assert(height > 0, "height must be greater than 0");
    assert(b_size[0] > 0 && b_size[1] > 0 && b_size[2] > 0, "Brick size must be greater than 0 on all dimensions");
    assert(depth > 0 && depth <= 0.5, "depth must be [0 - 1]");    
    assert(v_gap >= 0, "v_gap must be greater than or equal to 0");    
    assert(exp_factor >= 0 && exp_factor <= 1, "exp_factor must be [0 - 1]");

    b_slots = height / b_size[2];
    assert(v_off >= 0 && v_off <= b_slots, "v_off must be between 0 and height / b_size[2]");
  
    // Normalized v_off (in case ya fuck up) 
    v_off_n     = v_off % (v_gap + 1);
    // Repetitions of bricks (excluding negative fill brick) 
    reps        = floor(height / (b_size[2] + v_gap * b_size[2]));
    // reps + 1 Random values for brick seeding
    r_val       = rands(0, 1000, reps + 2, seed);           

    // Functions
    function z_scale(loc, height, b_h) = 
        (loc < 0) 
            ? (b_h + loc) / b_h
            :       // Elif
            (loc + b_h <= height) 
                ? 1 
                : ((height - loc) / b_h);

    //echo("z_scale", z_scale(0, 10, 1));
    
    function z_trans(loc, height, b_h) = 
        (loc < 0) 
            ? 0
            : (loc > height)
                ? height    // Maximum is height
                : loc;      // Else

    //echo("z_trans", z_trans(-0.2, 10, 1));
            
    function z_loc(b_h, i, off, gap) = i * (b_h + b_h * gap) + off * b_h; 

    // Set brick size for later
    $bs    = b_size;

    debug  = is_undef($d) ?     $d  : false; 

    if(debug || !(b_sides[0] || b_sides[1] || b_sides[2] || b_sides[3] || b_sides[4] || b_sides[5])){
        cube([b_size[0], b_size[1], height]);
    } else {
        union(){
          

            for(i = [-1 : reps]){ 
            
                $seed = r_val[i + 1];
                    
                //echo("i = ", i);
                //echo(r_val[i + 1]);
                //echo("$seed =", $seed);
         
                z = z_loc(b_size[2], i, v_off_n, v_gap);
                //echo("z = ", z);

                z_t = z_trans(z, height, b_size[2]);
                //echo("z_t = ", z_t);

                z_s = z_scale(z, height, b_size[2]) < 0 ? 0 : z_scale(z, height, b_size[2]);
                //echo("z_s = ", z_s);
                //echo("===============");
                if(z_s != 0){
                    translate([0, 0, z_t])
                    scale([1, 1, z_s])
                    children(0);
                }
            }

            // Generate flats and interior
            if(int_block){
                x_off_p     = b_sides[0] * depth * b_size[0] - ((b_sides[0] + 1) % 2) * exp_factor * b_size[0];
                x_off_n     = b_sides[1] * depth * b_size[0] - ((b_sides[1] + 1) % 2) * exp_factor * b_size[0];
                x_off       = x_off_p + x_off_n;
            
                y_off_p     = b_sides[2] * depth * b_size[1] - ((b_sides[2] + 1) % 2) * exp_factor * b_size[1];
                y_off_n     = b_sides[3] * depth * b_size[1] - ((b_sides[3] + 1) % 2) * exp_factor * b_size[1];
                y_off       = y_off_p + y_off_n;
            
                z_off_p     = b_sides[4] * depth * b_size[2] - ((b_sides[4] + 1) % 2) * exp_factor * b_size[2];
                z_off_n     = b_sides[5] * depth * b_size[2] - ((b_sides[5] + 1) % 2) * exp_factor * b_size[2];
                z_off       = z_off_p + z_off_n;
           
                dims_z      = height - z_off;
                dims        = [b_size[0] - x_off, b_size[1] - y_off, dims_z];
                mv          = [x_off_n, y_off_n, z_off_n];
            
                translate(mv)
                cube(dims);
            }
        }
    }
}

module _ppb_test_build_pillar(){
    $d = false;
    
    // Default test pillar
    build_pillar()
    brick_inter();

    // Custom Wall 1
    translate([0, 4, 0])
    union(){
    
        build_pillar(v_off = 1, v_gap = 1, seed = 456031, b_sides = [1, 0, 0, 1, 1, 1], int_block = false)
        brick_inter(max_a = 4);
 
        build_pillar(b_size = [1, 1, 1], v_off = 0, v_gap = 1, seed = 554354, b_sides = [1, 0, 0, 1, 1, 1], int_block = false)
        brick_inter(max_a = 4);

        translate([0, 1, 0])
        build_pillar(v_off = 0, v_gap = 1, seed = 45603, b_sides = [1, 0, 1, 0, 1, 1], int_block = false)
        brick_inter(max_a = 4);
        
        translate([0, 2, 0])
        build_pillar(b_size = [1, 1, 1], v_off = 1, v_gap = 1, seed = 554354, b_sides = [1, 0, 0, 1, 1, 1], int_block = false)
        brick_inter(max_a = 4);

    }

    // Custom Wall 2
    translate([0, 8, 0])
    union(){
        build_pillar(height = 9, v_off = 1, v_gap = 0.5, seed = 54321)
        brick_inter();
    
        translate([0, 1, 0])
        build_pillar(height = 9, b_size = [1, 2, 0.5], v_off = 1, v_gap = 2, seed = 1245)
        brick_inter();


        translate([0, 0, 0])
        build_pillar(height = 9, b_size = [1, 1, 0.5], v_off = 1, v_gap = 2, seed = 898775)
        brick_inter();
        
        translate([0, 3, 0])
        build_pillar(height = 9, b_size = [1, 1, 0.5], v_off = 1, v_gap = 2, seed = 13584)
        brick_inter();

        translate([0, 2, 0])
        build_pillar(height = 9, v_off = 1, v_gap = 0.5, seed = 54321)
        brick_inter();

    }
    
    // Custom Corner Pillar
    translate([0, 14, 0])
    union(){
    
        build_pillar(height = 12, b_size = [2, 2, 2], v_off = 0.5, v_gap = 0, b_sides = [1, 0, 0, 1, 0, 0])
        brick_inter(max_a = 2);

    }
    
    // v_off test
    color("salmon")
    translate([-5, 0, 0])
    union(){
        
        
        build_pillar(height = 12, b_size = [2, 2, 2], v_off = 0, v_gap = 2, b_sides = [1, 0, 0, 1, 0, 0])
        brick_inter(max_a = 2);
        
        translate([0, 3, 0])
        build_pillar(height = 12, b_size = [2, 2, 2], v_off = 1, v_gap = 2, b_sides = [1, 0, 0, 1, 0, 0])
        brick_inter(max_a = 2);
        
        translate([0, 6, 0])
        build_pillar(height = 12, b_size = [2, 2, 2], v_off = 2, v_gap = 2, b_sides = [1, 0, 0, 1, 0, 0])
        brick_inter(max_a = 2);
        
        translate([0, 9, 0])
        build_pillar(height = 12, b_size = [2, 2, 2], v_off = 3, v_gap = 2, b_sides = [1, 0, 0, 1, 0, 0])
        brick_inter(max_a = 2);
        
        translate([0, 12, 0])
        build_pillar(height = 12, b_size = [2, 2, 2], v_off = 4, v_gap = 2, b_sides = [1, 0, 0, 1, 0, 0])
        brick_inter(max_a = 2);
       
        translate([0, 16, 0])
        build_pillar(height = 12, b_size = [2, 2, 2], v_off = 5, v_gap = 2, b_sides = [1, 0, 0, 1, 0, 0])
        brick_inter(max_a = 2);
        
    }
}
_ppb_test_build_pillar();
