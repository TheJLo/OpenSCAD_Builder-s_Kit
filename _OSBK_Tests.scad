// ======================================
// = OSBK Test Examples                 =
// = Jacob Loss                         =
// = 02/27/2022                         =
// = GNU GPLv3.0                        =
// ======================================

// This is a collection of tests for the Library and some of the other features. 

// Get the library
include <OSBK.scad>
include <MCAD/units.scad>

// Debug mode
$d = false;
$fn = 25;

// Default brick
module brick_mod1(){

    
    brick_mod_r_rot(r_max = [2, 2, 2], trim=false)
    brick_mod_r_scale(s_min = [0.9, 0.9, 0.9], s_max = [1.025, 1.025, 1.025])
    brick_generic(rand = false);

}


build_wall(
    length      = 10,        
    height      = 5,         
    b_size      = [1, 2, 1],          
    b_sides     = [1, 1, 1, 1, 1, 0], 
    depth       = 0.15,               
    v_gap       = 0.05,           
    v_off       = 0.0,           
    h_gap       = 0.05,           
    h_off       = 0,
    int_block   = true,
    seed        = 125468
)
brick_mod1();
