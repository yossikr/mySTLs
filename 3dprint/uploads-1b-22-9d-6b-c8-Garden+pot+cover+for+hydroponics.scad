// Custom Screen to fill a hole (c) 2013 David Smith
// licensed under the Creative Commons - GNU GPL license.
// http://www.thingiverse.com/thing:112117

/* [Hole] */

// Hole Shape 
shape= 128; // [ 3:Triangle, 4:Square, 5:Pentagon, 6:Hexagon, 8:Octagon, 16:Rough Circle, 128:Smooth Circle ]

// Diameter of a circle connecting all the points definiting your hole's shape (mm). 
diameter = 188; 

// Hole depth (mm)
depth = 6; 

// Width of the screen's frame (mm).
frame_thickness = 2;

// Size of the border (mm). Only 'flush' screens have borders. 
border_size = 1;

/* [Screen] */

// Spacing between mesh threads (mm). 
mesh_space=1.25;
//mesh_space=0.75;

// Thickness of the screen (mm). It should be a multiple of your slicer's layer height for best results.
mesh_height=2.5; 

// Screen is flush to the surface or recessed.
indention = 1; // [0:Recessed, 1:Flush]

// Nubs to make it fit tighter
nubs = 1; // [0:no nubs, 1:nubs]

/* [Center hole] */

center_hole_diameter = 30;
center_hole_depth = mesh_height;
center_hole_border = frame_thickness;

/* [Tube hole] */

tube_hole_diameter = 10;
tube_hole_depth = mesh_height;
tube_hole_border = frame_thickness-0.5;
tube_hole_distance = 80;

/* [Slicer] */

// The thickness of your slices (mm). Screen threads are a multiple of this for their height.
printer_layer_height = 0.25;  

// The shell or skin size of your slicer (mm) .
printer_skin_size =    0.6;

// The width of your extruded filament (mm). Screen threads are a multiple of this for their width. 
printer_extrusion_width = 0.39;

/* [Hidden] */
 
smooth = shape;

custom_shape_screen();

module custom_shape_screen() {
union() {
	union() {
		difference() {   
			union() {
				cylinder(h=depth, r=diameter/2, $fn=smooth);		

				if (indention == 1)  
					// Brim if screen is flush and at the bottom 
					cylinder(h=frame_thickness, r=(border_size + diameter/2), $fn=smooth);
				else
					// OR add a small brim on the bottom side (that prints on top)
					translate([0,0,depth])
					cylinder(h=printer_skin_size, r=(printer_extrusion_width + diameter/2), $fn=smooth);
			}

			translate([0,0,-1])
			cylinder(h=depth+3, r=(diameter/2)-frame_thickness, $fn=smooth);
		}

		meshscreen_shape(h=mesh_height,
					mesh_w=printer_extrusion_width,
					mesh_space=mesh_space,
					width=diameter,
					layer_h=printer_layer_height);

		// Make little nubs on the sides to tighten the fit a little (but only for circles).
		if (nubs == 1) {
			if (smooth > 8)
				for (i = [0:3]) {
					rotate(90*i,[0,0,1])
				translate([(diameter/2),0,depth/2])
				cube(size=[1,1,depth],center=true);
				}
			}
		}
	}
	difference() {
		cylinder(h=center_hole_depth, r=(center_hole_diameter/2), $fn=smooth);
		cylinder(h=center_hole_depth, r=(center_hole_diameter/2)-center_hole_border, $fn=smooth);
	}
	translate([tube_hole_distance,0,0])
	difference() {
		cylinder(h=tube_hole_depth, r=(tube_hole_diameter/2), $fn=smooth);
		cylinder(h=tube_hole_depth, r=(tube_hole_diameter/2)-tube_hole_border, $fn=smooth);
	}
}


module meshscreen_shape(h=2,mesh_w=1,mesh_space=2,width=60,layer_h){
	difference() {
		difference() {
			intersection(){
				cylinder(r=width/2,h,$fn=smooth);
				mesh_raw(h=h,mesh_w=mesh_w,mesh_space=mesh_space,width=width,layer_height=layer_h);
			}
			difference(){
				cylinder(r=width/2,h, $fn=smooth);
				translate([0,0,-h*0.05]) cylinder(r=width/2-0,h=h*1.1, $fn=smooth);
			}
			cylinder(h=center_hole_depth, r=(center_hole_diameter/2)-center_hole_border, $fn=smooth);
		}
		translate([tube_hole_distance,0,0])
		cylinder(h=tube_hole_depth, r=(tube_hole_diameter/2)-tube_hole_border, $fn=smooth);
	}
}

module mesh_raw(h=2,mesh_w=1,mesh_space=2,width=50,layer_height){
	for ( j = [0 :(mesh_w+mesh_space): width] )
	{
	   	translate([0,0,0.01])translate([-width/2+j, 0, h/4])cube([mesh_w,width,h/2-layer_height/10],center=true);
		translate([0,0,h/2])translate([0, -width/2+j, h/4])cube([width,mesh_w,h/2],center=true);
	}
}