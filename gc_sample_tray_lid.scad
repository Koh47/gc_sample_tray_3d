// ===================== PLATE =====================
plate_len   = 215;   // X direction (length)
plate_wid   = 112;   // Y direction (width)
plate_thick = 4;

// ===================== NOTCH SETTINGS =====================
notch_edge_offset = 22;   // 2.2 cm from end
notch_width       = 8;    // 0.8 cm
notch_gap         = 18;   // 1.8 cm gap
notch_depth       = 3;
notch_step = notch_width + notch_gap;

// ===================== CYLINDER SETTINGS =====================
outer_d      = 20;   // 2 cm outer diameter
inner_d      = 16;   // 1.1 cm hollow inside cylinder
base_hole_d  = 6.5;  // 0.65 cm hole through base
cyl_h        = 11;   // 1.1 cm height

nx = 8;   // along length
ny = 4;   // along width

// Edge clearances (least distance from cylinder OUTSIDE to edge)
clear_x = 3;   // 0.3 cm from length edge
clear_y = 4;   // 0.4 cm from width edge

// Spacing (edge-to-edge gap)
gap_x = 7;   // 0.7 cm along length
gap_y = 8;   // 0.8 cm along width

// Derived spacing
pitch_x = outer_d + gap_x;
pitch_y = outer_d + gap_y;

x_start = clear_x + outer_d/2;
y_start = clear_y + outer_d/2;


// ===================== MODEL =====================
union() {

    // -------- BASE WITH NOTCHES + THROUGH HOLES --------
    difference() {

        // Base plate
        cube([plate_len, plate_wid, plate_thick]);

        // --- Side Notches (front edge Y=0)
        for (x = [notch_edge_offset : notch_step :
                  plate_len - notch_edge_offset - notch_width]) {
            translate([x, 0, 0])
                cube([notch_width, notch_depth, plate_thick]);
        }

        // --- Side Notches (back edge)
        for (x = [notch_edge_offset : notch_step :
                  plate_len - notch_edge_offset - notch_width]) {
            translate([x, plate_wid - notch_depth, 0])
                cube([notch_width, notch_depth, plate_thick]);
        }

        // --- Ø6.5mm HOLES THROUGH BASE (aligned to cylinders)
        for (j = [0 : ny-1]) {
            for (i = [0 : nx-1]) {

                x = x_start + i * pitch_x;
                y = y_start + j * pitch_y;

                translate([x, y, -1])
                    cylinder(d = base_hole_d,
                             h = plate_thick + 2,
                             $fn = 80);
            }
        }
    }


    // -------- HOLLOW CYLINDERS ON TOP --------
    for (j = [0 : ny-1]) {
        for (i = [0 : nx-1]) {

            x = x_start + i * pitch_x;
            y = y_start + j * pitch_y;

            translate([x, y, plate_thick])
            difference() {
                // Outer cylinder
                cylinder(d = outer_d, h = cyl_h, $fn=100);

                // Hollow interior (empty space)
                cylinder(d = inner_d, h = cyl_h + 1, $fn=100);
            }
        }
    }
}
