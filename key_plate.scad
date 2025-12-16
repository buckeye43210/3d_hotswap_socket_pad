// This work falls under the Creative Commons Zero v1.0 Universal License
// Attribution—Noncommercial—Share Alike
// ✖ | Sharing without ATTRIBUTION
// ✔ | Remix Culture allowed
// ✖ | Commercial Use
// ✖ | Free Cultural Works
// ✖ | Meets Open Definition

$fn = 60;

// Standard Cherry MX parameters
cutout_size = 13.9;         // Range (13.8 - 14.0) lower range for tighter fit
key_spacing = 19.05;        // Standard center-to-center
thickness = 3.0;            // Plate thickness
border =  key_spacing/2;    // Extra border around plate 
extension = 0.0;            // Microcontroller area
hole_diameter = 2.0;        // Standoff hole diameter
corner_radius = 3.5;        // Corner radius

// Grid: 2 columns × 6 rows (adjust as needed)
cols = 2;
rows = 6;

// Overall plate size (with some border padding)
plate_width = cols * key_spacing + border;  // +5mm border each side
plate_length = (rows +  0.5)  * key_spacing + extension;

module base_plate(pw = plate_width, pl = plate_length, t1 = thickness, r1 = corner_radius) {
  linear_extrude(height = thickness, center = true) {
    // Base plate
    translate([0,extension / 3,0]) {
      hull() {
        translate([pw/2 - r1, pl/2 - r1]) circle(r1);
        translate([pw/2 - r1, -(pl/2 - r1)]) circle(r1);
        translate([-(pw/2 - r1), pl/2 - r1]) circle(r1);
        translate([-(pw/2 - r1), -(pl/2 - r1)]) circle(r1);
      }
    }
  }
}

module screw_hole(d1 = 3.6, d2 = 2.0, h1 = 1.25, h2 = 3.0) {
  union() {
    translate([0, 0, h2/2 - h1/2]) cylinder(h = h1 + 0.05, d = d1, center = true);
    cylinder(h = h2 + 0.05, d = d2, center = true);
  }
}

difference() {
  base_plate();

  // Grid of switch cutouts
  linear_extrude(height = thickness + 0.1, center = true) {
    for (i = [-(rows-1)/2 : (rows-1)/2]) {
      for (j = [-(cols-1)/2 : (cols-1)/2]) {
        translate([j * key_spacing, i * key_spacing, 0]) {
          square(cutout_size, center = true);
        }
      }
    }
  }

  translate([0, 0, thickness/2 - 0.5]) {
    linear_extrude(height = thickness/2, center = true) {
      for (i = [-(rows-1)/2 : (rows-1)/2]) {
        for (j = [-(cols-1)/2 : (cols-1)/2]) {
          translate([j * key_spacing, i * key_spacing]) {
            square(cutout_size + 2.0, center = true);
          }
        }
      }
    }
  }

  
  // Standoff holes
  translate([cols/2 * key_spacing, 0, 0]) screw_hole();
  translate([-cols/2 * key_spacing, 0, 0]) screw_hole();
  translate([cols/2 * key_spacing, rows/2 * key_spacing]) screw_hole();
  translate([-cols/2 * key_spacing, rows/2 * key_spacing]) screw_hole();
  translate([cols/2 * key_spacing, -rows/2 * key_spacing]) screw_hole();
  translate([-cols/2 * key_spacing, -rows/2 * key_spacing]) screw_hole();
}
