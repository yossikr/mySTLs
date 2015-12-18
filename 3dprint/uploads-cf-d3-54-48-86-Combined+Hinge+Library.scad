//Horizontal and Vertical Print-In-Place Hinge Library
//Created by Jon Hollander, September 2013
//jonhollander.me
//
//This work is licensed under the Creative Commons Attribution 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/3.0/.
//

use <MCAD/regular_shapes.scad>

//Example horizontal and vertical in-place hinges

//Example Horizontal Hinge Parameters
horiz_hinge_height=10;
horiz_hinge_arm_width=1;
horiz_hinge_flange_length=15;
horiz_hinge_width = 14;

//Example horizontal hinge centered at origin and hinge axis along y axis.
horiz_hinge_joint(horiz_hinge_width, horiz_hinge_height, horiz_hinge_arm_width, horiz_hinge_flange_length);


//Example Vertical N-type Hinge Parameters

vn_hinge_depth=5;
vn_hinge_height=10;
vn_hinge_length=10;
vn_pin_diameter=2;
vn_hinge_flange_height=2;

vn_hinge_horiz_clearance=.4;
vn_hinge_vert_clearance=.4;


vn_hinge_parts = "Both"; //["Pin Only, Hole Only, Both"]


translate([0, 2*horiz_hinge_width,0]){

	//Draw example N-type hinge with hinge centered at origin and hinge axis along z axis	
	
	vertical_n_hinge(vn_hinge_depth, vn_hinge_height, vn_hinge_length, vn_pin_diameter, vn_hinge_flange_height, vn_hinge_horiz_clearance, vn_hinge_vert_clearance, vn_hinge_parts);

}


//Example Vertical C-type Hinge Parameters

vc_hinge_depth=8;
vc_hinge_height=10;
vc_hinge_length=15;
vc_pin_diameter=2;
//hinge_part_clearance=1.0;
vc_hinge_pin_clearance=0.8;
vc_hole_wall_thickness=3;

vc_hinge_parts = "Both"; //["Pin Only, Hole Only, Both"]

vc_hinge_pin_shape = "Conical"; //["Conical", "Cylinder"]


translate([0, 3*horiz_hinge_width+2*vn_hinge_depth,0]){
//Draw example links
difference(){
	cube([2*vc_hinge_length,vc_hinge_depth,vc_hinge_height], center=true);
	cube([vc_hinge_length,vc_hinge_depth+1,vc_hinge_height+1], center=true);
}

//Draw example C-type hinge with hinge centered at origin and hinge axis along z axis	

vertical_c_hinge(vc_hinge_depth, vc_hinge_height, vc_hinge_length, vc_pin_diameter, vc_hinge_pin_clearance, vc_hole_wall_thickness, vc_hinge_parts, vc_hinge_pin_shape);

}



/////////////////////////////////////
////Horizontal in-place hinge modules
/////////////////////////////////////

//module hinge_joint() 
//Creates both sides of a hinge joint centered at origin and hinge axis along y axis.
//The number of hinge arms is automatically set based on the hinge_width, hinge_clearance, and the hinge_flange_width.  
//If the hinge_width is not evenly divisible by the number of hinge arms, excess space is distributed evenly at the top and bottom of the hinge joint, so that the hinge remains centered at the origin.

module horiz_hinge_joint(hinge_width, hinge_height, hinge_arm_width, hinge_flange_length, hinge_clearance=1, max_overhang_angle=45, pin_base_width_percent=0.8){	

	translate([-(hinge_flange_length+hinge_height/2), -hinge_width/2, -hinge_height/2]) horiz_hinge_pair(hinge_width, hinge_height, hinge_arm_width, hinge_flange_length, hinge_clearance, max_overhang_angle, pin_base_width_percent);

}


//module hinge_pair()
//Creates a hinge pair along y axis with origin at the even side corner, pins pointing in -y direction.
//

module horiz_hinge_pair(hinge_width, hinge_height, hinge_arm_width, hinge_flange_length, hinge_clearance=1, max_overhang_angle=45, pin_base_width_percent=0.8){

//Check hinge dimensions
if(hinge_width<3*hinge_arm_width+2*hinge_clearance){
	echo("<b>WARNING <br>  There needs to be a minimum of 3 hinge arms to hold hinge together. <br> Increase the hinge width to at least ",3*hinge_arm_width+2*hinge_clearance, "<br> or reduce the arm width to ", (hinge_width-2*hinge_clearance)/3,"</b>");
}



//Even rack side
horiz_hinge_rack(hinge_width, hinge_height, hinge_arm_width, hinge_flange_length, "even", hinge_clearance, max_overhang_angle, pin_base_width_percent);

//Odd rack side
translate([2*hinge_flange_length+hinge_height,0,0])
	mirror([1,0,0])
		horiz_hinge_rack(hinge_width, hinge_height, hinge_arm_width, hinge_flange_length, "odd", hinge_clearance, max_overhang_angle, pin_base_width_percent);

}


module horiz_hinge_rack(hinge_width=10, hinge_height=8, hinge_arm_width=2, hinge_flange_length=15, odd_or_even = "even", hinge_clearance=1, max_overhang_angle=45, pin_base_width_percent=0.8){
	
