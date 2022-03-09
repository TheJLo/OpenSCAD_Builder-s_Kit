// ======================================
// = OSBK Test Example (The Castle)     =
// = Jacob Loss                         =
// = 02/12/2022                         =
// = GNU GPLv3.0                        =
// ======================================

// This castle is an example of what can be done with the OpenSCAD Builder's Kit
// The Castle is free for anyone to use and is licensed under the same license as most of OSBK (GNU GPLv3.0)

// Get the library
include <OSBK.scad>
include <MCAD/units.scad>

// Debug mode
$d = false;

// Values
b_size_pillar   = [1/5 * inch, 1/5 * inch, 1/5 * inch];
b_size_wall     = [1/10 * inch, 1/5 * inch, 1/10 * inch];
wall_gap        = 0.05;

// Component Modules
// Brick Types
module pillar_brick(){

    brick_mod_r_rot(r_max = [1, 1, 1], trim=false)
    brick_mod_r_scale()
    brick_generic(rand = false);

}

module castle_brick(){

    brick_mod_r_rot(r_max = [2, 2, 2], trim=false)
    brick_mod_r_scale(s_max = [1.1, 1.1, 1.1])
    brick_generic(rand = false);

}

module walk_brick(){

    brick_mod_r_rot(r_max = [1, 1, 1], trim=false)
    brick_mod_r_scale(s_max = [1.0, 1.0, 1.05])
    brick_generic(rand = false);

}

// Structures
// Front-pillars (arches in future?)
module front_pillars(seed = 1234){

    union(){
        build_pillar(
            height  = 1 * inch,
            b_size  = b_size_pillar,
            b_sides = [1, 1, 1, 1, 1, 0],
            v_gap   = 0.0,
            v_off   = 0,
            seed    = seed
        )    
        pillar_brick();
        
        translate([0, 3/4 * inch + b_size_pillar[1], 0])
        build_pillar(
            height  = 1 * inch,
            b_size  = b_size_pillar,
            b_sides = [1, 1, 1, 1, 1, 0],
            v_gap   = 0,
            v_off   = 0,
            seed    = seed + 12
        )    
        pillar_brick();

    }
}
//front_pillars();

// Front wall (with gate)
module front_wall(seed = 15846){

    union(){
        // Front Facade 1
        build_wall(
        length      = 1 * inch,
        height      = 3/4 * inch,         
        b_size      = b_size_wall, 
        b_sides     = [1, 0, 0, 0, 0, 0],
        depth       = 0.15,
        v_gap       = wall_gap,
        v_off       = 0.5,
        h_gap       = wall_gap,
        h_off       = 0,
        off_n       = 2,
        seed        = seed + 0
        )
        castle_brick(); 
        
        // Front Facade 2
        translate([0, (1 + 3/4) * inch, 0])
        build_wall(
        length      = 1 * inch,
        height      = 3/4 * inch,         
        b_size      = b_size_wall, 
        b_sides     = [1, 0, 0, 0, 0, 0],
        depth       = 0.15,
        v_gap       = wall_gap,
        v_off       = 0.5,
        h_gap       = wall_gap,
        h_off       = 0,
        off_n       = 2,
        seed        = seed + 1
        )
        castle_brick(); 
        
        // Front Gate Top
        translate([0, 0, 3/4 * inch])
        build_wall(
            length      = (2 + 3/4) * inch,
            height      = 3/4 * inch,         
            b_size      = b_size_wall, 
            b_sides     = [1, 0, 0, 0, 1, 1],
            depth       = 0.15,
            v_gap       = wall_gap,
            v_off       = 1.5,
            h_gap       = wall_gap,
            h_off       = 0.5,
            off_n       = 2,
            seed        = seed + 2
        )
        castle_brick(); 
    
        // Gate inside
        translate([-b_size_pillar[0], 3/4 * inch, 0])
        build_pillar(
            height      = 1 * inch,
            b_size      = b_size_pillar,
            b_sides     = [0, 0, 1, 0, 0, 0],
            depth       = 0.15,
            v_off       = 0,
            v_gap       = 0,
            seed        = seed + 3
        )
        walk_brick();
        
