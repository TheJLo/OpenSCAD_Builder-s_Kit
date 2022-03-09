// ======================================
// = Brick Mod random translate         =
// = Jacob Loss                         =
// = 03/08/2022                         =
// = GNU GPLv3.0                        =
// ======================================

// Randomly scale bricks between s_min, s_max
module brick_mod_cracked(
    size,
    chance = 0.25,
    min_angle = [-45, 0, -45],
    max_angle = [45, 0, 45],
    min_size = [0.05, 0.05, 0.05],
    max_size = [0.95, 0.95, 0.95],
    min_tran = [0.05, 0.05, 0.05],
    max_tran = [0.95, 0.95, 0.95],
    seed
    ){

    // Undefined global protection
    // These only sometimes work?
    size = is_undef(size) ? $bs     : size;
    seed = is_undef(seed) ? $seed   : seed;

    r_vals = rands(0, 100000, 10, seed);

    tr =[
        size[0] * rands(min_tran[0], max_tran[0], 1, r_vals[0])[0],
        size[1] * rands(min_tran[1], max_tran[1], 1, r_vals[1])[0],
        size[2] * rands(min_tran[2], max_tran[2], 1, r_vals[2])[0] 
        ];

    rot=[
        rands(min_angle[0], max_angle[0], 1, r_vals[3])[0], 
        rands(min_angle[1], max_angle[1], 1, r_vals[4])[0], 
        rands(min_angle[2], max_angle[2], 1, r_vals[5])[0] 
        ]; 

    cut=[
        size[0] * rands(0, max_size[0], 1, r_vals[6])[0],
        size[1] * rands(0, max_size[1], 1, r_vals[7])[0],
        size[2] * rands(0, max_size[2], 1, r_vals[8])[0]
        ];

    en = rands(0, 1, 1, r_vals[9])[0];
    if(en <= chance){

        difference(){

            children(0);
            translate(tr)
            rotate(rot)
            cube(cut);
    
        }
    }else{
        children(0);
    }
}
