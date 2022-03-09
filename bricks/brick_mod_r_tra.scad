// ======================================
// = Brick Mod random translate         =
// = Jacob Loss                         =
// = 03/08/2022                         =
// = GNU GPLv3.0                        =
// ======================================

// Randomly scale bricks between s_min, s_max
module brick_mod_r_translate(
    size,
    t_min = [-0.05, -0.05, -0.05],
    t_max = [0.05, 0.05, 0.05],
    trim = false,
    seed
    ){

    // Undefined global protection
    // These only sometimes work?
    size = is_undef(size) ? $bs     : size;
    seed = is_undef(seed) ? $seed   : seed;

    r_vals = rands(0, 100000, 3, seed);

    tr = [
        rands(size[0] * t_min[0], size[0] * t_max[0], 1, r_vals[0])[0],
        rands(size[1] * t_min[1], size[1] * t_max[1], 1, r_vals[1])[0],
        rands(size[2] * t_min[2], size[2] * t_max[2], 1, r_vals[2])[0] 
    ];

    if(trim){
        intersection(){
            translate(tr)
            children(0);
            cube(size);
        }
    } else {
        translate(tr)
        children(0);
    }
}