        translate([-b_size_pillar[0], 2 * inch - b_size_pillar[1], 0])
        build_pillar(
            height      = 1 * inch,
            b_size      = b_size_pillar,
            b_sides     = [0, 0, 0, 1, 0, 0],
            depth       = 0.15,
            v_off       = 0,
            v_gap       = 0,
            seed        = seed + 4
        )
        walk_brick();
        
        translate([-b_size_pillar[0], (3/4) * inch, (1) * inch - b_size_pillar[2]])
        build_wall(
            length      = 3/4 * inch + 2.5 * b_size_pillar[1],
            height      = b_size_pillar[2],         
            b_size      = b_size_pillar, 
            b_sides     = [0, 0, 0, 0, 0, 1],
            depth       = 0.15,
            v_gap       = 0.0,
            v_off       = 0,
            h_gap       = 0,
            h_off       = 0,
            off_n       = 2,
            seed        = seed + 5
        )
        walk_brick(); 

        // Walkway
        translate([-b_size_pillar[0], 0, 1.15 * inch])
        build_wall(
            length      = (2 + 3/4) * inch,
            height      = b_size_pillar[2],         
            b_size      = b_size_pillar, 
            b_sides     = [0, 0, 0, 0, 1, 0],
            depth       = 0.15,
            v_gap       = 0,
            v_off       = 0,
            h_gap       = 0,
            h_off       = 0,
            off_n       = 2,
            seed        = seed + 6
        )
        walk_brick();  

        // Interior
        translate([-b_size_pillar[0], 0, 0])
        cube([b_size_pillar[1], 1 * inch - 0.5 * b_size_pillar[1], 1.15 * inch]);
        
        translate([0, (2 + 3/4) * inch, 0])
        rotate([0, 0, 180])
        cube([b_size_pillar[1], 1 * inch - 0.5 * b_size_pillar[1], 1.15 * inch]);

        translate([-b_size_pillar[0], 1 * inch - 0.5 * b_size_pillar[1], 1 * inch])
        cube([b_size_pillar[1], 1 * inch, b_size_pillar[2]]);
       
        // Back Facade 1
        translate([-(b_size_pillar[0] + b_size_wall[0]), 0, 0])
        build_wall(
        length      = 1 * inch,
        height      = 3/4 * inch,         
        b_size      = b_size_wall, 
        b_sides     = [0, 1, 0, 0, 0, 0],
        depth       = 0.15,
        v_gap       = wall_gap,
        v_off       = 0.5,
        h_gap       = wall_gap,
        h_off       = 0,
        off_n       = 2,
        seed        = seed + 7
        )
        castle_brick(); 
        
        // Front Facade 2
        translate([-(b_size_pillar[0] + b_size_wall[0]), (1 + 3/4) * inch, 0])
        build_wall(
        length      = 1 * inch,
        height      = 3/4 * inch,         
        b_size      = b_size_wall, 
        b_sides     = [0, 1, 0, 0, 0, 0],
        depth       = 0.15,
        v_gap       = wall_gap,
        v_off       = 0.5,
        h_gap       = wall_gap,
        h_off       = 0,
        off_n       = 2,
        seed        = seed + 8
        )
        castle_brick(); 
        
        // Front Gate Top
        translate([-(b_size_pillar[0] + b_size_wall[0]), 0, 3/4 * inch])
        build_wall(
            length      = (2 + 3/4) * inch,
            height      = 3/4 * inch,         
            b_size      = b_size_wall, 
            b_sides     = [0, 1, 0, 0, 1, 1],
            depth       = 0.15,
            v_gap       = wall_gap,
            v_off       = 1.5,
            h_gap       = wall_gap,
            h_off       = 0.5,
            off_n       = 2,
            seed        = seed + 9
        )
        castle_brick(); 
    }
}
//front_wall();

module tower(seed = 149787){
        
        translate([3/4 * inch, 0, 0])
        union(){ 
            build_wall(
                length      = 3/4 * inch,
                height      = 2 * inch,         
                b_size      = b_size_wall, 
                b_sides     = [1, 0, 0, 0, 1, 0],
                depth       = 0.15,
                v_gap       = wall_gap,
                v_off       = 0,
                h_gap       = wall_gap,
                h_off       = 0.5,
                off_n       = 2,
                seed        = seed + 0
            )
            castle_brick(); 
           
