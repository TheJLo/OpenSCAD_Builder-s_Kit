// ======================
// = Wall Builder       =
// = Jacob Loss         =
// = 01/23/2022         =
// = GNU GPLv3.0        =
// ======================

// Generate a wall using a repeated mesh (ie. a brick) or a collection of meshes

// Imports/Use
use <bricks/OSBK_bricks.scad>
use <part_pillar.scad>

// Default Settings
_pwb_length  = 10;
_pwb_height  = 10;
_pwb_b_size  = [1, 2, 1];           
_pwb_sides   = [1, 0, 1, 1, 1, 0];  
_pwb_depth   = 0.15;  
_pwb_v_gap   = 0.0;
_pwb_v_off   = 0.0;
_pwb_h_gap   = 0.0;
_pwb_h_off   = 0.0;
_pwb_off_n   = 2;
_pwb_seed    = 53;    

// Builds a 1 brick thick wall
module build_wall(
        length      = 10,                   // Wall Length
                                            //  : double (0, inf]
        height      = 10,                   // Wall Height
                                            //  : double (0, inf]
        b_size      = _pwb_b_size,          // Brick size
                                            //  : double vector3 (0, inf], [x, y, z]
        b_sides     = _pwb_sides,           // Sides with bricks
                                            //  : int vector6 [0, 1], [x+, x-, y+, y-, z+, z-]
        depth       = _pwb_depth,           // Depth of wall
                                            //  : double (0.5, 1]
        v_gap       = _pwb_v_gap,           // Vertical Gap
                                            //  : double [0, height / b_size[2]]
        v_off       = _pwb_v_off,           // Vertical Offset
                                            //  : double [0, v_gap]
        h_gap       = _pwb_h_gap,           // Horizontal Gap
                                            //  : double [0, lengh / b_size[1]]
        h_off       = _pwb_h_off,           // Horizontal Offset
                                            //  : double [0, h_gap]
        off_n       = _pwb_off_n,           // Offset layer count (ONLY 1 OR 2)
                                            //  : integer [1, 2]
        seed        = _pwb_seed             // Random seed
                                            //  : double (-inf, inf)
    ){

    // Parameter checks (these should exist but I don't want to remember what they should be right now)
    // Please tell me if there is a parameter set that breaks things! (P.S. it's your fault)


    // Global protections (that don't always work)
    debug = is_undef($d) ? $d : false;

    // Variable Processing
    v_gap_n     = off_n * (b_size[2] + v_gap); 
    h_span      = b_size[1] + h_gap;
    reps        = floor((length * off_n) / h_span);
    r_val       = rands(0, 1000, reps + off_n * 2, seed);           

    // Useful functions
    function y_scale(loc, len, b_l) = 
        (loc < 0) 
            ? (b_l + loc) / b_l
            :       // Elif
            (loc + b_l <= len) 
                ? 1 
                : ((len - loc) / b_l);

    function y_trans(loc) = (loc <= 0) ? 0 : loc;

    function y_loc(b_l, i, off, gap, n) = i * (b_l + gap * b_l) / n + off * b_l; 

    // Only makes a one brick thick wall
    if(debug || !(b_sides[0] || b_sides[1] || b_sides[2] || b_sides[3] || b_sides[4] || b_sides[5])){

        cube([length, b_size[1], height]);

    } else { // Run

        for(i = [-off_n : reps]){
            
            set = abs(i) % off_n; 
            
            // Vertical calcs
            p_v_gap = off_n - 1 + off_n * v_gap;
            p_v_off = set + v_off + set * v_gap;

            // Y calcs
            y       = y_loc(b_size[1], i, h_off, h_gap, off_n);
            y_tran  = y_trans(y);
            y_s     = y_scale(y, length, b_size[1]);

            //echo("i =", i);
            //echo("y =", y);
            //echo("set =", set);
            //echo("off_n =", off_n);

            if(y_s > 0){
                
                b_size_n = [b_size[0], y_s * b_size[1], b_size[2]];

                translate([0, y_tran, 0])
                build_pillar(
                    height  = height,
                    b_size  = b_size_n,
                    b_sides = b_sides,
                    depth   = depth,
                    v_gap   = p_v_gap,
                    v_off   = p_v_off,
                    seed    = r_val[i + off_n]
                )
                children(0);
            }
        }
            
        // generate flats and interior
        x_off_p     = b_sides[0] * depth * b_size[0];
        x_off_n     = b_sides[1] * depth * b_size[0];
        x_off       = x_off_p + x_off_n;
    
        y_off_p     = b_sides[2] * depth * b_size[1];
        y_off_n     = b_sides[3] * depth * b_size[1];
        y_off       = y_off_p + y_off_n;
    
        z_off_p     = b_sides[4] * depth * b_size[2];
        z_off_n     = b_sides[5] * depth * b_size[2];
        z_off       = z_off_p + z_off_n;
   
        dims_x      = b_size[0] - x_off;
        dims_y      = length    - y_off;
        dims_z      = height    - z_off;
        dims        = [dims_x, dims_y, dims_z];
        mv          = [x_off_n, y_off_n, z_off_n];
    
        translate(mv)
        cube(dims);
    }
}

