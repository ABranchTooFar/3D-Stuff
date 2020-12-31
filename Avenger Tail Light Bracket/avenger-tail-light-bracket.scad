$fn = 30;
$thickness = 4;
$screw_hole_radius = 3.5;
$tab_length = 69;
$back_depth = 37;
$back_width = 145;
$back_hang = 26;

$calc_height = 2*($screw_hole_radius+$thickness);
$calc_tab_length = $tab_length-$thickness;

module tab() {
    difference() {
        union() {
            cylinder(h=$thickness, r=$screw_hole_radius+$thickness+2);
            translate([-($calc_height/2)-2,0,0]) {
                cube([$calc_height, $calc_tab_length, $thickness]);
                difference() {
                    cube([$back_hang+$calc_height+2, $calc_tab_length, $thickness]);
                    translate([0,-19,-0.5]) {
                        rotate(-45,[0,0,1]) {
                            cube([$back_hang+$calc_height, $calc_tab_length, $thickness+1]);
                        }
                    }
                }
            }
        }
        translate([0,0,-($thickness/2)]) {
            cylinder(h=2*$thickness, r=$screw_hole_radius);
        }
    }
    
    translate([0,60.6,0]) {
        rotate(45,[0,0,1]) {
            cube([3,9,$thickness]);
        }
    }
}

tab();

translate([0,$back_width+(2*$tab_length),0]) {
    scale([1, -1, 1]) {
        tab();
    }
}

module bracket_back() {
    translate([-($calc_height/2)+$back_hang,$calc_tab_length,0]) {
        cube([$calc_height,$thickness,$back_depth]);
    
        translate([0,0,$back_depth]) {
            cube([$calc_height,$back_width+(2*$thickness),$thickness]);
        }
    
        translate([0,$back_width+$thickness,0]) {
            cube([$calc_height,$thickness,$back_depth]);
        }
    }
}

bracket_back();

scale([0.18,1,1]) {
    translate([-54,0,0]) {
        bracket_back();
    }
}