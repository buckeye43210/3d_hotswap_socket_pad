// Creative Commons Zero v1.0 Universal (CC0) - Public Domain

$fn = 60;

// Standard Cherry MX / Kailh hotswap parameters
cutout_size   = 13.9;    // Switch cutout size (13.8-14.0, lower = tighter)
key_spacing   = 19.05;   // Center-to-center spacing
thickness     = 3.0;     // Plate thickness
border        = key_spacing / 2;  // Extra border around the grid
extension     = 0.0;     // Extra space for MCU (currently none)
corner_radius = 3.5;     // Plate corner radius

// Grid definition
cols = 2;
rows = 6;

// Calculated plate dimensions
plate_width  = cols * key_spacing + border;
plate_length = (rows + 0.5) * key_spacing + extension;

// Tab cutout parameters (for Kailh/MX hotswap sockets)
tab_width  = 4.5;
tab_depth  = 3.0;
tab_offset = cutout_size / 2;  // Distance from switch center to tab center

// ------------------------------------------------------------------
// Module: Base rounded plate with inner void for lighter weight
// ------------------------------------------------------------------
module base_plate(pw = plate_width, pl = plate_length, t = thickness, r = corner_radius) {
  linear_extrude(height = t, center = true) {
    difference() {
      // Outer rounded rectangle
      translate([0, extension / 3, 0])
        hull() {
          translate([ pw/2 - r,  pl/2 - r]) circle(r);
          translate([ pw/2 - r, -pl/2 + r]) circle(r);
          translate([-pw/2 + r,  pl/2 - r]) circle(r);
          translate([-pw/2 + r, -pl/2 + r]) circle(r);
        }
      // Inner void (optional weight reduction)
      translate([0, extension / 3, 0])
        hull() {
          translate([ pw/2 - 2*r,  pl/2 - 2*r]) circle(r/2);
          translate([ pw/2 - 2*r, -pl/2 + 2*r]) circle(r/2);
          translate([-pw/2 + 2*r,  pl/2 - 2*r]) circle(r/2);
          translate([-pw/2 + 2*r, -pl/2 + 2*r]) circle(r/2);
        }
    }
  }
}

// ------------------------------------------------------------------
// Module: Imported switch plate grid (from DXF)
// ------------------------------------------------------------------
module imported_grid() {
  linear_extrude(height = thickness, center = true) {
    translate([-19.05, 3 * 19.05, 0])
      import("/home/rholbert/repos/3d_hotswap_socket_pad/generated_plate.dxf");
  }
}

// ------------------------------------------------------------------
// Module: Countersunk screw holes for standoffs
// ------------------------------------------------------------------
module screw_hole(d1 = 3.6, d2 = 2.0, h1 = 1.25, h2 = thickness) {
  union() {
    translate([0, 0, h2/2 - h1/2])
      cylinder(h = h1 + 0.05, d = d1, center = true);
    cylinder(h = h2 + 0.05, d = d2, center = true);
  }
}

// ------------------------------------------------------------------
// NEW MODULE: Tab cutouts for Kailh hotswap sockets
// side: "top" or "bottom" — determines which side of the switch the tabs are cut
// ------------------------------------------------------------------
module switch_tab_cutouts(side = "top") {
  z_offset = thickness/4;
  
  translate([0, 0, z_offset])
    linear_extrude(height = thickness, center = true) {
      for (i = [-(rows-1)/2 : (rows-1)/2]) {
        for (j = [-(cols-1)/2 : (cols-1)/2]) {
          x = j * key_spacing;
          y = i * key_spacing;
          
          if (side == "top") {
            // Top tabs (north side of each switch)
            translate([x, y + tab_offset])
              square([tab_width, tab_depth], center = true);
          } else {
            // Bottom tabs (south side of each switch)
            rotate([0, 0, 180]) {
              translate([x, y + tab_offset]) {
                square([tab_width, tab_depth], center = true);
              }
            }
        }
      }
    }
  }
}

// ------------------------------------------------------------------
// Final assembly
// ------------------------------------------------------------------
difference() {
  union() {
    base_plate();
    imported_grid();
  }
  
  // Cut tabs on both sides
  switch_tab_cutouts("top");
  switch_tab_cutouts("bottom");
  
  // Standoff mounting holes (adjust positions as needed)
  positions = [
    [ cols/2 * key_spacing,  0],
    [-cols/2 * key_spacing,  0],
    [ cols/2 * key_spacing,  rows/2 * key_spacing],
    [-cols/2 * key_spacing,  rows/2 * key_spacing],
    [ cols/2 * key_spacing, -rows/2 * key_spacing],
    [-cols/2 * key_spacing, -rows/2 * key_spacing]
  ];
  
  for (pos = positions) {
    translate([pos[0], pos[1], 0])
      screw_hole();
  }
}