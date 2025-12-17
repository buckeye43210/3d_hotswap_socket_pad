// Kailh Hot-Swap Socket Grid Plate – Parametric Multi-Socket Holder
// Inspired by similar design by makerworld.com/en/@Pokzy
// This work falls under the Creative Commons Zero v1.0 Universal License
// Attribution—Noncommercial—Share Alike
// ✖ | Sharing without ATTRIBUTION
// ✔ | Remix Culture allowed
// ✖ | Commercial Use
// ✖ | Free Cultural Works
// ✖ | Meets Open Definition

// Combines modular single socket design with grid layout for switch testers/samplers
// Fully parametric – perfect for Thingiverse Customizer
// Ideal for mechanical keyboard switch testing, keypads, etc.

// === Grid Parameters ===
cols = 2;                    // Number of columns
rows = 6;                    // Number of rows
key_spacing = 19.05;         // Standard MX center-to-center spacing

// === Single Socket Parameters ===
base_x = 19.05;              // Matches key_spacing – each socket has its own 19.05mm base
base_y = 19.05;
base_z = 1.45;               // Base thickness
base_sink = 0.125;           // Slight sink for flush look

extra_clearance = 0.1;       // Adjust for perfect socket fit (0.1–0.3 common)

x_offset = 2.5;
y_offset = 3.0;
z_offset = 0.1;

$fn = 60;

hole1 = [2.265,   -4.09, -0.5, 1.0];   // Right small
hole2 = [-2.55, -4.15, -0.5, 2.0];   // Central large
hole3 = [-7.30, -4.09, -0.5, 1.0];   // Left small
hole4 = [-5.15,  1.00, -0.45, .6];  // Upper post
hole5 = [1.3,   -1.6,  -0.45, .5];  // Side hole

// Holder body
holder_width    = 14.35;
holder_depth    = 3.8;
holder_height   = 3.75;
holder_x_offset = -7.85;
holder_y_offset = 0.1;

total_cut_h = 7.0;           // Safe overcut depth

// === Plate Appearance ===
plate_thickness = 1.45;      // Overall plate thickness (matches base_z)
corner_radius = 4.0;         // Rounded corners on the full plate
border_width = 8.0;          // Extra border around the grid

add_mounting_holes = true;   // Set to false to remove screw/standoff holes
mount_hole_diam = 3.6;       // Countersink top diameter
mount_shaft_diam = 2.2;      // Shaft diameter (for M2 screws)

// === Modules (Single Socket) ===

module cut_cylinder(pos, r, h = total_cut_h, center = true) {
    translate(pos) cylinder(h = h, r = r + extra_clearance, center = center);
}

module hull_cut_cyl(p1, p2, r, h = total_cut_h) {
    hull() {
        translate(p1) cylinder(h = h, r = r + extra_clearance, center = true);
        translate(p2) cylinder(h = h, r = r + extra_clearance, center = true);
    }
}

module single_base_plate() {
    difference() {
        translate([0, 0, -(base_z + base_sink)])
            cube([base_x, base_y, base_z], center = true);

        for (h = [hole1, hole2, hole3, hole4, hole5])
            cut_cylinder([h[0], h[1], h[2]], h[3]);

        // Finger relief cuts
        translate([0,  base_y/2, -0.9]) rotate([0, 90, 0]) cylinder(h = base_x/2, r = 0.5, center = true);
        translate([0, -base_y/2, -0.9]) rotate([0, 90, 0]) cylinder(h = base_x/2, r = 0.5, center = true);

        // Edge relief notches (cleaned up from original)
        translate([ base_x/2 - 4.25,  base_y/2 - 0.75, -(base_z/2 + 0.35)]) cube([9.0, 1.5, 0.75], center = true);
        translate([ base_x/2 - 0.75,  base_y/2 - 1.75, -(base_z/2 + 0.36)]) cube([1.75, 4.0, 0.75], center = true);
        translate([-(base_x/2 - 0.75), base_y/2 - 1.75, -(base_z/2 + 0.36)]) cube([1.75, 4.0, 0.75], center = true);
        translate([-(base_x/2 - 2.65), base_y/2 - 0.75, -(base_z/2 + 0.35)]) cube([5.5, 1.6, 0.75], center = true);
        translate([-(base_x/2 - 2.65), -(base_y/2 - 0.75), -(base_z/2 + 0.35)]) cube([5.5, 1.6, 0.75], center = true);
        translate([-(base_x/2 - 0.75), -(base_y/2 - 1.75), -(base_z/2 + 0.36)]) cube([1.75, 4.0, 0.75], center = true);
        translate([ base_x/2 - 4.25, -(base_y/2 - 0.75), -(base_z/2 + 0.35)]) cube([9.0, 1.5, 0.75], center = true);
        translate([ base_x/2 - 0.75, -(base_y/2 - 1.75), -(base_z/2 + 0.36)]) cube([1.75, 4.0, 0.75], center = true);
    }
}