// Example of test wall macro
module _pwb_my_test_wall(l, h, seed, b_sides = [1, 0, 0, 0, 1, 0]){

    build_wall(
        length      = l,        
        height      = h,         
        b_size      = [2, 2, 2],          
        b_sides     = b_sides, 
        depth       = 0.25,               
        v_gap       = 0.0,           
        v_off       = 0.0,           
        h_gap       = 0.0,           
        h_off       = 0.0,
        off_n       = 2,
        seed        = seed
    )
    brick_inter(max_a = 3, n = 6);

}

module _pwb_my_test_pillar(h, seed, b_sides = [1, 0, 0, 1, 1, 0]){

    build_pillar(height = h, b_size = [3, 3, 3], depth = 0.5, v_off = 0.7, v_gap = 0, b_sides = b_sides, seed = seed)
    brick_inter(max_a = 3, n = 6);

}

// Full wall test
module _pwb_test_build_wall(){
    
    $d = false;
   
    // Default wall 
    build_wall()
    brick_inter(max_a = 4, n = 4);

    // Custom Wall
    translate([0, 12, 0])
    build_wall(
        length      = 10,        
        height      = 5,         
        b_size      = [1, 2, 2],          
        b_sides     = [1, 1, 1, 1, 1, 0], 
        depth       = 0.25,               
        v_gap       = 0.05,           
        v_off       = 0.75,           
        h_gap       = 0.05,           
        h_off       = 0.5,
        seed        = 125468
    )
    brick_inter(max_a = 2, n = 6);

    // Custom wall (same from pillar)
    union(){
        translate([0, 24, 0])
        build_wall(
            length      = 10,        
            height      = 10,         
            b_size      = [1, 2, 1],          
            b_sides     = [1, 1, 1, 1, 1, 0], 
            depth       = 0.25,               
            v_gap       = 0.5,           
            v_off       = 0.0,           
            h_gap       = 0.0,           
            h_off       = 0.0,
            off_n       = 1,
            seed        = 814756
        )
        brick_inter(max_a = 10, n = 3);
        
        translate([0, 24, 0])
        build_wall(
            length      = 10,        
            height      = 10,         
            b_size      = [1, 2, 0.5],          
            b_sides     = [1, 1, 1, 1, 1, 0], 
            depth       = 0.25,               
            v_gap       = 2,           
            v_off       = 2,           
            h_gap       = 0.0,           
            h_off       = 0.5,
            off_n       = 1,
            seed        = 75838
        )
        brick_inter(max_a = 10, n = 3);
    
    }

    // Box
    translate([-10, 0, 0])
    union(){

        translate([0, 0, 0])
        rotate([0, 0, 0])
        _pwb_my_test_wall(22, 10, 13458694);
        
        translate([0, -3, 0])
        rotate([0, 0, 0])
        _pwb_my_test_pillar(10, 186548);
        
        translate([0, 20, 0])
        rotate([0, 0, 90])
        _pwb_my_test_wall(22, 10, 86557);
        
        translate([3, 20, 0])
        rotate([0, 0, 90])
        _pwb_my_test_pillar(10, 1868258);
       
        //_pwb_my_test_pillar(20, 186482548);
 
        translate([-20, 20, 0])
        rotate([0, 0, 180])
        _pwb_my_test_wall(22, 10, 99785);
        
        translate([-20, 23, 0])
        rotate([0, 0, 180])
        _pwb_my_test_pillar(10, 14828);
       
         translate([-20, 0, 0])
         rotate([0, 0, 270])
        _pwb_my_test_wall(22, 10, 1887522);
        
        translate([-23, 0, 0])
        rotate([0, 0, 270])
        _pwb_my_test_pillar(10, 186486688);
    }
}
_pwb_test_build_wall();
