difference() {
    cube([215, 110, 4]);
    
    // Repeating notches along the front edge (Y=0)
    for (x = [21.2 : 27 : 215 - 27]) {
        translate([x, 0, 0])
            cube([8, 4, 4]);
    }
}