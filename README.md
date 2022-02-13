# OpenSCAD_Builder-s_Kit
=== OpenSCAD Builder's Kit

The OpenSCAD Builder's Kit is an open-source, public license openSCAD library for creating buildings (and other structures). The current version (v1.0) includes procedural brick walls and pillars but can be extended endlessly. General usage can be seen withing _OSBK_test.scad. I (TheJLo) will be using this library to create a building structure for a bonsai project that I am working on in the near future. 

== License
Everything, unless otherwise noted, is released under GNU GPLv3.0. Refer to License file for details. Note that portions of this code are released under other open-souce license. Refer to the top of the source file for the license and accreditation for each file. If you believe that your code is being used outside the context of applicable license, please contact TheJLo on github.com.

== Usage
Look at OSBK_test for an example of usage.

Inset 'use <OSBK.scad>' to use OBSK.

== Bricks
Bricks are scaleable (in all directions) units components that can be anything withint the b_size area. Refer to bricks/brick_generic.scad for an example. Bricks can be anything as long as they are not centered (like a default cube) and are within the bounds of b_size of whatever calls them.

Current Brick Types:
brick_generic() = Generic Brick that simply scales with the random value given
brick_inter()   = Intersecting brick which is a collection of intersecting cubes
                    max_a   = maximum angle for intersecting cubes
                    n       = number of cubes to intersect
bric_set()      = Using a set of STLs, generate bricks from that geometry
                    set     = list of sizes and paths to brick geometry STLs

There are two modules to build with bricks about:

module build_pillar(                    // Build a pillar that is 1 block thick and 1 block long
    height,                             // Height of pillar 
                                        //  : double (0, inf]
    b_size,                             // Size of bricks
                                        //  : double vector3, (0, inf], [x, y, z]
    b_sides,                            // Bricked Sides, note that if trim is on cut sides will not show brick.
                                        //  : Vector6, boolean [0, 1], [x+, x-, y+, y-, z+, z-]
    depth,                              // Depth factor of internal cube. Closer to 0.5 -> small cube, closer to 0 -> larger cube. At 0.5, there will be no cube
                                        //  : double (0, 0.5]
    v_gap,                              // Vertical gap factor, makes a gap of v_gap * b_size.z between bricks
                                        //  : double [0, inf]
    v_off,                              // Vertical offset factor, changes the vertical offset of the bricks such that they are vertical displaced
                                        //  : double [0, height / b_size[2]]
    seed                                // Seed used for random generation. Save see to get the same bricks
                                        //  : double [-inf, inf]
    )

module build_wall(                      // Build a wall that is 1 block thick
        length                          // Wall Length
                                        //  : double (0, inf]
        height                          // Wall Height
                                        //  : double (0, inf]
        b_size                          // Brick size
                                        //  : double vector3 (0, inf], [x, y, z]
        b_sides                         // Sides with bricks
                                        //  : int vector6 [0, 1], [x+, x-, y+, y-, z+, z-]
        depth                           // Depth of wall
                                        //  : double (0.5, 1]
        v_gap                           // Vertical Gap
                                        //  : double [0, height / b_size[2]]
        v_off                           // Vertical Offset
                                        //  : double [0, v_gap]
        h_gap                           // Horizontal Gap
                                        //  : double [0, lengh / b_size[1]]
        h_off                           // Horizontal Offset
                                        //  : double [0, h_gap]
        off_n                           // Offset layer count (ONLY 1 OR 2)
                                        //  : integer [1, 2]
        seed                            // Random seed
                                        //  : double (-inf, inf)
    )