	//Creates a hinge rack for odd or even hinge arms along +y and + x axes.
	//Number of arms depends on width.
	//Excess space at corners.

	arm_count = floor((hinge_width-(2*hinge_arm_width+hinge_clearance))/(hinge_arm_width+hinge_clearance))+2;
	
	excess_space=(hinge_width-(2*hinge_arm_width+hinge_clearance))%(hinge_arm_width+hinge_clearance)/2;
	
	for(i=[0:arm_count-1]){
		translate([0, excess_space+i*(hinge_arm_width+hinge_clearance),0]){
			if(odd_or_even == "even" && i%2 == 0){
			horiz_hinge_flange(hinge_height, hinge_arm_width, hinge_flange_length, hinge_clearance, max_overhang_angle, pin_base_width_percent);
			}
	
			if(odd_or_even == "odd" && i%2!=0){
			horiz_hinge_flange(hinge_height, hinge_arm_width, hinge_flange_length, hinge_clearance, max_overhang_angle, pin_base_width_percent);
			}
		}
	}
}

module horiz_hinge_flange(hinge_height=8, hinge_arm_width=2, hinge_flange_length=15, hinge_clearance=1, max_overhang_angle=45, pin_base_width_percent=0.8){

	//Derived parameters
	pin_base_radius = pin_base_width_percent*hinge_height/2;
	pin_height = pin_base_radius/tan(max_overhang_angle);  //Pin height is limited by max overhang angle
	
	
	
	difference(){
		union(){
			//Flange
			cube([hinge_flange_length+hinge_height/2,hinge_arm_width, hinge_height], center=false);
			//Fillet on top edge of flange
			cube([hinge_flange_length+hinge_height,hinge_arm_width, hinge_height/2], center=false);
			translate([hinge_flange_length+hinge_height/2,0,hinge_height/2])
				rotate([-90,0,0])
					cylinder(r=hinge_height/2, h=hinge_arm_width, center=false, $fn=30);
		
			//Pin
			translate([hinge_flange_length+hinge_height/2,0, hinge_height/2])  
				rotate([90,0,0])
					cylinder(r1=pin_base_radius, r2=0, h=pin_height, center=false, $fn=30);
		}
		
		//Pin Hole on Reverse
		translate([hinge_flange_length+hinge_height/2, hinge_arm_width+.01, hinge_height/2])  
				rotate([90,0,0])
					cylinder(r1=pin_base_radius, r2=0, h=pin_height, center=false, $fn=30);	
		
	}
}



//////////////////////////////////////
////Vertical N-type in-place hinge modules
////
////Generates a vertical print-in-place N-type hinge
////Origin is location of hinge axis and mid-plane of link.
////Hinge axis is aligned with z-axis
////
////Parameters
////h_d - hinge depth/dimension along y axis
////h_h - hinge height/dimension along z axis
////h_l - hinge length/dimension along x axis
////p_d - hinge pin diameter
////f_h - hinge flange height -  Starting height of hinge flange.
////h_c - horizontal clearance between hinge pin and hole
////v_c - vertical clearance between hinge flanges
////hinge_parts - generates "Hole Only", "Pin Only" or "Both" hinge parts
/////////////////////////////////////

module vertical_n_hinge(h_d, h_h, h_l, p_d, f_h, h_c, v_c, hinge_parts="Both"){
	
	if(hinge_parts == "Both" || hinge_parts == "Hole Only"){
		//Hole side of hinge
	
		//Hinge Pin Hole
		difference(){
			union(){
				cylinder(h=h_h, r=h_d/2, center=true,$fn=20);
				translate([-h_l/4,0,0]) cube([h_l/2, h_d, h_h], center = true);
			}
			
		cylinder(h=h_h+1, r=p_d/2+h_c, center=true,$fn=20);
		
		//Cutout for hinge pin and arm
		rotate([90, 0, 0]) 
			translate([0,0,-h_d/2])
				linear_extrude(height=h_d) polygon([[0,-h_h/2+f_h],
								[h_d/2,-h_h/2+f_h],
								[h_d/2,h_h/2-f_h],
								[0,h_h/2-f_h-h_d/2]]);

		}
	}

	if(hinge_parts == "Both" || hinge_parts == "Pin Only"){
		
		cylinder(h=h_h, r=p_d/2, center=true,$fn=20);
		
		difference(){
			translate([h_l/4,0,0]) cube([h_l/2,h_d,h_h], center=true);
			cube([h_d+2*h_c,h_d+1,h_h+1], center=true);			
		}
		
		difference(){
			translate([0,0,-h_h/2])
			linear_extrude(height=h_h)
				polygon([[0, p_d/2],
							[h_d/2+h_c, h_d/2],
							[h_d/2+h_c, -h_d/2],
							[0, -p_d/2]]);
			
			rotate([90, 0, 0]) 
			translate([0,0,-h_d/2])
				linear_extrude(height=h_d) 
						polygon([[0,-h_h/2-1],
									[0,-h_h/2+f_h+v_c],
									[h_d/2+h_c,-h_h/2+f_h+v_c],
								[h_d/2+h_c, -h_h/2-1]]);

			rotate([90, 0, 0]) 
			translate([0,0,-h_d/2])
				linear_extrude(height=h_d) 
						polygon([[0,h_h/2+1],
									[h_d/2+h_c,h_h/2+1],
									[h_d/2+h_c,h_h/2-f_h-v_c],
									[h_d/2,h_h/2-f_h-v_c],
									[0,h_h/2-f_h-v_c-h_d/2]]);
				
					
		}
		
				
	}
}


