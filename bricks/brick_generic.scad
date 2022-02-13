// ==============================================
// = Generic Brick                              =
// = Jacob Loss                                 =
// = 02/12/2022                                 =
// = GNU GPLv3.0                                =
// ==============================================

// Generic Brick to be used as a template for the future
module brick_generic(
    size,
    rand = true,
    seed
    ){

    // Undefined global protection
    // These only sometimes work?
    size = is_undef(size) ? $bs     : size;
    seed = is_undef(seed) ? $seed   : seed;
    
    r       = 1;
    r_min   = 0;
    r_max   = 1;
    r_val   = rands(r_min, r_max, r, seed);

    if($d){                                                 // Debug mode (just a cube)
        cube(size);
    } else {                                                // Run mode 
        intersection(){
           
            union(){                                        // Where the magic happens
                r_size = rand ? size * r_val[0] : size;     // Randomly scale brick [0, 1]
                cube(r_size, center=false);
            }

            cube(size);                                     // Cut brick so it is always smaller than size
        }        

    }
}

module _OSBK_test_suite(){
    $d = false;
    $bs = [1, 2, 1];
    r_vals = rands(0, 10000, 11, 1234);
    
    for(i = [0 : 10]){
         
        $seed = r_vals[i];
        
        translate([0, i * 2, 0])
        children(0);
    }

}

module _OSBK_test_brick_generic(){
    _OSBK_test_suite()
    brick_generic();
}
_OSBK_test_brick_generic();