            translate([0, 3/4 * inch, 0]) 
            rotate([0, 0, 90])
            build_wall(
                length      = 3/4 * inch,
                height      = 2 * inch,         
                b_size      = b_size_wall, 
                b_sides     = [1, 0, 0, 0, 1, 0],
                depth       = 0.15,
                v_gap       = wall_gap,
                v_off       = 0,
                h_gap       = wall_gap,
                h_off       = 0.5,
                off_n       = 2,
                seed        = seed + 1
            )
            castle_brick(); 
            
            translate([-3/4 * inch, 3/4 * inch, 0]) 
            rotate([0, 0, 180])
            build_wall(
                length      = 3/4 * inch,
                height      = 2 * inch,         
                b_size      = b_size_wall, 
                b_sides     = [1, 0, 0, 0, 1, 0],
                depth       = 0.15,
                v_gap       = wall_gap,
                v_off       = 0,
                h_gap       = wall_gap,
                h_off       = 0.5,
                off_n       = 2,
                seed        = seed + 2
            )
            castle_brick(); 
            
            translate([-3/4 * inch, 0, 0]) 
            rotate([0, 0, 270])
            build_wall(
                length      = 3/4 * inch,
                height      = 2 * inch,         
                b_size      = b_size_wall, 
                b_sides     = [1, 0, 0, 0, 1, 0],
                depth       = 0.15,
                v_gap       = wall_gap,
                v_off       = 0,
                h_gap       = wall_gap,
                h_off       = 0.5,
                off_n       = 2,
                seed        = seed + 3
            )
            castle_brick(); 

            rotate([0, 0, 270])
            build_pillar(
                height      = 2 * inch,
                b_size      = [b_size_wall[0] * 1.075, b_size_wall[1] * 0.575, b_size_wall[2]],
                b_sides     = [1, 0, 1, 0, 1, 0],
                depth       = 0.15,
                v_off       = 0,
                v_gap       = wall_gap,
                seed        = seed + 4
            )
        
            walk_brick();
            
            translate([0, 3/4 * inch, 0])
            build_pillar(
                height      = 2 * inch,
                b_size      = [b_size_wall[0] * 1.075, b_size_wall[1] * 0.575, b_size_wall[2]],
                b_sides     = [1, 0, 1, 0, 1, 0],
                depth       = 0.15,
                v_off       = 0,
                v_gap       = wall_gap,
                seed        = seed + 5
            )
            walk_brick();
           
            translate([-3/4 * inch - b_size_wall[0] * 1.05, 3/4 * inch, 0])
            build_pillar(
                height      = 2 * inch,
                b_size      = [b_size_wall[0] * 1.075, b_size_wall[1] * 0.575, b_size_wall[2]],
                b_sides     = [0, 1, 1, 0, 1, 0],
                depth       = 0.15,
                v_off       = 0,
                v_gap       = wall_gap,
                seed        = seed + 6
            )
            walk_brick();
            
            translate([-3/4 * inch - b_size_wall[0] * 1.05, 0, 0])
            rotate([0, 0, 270])
            build_pillar(
                height      = 2 * inch,
                b_size      = [b_size_wall[0] * 1.075, b_size_wall[1] * 0.575, b_size_wall[2]],
                b_sides     = [1, 0, 0, 1, 1, 0],
                depth       = 0.15,
                v_off       = 0,
                v_gap       = wall_gap,
                seed        = seed + 7
            )
            walk_brick();
           
            // interior
            translate([-3/4 * inch, 0, 0])
            cube([3/4 * inch, 3/4 * inch, 2 * inch - b_size_pillar[0]]); 
     