//////////////////////////////////////
////Vertical C-type in-place hinge modules
////
////Generates a vertical print-in-place C-type hinge
////Origin is location of hinge axis and mid-plane of link.
////Hinge axis is aligned with z-axis
////
////Parameters
////h_d - hinge depth/dimension along y axis
////h_h - hinge height/dimension along z axis
////h_l - hinge length/dimension along x axis
////p_d - hinge pin diameter
////p_c - pin clearance between hinge pin and hole.
////v_c - vertical clearance between hinge flanges
////w_t - wall thickness of hinge flange around hinge pin
////hinge_parts - generates "Hole Only", "Pin Only" or "Both" hinge parts
////hinge_pin_shape - shape of hinge pin may be "Cylinder" or "Conical"
/////////////////////////////////////


module vertical_c_hinge(h_d, h_h, h_l, p_d, p_c, w_t, hinge_parts="Both", hinge_pin_shape = "Conical"){

	//Other params - can't define variables inside if statements, so put at beginning.

	max_flange_thickness = h_l/2-h_c-p_d/2;
	flange_percent=0.5;

	conical_pin_radius = (h_d/2-p_d/2)/2+p_d/2-p_c/2;  //Max conical radius is halfway between pin radius and hinge depth, minus half the pin clearance.

	if(hinge_parts == "Both" || hinge_parts == "Pin Only"){
		//Pin side of hinge
	
		//Hinge Pin
		if(hinge_pin_shape == "Cylinder"){
			cylinder(h=h_h, r=p_d/2, center=true,$fn=20);
		} else {
			//Conical pin
			
			cylinder(h=h_h/2, r1=conical_pin_radius, r2=p_d/2, center=false,$fn=20);
			translate([0,0,-h_h/2]) cylinder(h=h_h/2, r1=p_d/2, r2=conical_pin_radius, center=false,$fn=20);
		}
		
		//Pin Side Flanges
		difference(){
			translate([0,0,-h_h/2])
			linear_extrude(height=h_h)
			polygon([[0,-p_d/2],
						[h_l/2,-h_d/2],
						[h_l/2,h_d/2],
						[0,p_d/2]]);
			
			rotate([90,0,0]) translate([0,0,-h_d/2])
			linear_extrude(height=h_d)
				polygon([[0,h_h/2],
							[h_l/2,0],
							[0,-h_h/2]]);
		}
	}

	if(hinge_parts == "Both" || hinge_parts == "Hole Only"){
		//Hole side of hinge
		
		difference(){
			union(){
				if(hinge_pin_shape == "Cylinder"){
					translate([-h_l/2,-h_d/2,-h_h/2]) cube([p_d/2+p_c+w_t,h_d,h_h], center=false);
					rotate([90,0,0]) translate([p_d/2+p_c+w_t,0,-h_d/2])
					linear_extrude(height=h_d)
						polygon([[-h_l/2,h_h/2],
									[0,0],
									[-h_l/2,-h_h/2]]);
				} else {
					translate([-h_l/2,-h_d/2,-h_h/2]) cube([conical_pin_radius+p_c+w_t,h_d,h_h], center=false);
					rotate([90,0,0]) translate([conical_pin_radius+p_c+w_t,0,-h_d/2])
					linear_extrude(height=h_d)
						polygon([[-h_l/2,h_h/2],
									[0,0],
									[-h_l/2,-h_h/2]]);
				}
			}
		
			//Hinge Pin
			if(hinge_pin_shape == "Cylinder"){
				cylinder(h=h_h, r=p_d/2+p_c, center=true,$fn=20);
			} else {
				//Conical pin
				cylinder(h=h_h/2, r1=conical_pin_radius+p_c, r2=p_d/2+p_c, center=false,$fn=20);
				translate([0,0,-h_h/2]) cylinder(h=h_h/2+.001, r1=p_d/2+p_c, r2=conical_pin_radius+p_c, center=false, $fn=20);
			}
			
			translate([0,0,-h_h/2]){
				linear_extrude(height=h_h) 
					polygon([[p_d/2, h_d/2],
								[h_l/2,0],
								[h_l/2,h_d/2],
								[h_l/2,h_d/2+1],
								[p_d/2,h_d/2+1]]);
					
				linear_extrude(height=h_h) 
					polygon([[p_d/2, -h_d/2],
								[h_l/2,0],
								[h_l/2,-h_d/2],
								[h_l/2,-h_d/2-1],
								[p_d/2,-h_d/2-1]]);		
						
			}
		
		}
	}
}

