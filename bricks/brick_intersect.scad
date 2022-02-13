// ==============================================
// = Intersected Bricks                         =
// = Jacob Loss                                 =
// = 02/12/2022                                 =
// = CC BY-SA 3.0                               =
// = Remixed from:                              =
// = https://www.thingiverse.com/thing:219574   = 
// ==============================================

// Get generic brick (mostly for the test suite)
use <brick_generic.scad>

// Intersection Bricks
module brick_inter(
    size,
    seed,
    max_a   = 10,
    n       = 3,
    ){

    // Undefined global protection
    size = is_undef(size) ? $bs     : size;
    seed = is_undef(seed) ? $seed   : seed;
    
    z = rands(-1, 1, n * 3, seed);

    if($d){
        cube(size);
    } else {
        intersection(){
            
            translate(size / 2)
            intersection_for(i = [0:n-1]){
               
                //echo("i =", i);
                // echo("z =", z);
                //echo("max_a =", max_a);
                
                rotate([
                        max_a * z[3 * i + 0],
                        max_a * z[3 * i + 1],
                        max_a * z[3 * i + 2],
                       ])
                cube(size, center=true);

            }

            cube(size);
        }        

    }
}

module _OSBK_test_brick_inter(){

    _OSBK_test_suite()
    brick_inter();
 
}
_OSBK_test_brick_inter();
