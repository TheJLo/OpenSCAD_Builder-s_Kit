// ==============================================
// = Random Rotation Brick Modifier             =
// = Jacob Loss                                 =
// = 02/27/2022                                 =
// = GNU GPLv3.0                                =
// ==============================================

// Randomly rotate brick by r_max degrees
module brick_mod_r_rot(
    size,
    r_max = [5, 5, 5],
    trim = false,
    seed
    ){

    // Undefined global protection
    // These only sometimes work?
    size = is_undef(size) ? $bs     : size;
    seed = is_undef(seed) ? $seed   : seed;

    r_vals = rands(0, 100000, 3, seed);

    rot = [
        rands(-r_max[0], r_max[0], 1, r_vals[0])[0],
        rands(-r_max[1], r_max[1], 1, r_vals[1])[0],
        rands(-r_max[2], r_max[2], 1, r_vals[2])[0] 
    ];

    if(trim){
        intersection(){
            rotate(rot)
            children(0);
            cube(size);
        }
    } else {
        rotate(rot)
        children(0);
    }
}
