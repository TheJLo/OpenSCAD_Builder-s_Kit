// ======================================
// = Brick Mod random scale             =
// = Jacob Loss                         =
// = 03/08/2022                         =
// = GNU GPLv3.0                        =
// ======================================

// Randomly scale bricks between s_min, s_max
module brick_mod_r_scale(
    size,
    s_min = [0.95, 0.95, 0.95],
    s_max = [1.05, 1.05, 1.05],
    trim = false,
    seed
    ){

    // Undefined global protection
    // These only sometimes work?
    size = is_undef(size) ? $bs     : size;
    seed = is_undef(seed) ? $seed   : seed;

    r_vals = rands(0, 100000, 3, seed);

    sc = [
        rands(s_min[0], s_max[0], 1, r_vals[0])[0],
        rands(s_min[1], s_max[1], 1, r_vals[1])[0],
        rands(s_min[2], s_max[2], 1, r_vals[2])[0] 
    ];

    if(trim){
        intersection(){
            scale(sc)
            children(0);
            cube(size);
        }
    } else {
        scale(sc)
        children(0);
    }
}
