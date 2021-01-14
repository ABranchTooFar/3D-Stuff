$fn = 30;


// Cartridge body dimensions

$bodyOuterWidth = 120;
$bodyOuterHeight = 109;   // Could be 110?
$bodyOuterDepth = 17;


// Cartridge connection dimensions

$connShellThickness = 2.25;
$connOuterWidth = 106;
$connInnerWidth = $connOuterWidth - (2 * $connShellThickness);
//$connOuterHeight = 17;
$connInnerHeight = $bodyOuterDepth - (2 * $connShellThickness);
$connInnerDepth = 19;
$connOuterDepth = 24;


// PCB dimensions

$pcbThickness = 1.2;   // Increase this value if IC sockets make the cartridge not fit in the console
$pcbInnerWidth = 94.5;    // Slightly larger than measured for better/easier PCB fit
$pcbOuterWidth = 101.5;   // Slightly larger than measured for better/easier PCB fit


module connector() {
    difference() {
        cube([$connOuterWidth, $bodyOuterDepth, $connOuterDepth]);

        translate([$connShellThickness, 0, 0]) {
            cube([$connInnerWidth, $connInnerHeight + $connShellThickness, $connInnerDepth]);
        }
    }
}

module body() {
    difference() {
        cube([$bodyOuterWidth, $bodyOuterDepth, $bodyOuterHeight]);

        // Chamfers on the back of the cartridge
        // NOTE: The angle was guessed to be 45 degrees
        union() {
            translate([$bodyOuterWidth+12, 0, 0]) {
                rotate(45) {
                    cube([100, 100, $bodyOuterHeight]);
                }
            }
            
            translate([-12, 0, 0]) {
                rotate(45) {
                    cube([100, 100, $bodyOuterHeight]);
                }
            }
            
            // Removes the top chamfer because it doesn't have any function and
            // makes the print more difficult.
            //translate([-12, 0, 121]) {
                //rotate(-45, [1, 0, 0]) {
                    //cube([150, 100, $bodyOuterHeight]);
                //}
            //}
        }
    }
}

module cartridgeBody() {
    translate([($bodyOuterWidth - $connOuterWidth) / 2, 0, 0]) {
        connector();
    }

    translate([0, 0, $connOuterDepth]) {
        body();
    }
}

module pcbLeftTab() {
    translate([0, 0, 5]) {
        cube([5, 5, 2]);
    }
    
    cube([2, 5, 7]);
}

module pcbRightTab() {
    scale([-1, 1, 1]) {
        pcbLeftTab();
    }
}

module pcbSlot() {
    translate([($bodyOuterWidth - $pcbInnerWidth) / 2, 0, 0]) {
        cube([$pcbInnerWidth, ($bodyOuterDepth / 2) + $pcbThickness, 20]);
    }

    translate([($bodyOuterWidth - $pcbOuterWidth) / 2, 0, $connInnerDepth + 1]) {
        cube([$pcbOuterWidth, ($bodyOuterDepth / 2) + $pcbThickness, 105]);
    }
    
    translate([($bodyOuterWidth - $pcbOuterWidth) / 2, -2, $connInnerDepth - 1]) {
        cube([$pcbOuterWidth, ($bodyOuterDepth / 2) + $pcbThickness, 105]);
    }
    
    
    // PCB supports
    
    translate([(($bodyOuterWidth + 9.6) - $pcbOuterWidth) / 2, 0, $connInnerDepth + 1]) {
        cube([$pcbOuterWidth - 9.6, $bodyOuterDepth - 3, 105]);
    }
    
    translate([($bodyOuterWidth - $pcbOuterWidth) / 2, 0, $connInnerDepth + 1]) {
        cube([$pcbOuterWidth, $bodyOuterDepth - 3, 17]);
    }
    
    translate([($bodyOuterWidth - $pcbOuterWidth) / 2, 0, $connInnerDepth + 31]) {
        cube([$pcbOuterWidth, $bodyOuterDepth - 3, 75]);
    }
    
    
    // Top hand grip
    
    translate([99, -6, 125]) {
        cylinder(10, 13, 13);
    }
    
    translate([21, -6, 125]) {
        cylinder(10, 13, 13);
    }
    
    translate([21, -6, 125]) {
        cube([78, 13, 13]);
    }
    
    translate([99, 23, 125]) {
        cylinder(10, 13, 13);
    }
    
    translate([21, 23, 125]) {
        cylinder(10, 13, 13);
    }
    
    translate([21, 10, 125]) {
        cube([78, 13, 13]);
    }
    
    
    // Back cut-out
    
    $backHoleX = 11.25;
    $backHoleZ = 52;
    $backHoleWidth = $pcbOuterWidth - 4;
    $backHoleHeight = 73;
    $backHoleCornerRad = 2;
    
    
    translate([$backHoleX, 20, $backHoleZ]) {
        rotate(90, [1, 0, 0]) {
            cylinder(20, $backHoleCornerRad, $backHoleCornerRad);
        }
    }
    
    translate([$backHoleX + $backHoleWidth, 20, $backHoleZ]) {
        rotate(90, [1, 0, 0]) {
            cylinder(20, $backHoleCornerRad, $backHoleCornerRad);
        }
    }
    
    translate([$backHoleX - $backHoleCornerRad, 0, $backHoleZ]) {
        cube([$backHoleWidth + (2 * $backHoleCornerRad), 20, $backHoleHeight]);
    }
    
    translate([$backHoleX, 0, $backHoleZ - $backHoleCornerRad]) {
        cube([$backHoleWidth, 20, $backHoleHeight]);
    }
}


module cartridge() {

    difference() {
        cartridgeBody();

        pcbSlot();
    }


// Retaining bases

    translate([9, ($bodyOuterDepth / 2) + $pcbThickness - 2, 39]) {
        pcbLeftTab();
    }

    translate([111, ($bodyOuterDepth / 2) + $pcbThickness - 2, 41]) {
        pcbRightTab();
    }


    // Retaining clips

    translate([109, 5.8, 52]) {
        cube([2, 2, 5]);
    }

    translate([9, 5.8, 52]) {
        cube([2, 2, 5]);
    }
}

translate([0, 0, $bodyOuterDepth]) {
    rotate(-90, [1, 0, 0]) {
        cartridge();
    }
}