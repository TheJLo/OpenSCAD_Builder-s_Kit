// ==============================================
// = OSBK Brick test                            =
// = Jacob Loss                                 =
// = 02/12/2022                                 =
// = GNU GPLv3.0                                =
// ==============================================

// Test all bricks

use <OSBK_bricks.scad>

translate([0, 0, 0])
_OSBK_test_brick_generic();

translate([2, 0, 0])
_OSBK_test_brick_inter();

translate([4, 0, 0])
_OSBK_test_brick_set();
