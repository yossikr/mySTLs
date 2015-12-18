//parametric bearing - example: 608 bearing

inner_m8=4.4;  				// Inner radius: when increasing the size of the balls, you need to set this lower than 4.4


inner_wall_width = 1.3;
outter_wall_width = 1.14;
radius_balls=1.83;
radius_hole=1.13*radius_balls;	//when using bigger balls, you might change this multiplicator
radius_gap = inner_m8+radius_balls+inner_wall_width;
gap_size = 1.2;

bearing_radius = radius_balls*2+inner_m8+inner_wall_width+outter_wall_width;			// Outside radius: depending on the ballsize, the inner radius and the walls
bearing_height = 7;			// exactly means, what it's name is


//this are the different modules

module core()
{

	difference()
	{
		cylinder(r=bearing_radius, h=bearing_height,$fn=40);
		
		//inner hole for m8 bar
		translate([0,0,-1]) cylinder(r=inner_m8, h=9, $fn=40);
	}

}


module round_hole() 
{

	//rounding
	rotate_extrude(convexity = 6, $fn = 40)
	translate([radius_gap, 0, 0])
	circle(r = radius_hole, $fn = 6);

	//hole for ball infill
	translate([radius_gap-(gap_size/2-0.1),0,0]) rotate([0,90,0]) cylinder(r=radius_balls,h=70, $fn=30);
	
}

module theoretical_balls() 
{

	rotate_extrude(convexity = 6, $fn = 40)
	translate([radius_gap, 0, 0])
	circle(r = radius_balls, $fn = 36);
}

module plug()
{

	difference()
	{

		union()
		{
			rotate([0,90,0]) cylinder(r=radius_balls-0.2,h=2.5,$fn=30);
					
		}
		
		//make the inside of the plug look like the inside of the bearing
		translate([-0.45,3,0]) rotate([90,0,0]) cylinder(r=radius_balls, h=5,$fn=30);

	}
	
}

module gap()
{

	difference()
	{
		
		//the gap goes through the whole bearing 
		cylinder(r=radius_gap+gap_size/2, h=15, $fn=40);
		translate([0,0,-1]) cylinder(r=radius_gap-gap_size/2, h=17, $fn=40);

	}	

}


module bearing()
{
	
	difference()
	{
		core();

		//hole for balls
		translate([0,0,bearing_height/2]) round_hole();

		//gap
		translate([0,0,-2]) gap();

	}

}


//here is the real action

bearing();								   //only the bearing (for rendering)
translate([8,0,bearing_height/2]) plug(); 			   //only the plug - you might switch the position and orientation for printing the plug
#translate([0,0,bearing_height/2])theoretical_balls();      //just to imagine where the balls will be running
