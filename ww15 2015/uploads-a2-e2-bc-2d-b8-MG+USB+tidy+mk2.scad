$fn=150;

//MK2 USB tidy. Mount it on a wall or similar with double sided tape.
//NB. x,y, and z co-ordinates are for drawing and manufacture NOT as mounted as unit will be rotated through 90 degrees to mount.

nbr_slots=7;
cocr=3; //corner radius of large cut out
lcox=12; //large cut out x dim
lcoz=19; //large cut out z dim
lcoffset=2; //distance between large cut and base
pitch=lcox+5;

bpx=nbr_slots*pitch+pitch-lcox; //length of base plate in the x direction
bpy=30; //length of base plate in the y direction
bpz=6; //length of base plate in the z direction
bpcr=3; //corner radius of base plate

spy=10; //thickness of stand plate
spz=bpz+lcoffset+1.2*lcoz; //height of stand plate

scox=5; //small cut out width
sup_x=(pitch-lcox)/2;
sup_y=.3*bpy;
sup_z=0.8*(spz-bpz);

start_large=pitch-lcox;
start_small=start_large+(lcox-scox)/2;
start_first_support=(pitch-lcox)/2-sup_x/2;
start_second_support=start_large+lcox/2+pitch/2-sup_x/2;

//base_plate();
//stand_plate();
//large_cut_out();
//small_cut_out();



	difference()
	{
		combined_plates();
		translate([n*pitch,0,0]) combined_cut_out();
	}

difference()
{
	rectangular_supports();
	translate([0,sup_y,sup_z++bpz]) rotate(a=[0,90,0]) cylinder(r=0.8*sup_y,h=bpx);
}


module rectangular_supports()
{
	translate([start_first_support,sup_y,bpz-.01]) cube([sup_x,sup_y,sup_z]);
	
	for(n=[0:nbr_slots-2])
	{
		translate([start_second_support+n*pitch,sup_y,bpz-.01]) cube([sup_x,sup_y,sup_z]);
	}
	translate([bpx-(pitch-lcox)/2-sup_x/2,sup_y,bpz-.01]) cube([sup_x,sup_y,sup_z]);
}

module combined_plates()
{
	base_plate();
	stand_plate();
}

module combined_cut_out()
{
	union()
	{
		large_cut_out();
		small_cut_out();
		round_cut_out();
	}
}

module small_cut_out()
{
	for(n=[0:nbr_slots-1])
	{
		translate([start_small+n*pitch,.6*bpy-spy/2,bpz+lcoffset]) cube([scox,2*spy,spz]);
	}
}

module large_cut_out()
{
	for(n=[0:nbr_slots-1])
	{
		translate([start_large+n*pitch,.6*bpy+spy/2,bpz+lcoffset])
		hull()
		{
			translate([cocr,0,cocr]) rotate(a=[-90,0,0]) cylinder(r=cocr,h=spy);
			translate([lcox-cocr,0,cocr]) rotate(a=[-90,0,0]) cylinder(r=cocr,h=spy);
			translate([lcox-cocr,0,lcoz-cocr]) rotate(a=[-90,0,0]) cylinder(r=cocr,h=spy);
			translate([cocr,0,lcoz-cocr]) rotate(a=[-90,0,0]) cylinder(r=cocr,h=spy);
		
		}
	}
}

module round_cut_out()
{
	for(n=[0:nbr_slots-1])
	{
		translate([lcox/2+start_large+n*pitch,.6*bpy-lcox/2,bpz+lcoffset+lcoz/2]) rotate(a=[-90,0,0]) cylinder(r=lcox/2,h=2*spy);
	}
}

module stand_plate()
{
	translate([.001,.6*bpy,.01]) cube([bpx-.002,spy,spz]);
}

module base_plate()
{
	hull()
	{
		translate([bpcr,bpcr,0]) cylinder(r=bpcr,h=bpz);
		translate([bpx-bpcr,bpcr,0]) cylinder(r=bpcr,h=bpz);
		translate([bpx-bpcr,bpy-bpcr,0]) cylinder(r=bpcr,h=bpz);
		translate([bpcr,bpy-bpcr,0]) cylinder(r=bpcr,h=bpz);
	}
}