module holder_bar() {
    difference() {
        translate([holder_x_offset, holder_y_offset, -base_z])
            cube([holder_width, holder_depth, holder_height], center = false);

        translate([-1.5, 0, 1.85]) cube([13.5, 8.0, 1.0], center = true);

        hull() {
            translate([4.62, 2.0, 1.57]) rotate([90, 0, 0]) cylinder(h = 4.0, d = 1.64 + 2*extra_clearance, center = true);
            translate([4.62, 2.0, 2.57]) rotate([90, 0, 0]) cylinder(h = 4.0, d = 1.64 + 2*extra_clearance, center = true);
        }

        hull_cut_cyl([1.14, 0.2, 0], [-10, 0.2, 0], 2.7, holder_height);
        hull_cut_cyl([-2.5, -4.05, -0.5], [-10, -4.05, -0.5], 2.1, 5.0);
        cut_cylinder([-2.5, -4.05, -0.5], 2.1, h = 5.0);
    }
}

module side_support() {
    difference() {
        union() {
            translate([0.6, -4.0, 0]) cube([2.4, 2.0, 2.75], center = true);
            intersection() {
                translate([-8.7, -3.75, -base_z]) cube([10.5, 2.6, 2.825], center = false);
                hull() {
                    translate([-2.3, -4.05, -0.5]) cylinder(h = 5.0, r = 2.85, center = true);
                    translate([-8.0, -4.05, -0.5]) cylinder(h = 5.0, r = 2.85, center = true);
                }
            }
        }

        cut_cylinder([2.265,   -4.09, -0.5], 1.0);
        cut_cylinder([-2.55, -4.15, -0.5], 2.0, h = 5.0);
        cut_cylinder([-7.35, -4.09, -base_z], 1.0, h = 3.0);

        translate([-4.75, -3.0, -2.25]) rotate([90, 90, 0])
            hull() {
                translate([-2.3, -4.05, -0.5]) cylinder(h = 3.0, r = 1.0, center = true);
                translate([-10.0, -4.05, -0.5]) cylinder(h = 3.0, r = 1.0, center = true);
            }

        translate([-2, 2, 1.85]) cube([12, 4.0, 0.95], center = true);

        hull() {
            for (y = [-3.55, -4.7]) for (z = [0, 2])
                translate([-2.5, y, z]) sphere(r = 1.5);
            for (y = [-3.55, -4.7]) for (z = [0, 2])
                translate([-10, y, z]) sphere(r = 1.5);
        }

        hull() {
            translate([1, -4.7, 0.1])   rotate([0, 90, 0]) cylinder(h = 4.0, r = 1.0, center = true);
            translate([1, -4.7, base_z]) rotate([0, 90, 0]) cylinder(h = 4.0, r = 1.0, center = true);
        }
      
    }
}

module chamfer() {
    // Chamfer top of support bar
    translate([-2.55, -4.15, 2.95]) sphere(r = 3.14);
}

module single_socket() {
  difference() {
    union() {
      single_base_plate();
      holder_bar();
      side_support();
    }
    chamfer();
  }
}

// === Full Grid Assembly ===
module mounting_hole() {
    translate([0, 0, -plate_thickness]) cylinder(h = plate_thickness + 1.0, d = mount_shaft_diam, center = true);
    translate([0, 0, plate_thickness/2 - 1.0])
        cylinder(h = 2.2, d = mount_hole_diam, center = true);
}

difference() {
    union() {
        // Hollow backing plate with rounded corners
        difference() {
          translate([0, 0, -1.6 * plate_thickness])
            linear_extrude(height = plate_thickness)
                hull() {
                    for (x = [-1, 1]) for (y = [-1, 1])
                        translate([x * (cols*key_spacing/2 - corner_radius + border_width/2),
                                  y * (rows*key_spacing/2 - corner_radius + border_width/2)])
                            circle(r = corner_radius);
                }
          //  Backing plate blank interior
          #translate([0, 0, -1.7 * plate_thickness])
            linear_extrude(height = 1.5 * plate_thickness)
               square([cols * key_spacing - (border_width/4 + x_offset), rows * key_spacing - (border_width/4 + y_offset)], center = true); 
        }

        // Grid of sockets
        for (i = [-(rows-1)/2 : (rows-1)/2])
            for (j = [-(cols-1)/2 : (cols-1)/2])
                translate([j * key_spacing + x_offset, i * key_spacing + y_offset, z_offset])
                    single_socket();
    }

    // Optional mounting holes at corners and mid-sides
    if (add_mounting_holes) {
        positions = [
            [ cols/2 * key_spacing,  rows/2 * key_spacing],
            [-cols/2 * key_spacing,  rows/2 * key_spacing],
            [ cols/2 * key_spacing, -rows/2 * key_spacing],
            [-cols/2 * key_spacing, -rows/2 * key_spacing],
            [ cols/2 * key_spacing,  0],
            [-cols/2 * key_spacing,  0]
        ];
        for (p = positions)
            translate([p[0], p[1], 0]) mounting_hole();
    }
}

// %translate([0, 0, 0.1]) import("./imported_key_plate.stl");