            // top
            translate([0, 0, 2 * inch - 1.25 * b_size_pillar[0]])
            rotate([0, -90, 0])
            build_wall(
                length      = (3/4) * inch,
                height      = (3/4) * inch,         
                b_size      = b_size_pillar, 
                b_sides     = [1, 0, 0, 0, 0, 0],
                depth       = 0.15,
                v_gap       = 0,
                v_off       = 0,
                h_gap       = 0,
                h_off       = 0,
                off_n       = 2,
                seed        = seed + 8
            )
            walk_brick();  
    } 
}
//tower();

module wall(seed = 77991252984){
    union(){
        // Front Facade
        build_wall(
        length      = (2 + 3/4) * inch,
        height      = 1.5 * inch,         
        b_size      = b_size_wall, 
        b_sides     = [1, 0, 0, 0, 0, 0],
        depth       = 0.15,
        v_gap       = wall_gap,
        v_off       = 0.5,
        h_gap       = wall_gap,
        h_off       = 0,
        off_n       = 2,
        seed        = seed + 0
        )
        castle_brick(); 
       
        // Back Facade
        translate([-b_size_pillar[0], (2 + 3/4) * inch])
        rotate([0, 0, 180])
        build_wall(
        length      = (2 + 3/4) * inch,
        height      = 1.5 * inch,         
        b_size      = b_size_wall, 
        b_sides     = [1, 0, 0, 0, 0, 0],
        depth       = 0.15,
        v_gap       = wall_gap,
        v_off       = 0.5,
        h_gap       = wall_gap,
        h_off       = 0,
        off_n       = 2,
        seed        = seed + 1
        )
        castle_brick(); 
        
        // Walkway
        translate([-b_size_pillar[0], 0, 1.15 * inch])
        build_wall(
            length      = (2 + 3/4) * inch,
            height      = b_size_pillar[2],         
            b_size      = b_size_pillar, 
            b_sides     = [0, 0, 0, 0, 1, 0],
            depth       = 0.15,
            v_gap       = 0,
            v_off       = 0,
            h_gap       = 0,
            h_off       = 0,
            off_n       = 2,
            seed        = seed + 2
        )
        walk_brick();  
        // interior
        translate([0, (2 + 3/4) * inch, 0])
        rotate([0, 0, 180])
        cube([b_size_pillar[1], (2 + 3/4) * inch, 1.15 * inch]);
    }
}
//wall();

// Full castle assembly
module theCastle(){
    translate([0, 0, 0.4])
    union(){
        // Front wall
        translate([0, 0, 0])
        front_wall(seed = 123);

        // Front pillars
        translate([0.5 * inch, 1 * inch - b_size_pillar[1], 0])
        front_pillars(seed = 7945);
        translate([1.0 * inch, 1 * inch - b_size_pillar[1], 0])
        front_pillars(seed = 48987);
        translate([1.5 * inch, 1 * inch - b_size_pillar[1], 0])
        front_pillars(seed = 8971);

        translate([-1/4 * inch, 0, 0])
        rotate([0, 0, -90])
        tower(seed = 87894);
       
        translate([-1/4 * inch, (2 + 3/4) * inch, 0])
        rotate([0, 0, 0])
        tower(seed = 3146);

        translate([0, -0.25 * b_size_wall[1], 0])
        rotate([0, 0, 90])
        wall(seed = 87263);
 
        translate([-b_size_pillar[0], (2 + 3/4) * inch + 1.25 * b_size_pillar[1], 0])
        rotate([0, 0, 90])
        wall(seed = 98765136);
        
        translate([-(2 + 3/4) * inch, 0, 0])
        rotate([0, 0, -180])
        tower(seed = 7516587);
        
        translate([-(2 + 3/4) * inch, (2 + 3/4) * inch, 0])
        rotate([0, 0, -270])
        tower(seed = 634798);
 
        translate([-(3) * inch, (2 + 3/4) * inch - 0.25 * b_size_wall[1], 0])
        rotate([0, 0, 180])
        wall(seed = 735641);

        // Base Plate
    }

    union(){
        translate([-3.75 * inch, -1 * inch, 0])
        cube([4.5 * inch, 4.75 * inch, 0.4]);

        translate([0, 1 * inch - b_size_pillar[1] - 0.15 * inch, 0])
        cube([1.8 * inch, 1.5 * inch, 0.4]);

    }

}
theCastle();
