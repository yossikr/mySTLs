//Created by Ari M. Diacou, August 2013
//Shared under Creative Commons License: Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0) 
//see http://creativecommons.org/licenses/by-sa/3.0/
//module block(height,width,thickness,curvature)
//module wedge(inner,width,theta,thickness,curvature)

/* [Base] */
//How many blocks form a circle?
blocks_per_rev=20;
//Number of layers of blocks in the turret base
height=6;
//The height of each block in mm
block_height=8;
//The radial width of a block in mm
block_thickness=8;
//The internal radius of the turret in mm
turret_radius=20;
//The radius of curvature of the edges
curvature=1;
//How much curviness do you want?
$fn=30;
/* [Top] */
//Do you want a top?
care="yes";//[yes,no]
//Do 45 degree overhangs scare you?
noob="no";//[yes,no]
//How many blocks wide do you want the lookout stones?
factor=1.5;

rad=turret_radius;
num=blocks_per_rev;
for(h=[0:height-1]){
	rotate([0,0,90*(pow(-1,h))/num]) translate([0,0,h*block_height]) union(){
		for(i=[1:num]){
		   rotate( i * 360 / num, [0,0,1])	wedge(turret_radius,block_thickness,360/num,block_height,curvature);
			}
		}
	}


phase=360/num*(ceil(factor)-factor)/2;
if (care=="yes") {
	if(noob=="no"){
		translate([2*rad+4*block_thickness,0,block_height]) union(){
			translate([0,0,block_height*(-1.5)]) 
				cylinder(block_height,turret_radius+block_thickness,turret_radius+2*block_thickness);
			for(i=[1:num]){
				rotate( i * 360 / num, [0,0,1])	
					wedge(turret_radius+block_thickness,block_thickness,360/num,block_height,curvature);
				}
			for(i=[1:num/2]){
				translate([0,0,block_height])	
					rotate( phase+i * 720 / num, [0,0,1])	
						wedge(turret_radius+block_thickness,block_thickness,(360*factor)/num,block_height,curvature);
				}
			}
		}
	if(noob=="yes"){
		translate([2*rad+4*block_thickness,0,0*block_height]) union(){
			for(i=[1:num]){
				rotate( i * 360 / num, [0,0,1])	
					wedge(turret_radius+block_thickness,block_thickness,360/num,block_height,curvature);
				}
			for(i=[1:num/2]){
				translate([0,0,block_height])	
					rotate( phase+i * 720 / num, [0,0,1])	
						wedge(turret_radius+block_thickness,block_thickness,(360*factor)/num,block_height,curvature);
				}
			}
		translate([0,2*rad+4*block_thickness,-.5*block_height])
			cylinder(block_height,turret_radius+2*block_thickness,turret_radius+block_thickness);
		}
	}

module wedge(inner,width,theta,thickness,curvature){
	//inner		=inner radius of arch
	//width		=width of block
	//theta		=angle subtended by block
	//thickness	=thickness of block
	//curvature	=roundedness of corners, should be less than all of: thickness, width and inner*sin(theta/2)
	//The block is made by combining 8 spheres, 12 cylinders and 3 extruded polygons. This function could be created with a minkowski combination of a sphere and a polyhedron, but the rendering time was horrific. It creates a wedge shaped block on the x axis which extends thickness/2 in each of the z-axis directions, and +theta degrees in the xy-plane
	outer=inner+width;
	r=curvature;
	
	//Angles describing the spheres positions must be recalculated so that the objects fit inside the angle called. Positions are translated to cartesian from cylindrical coorinates (r,theta,z). Because the inner spheres B and C subtend more angle, they requrire a different correction angle than outer spheres A and D.
	phi_o=atan(r/(outer-r));
	phi_i=atan(r/(inner+r));

	//Coodinates for the blocks that fill out the faces
	//Block 1 fills out top and bottom (z-hat direction)
	a1=[(outer-r)*cos(theta-phi_o), (outer-r)*sin(theta-phi_o)];
	b1=[(inner+r)*cos(theta-phi_i), (inner+r)*sin(theta-phi_i)];
	c1=[(inner+r)*cos(phi_i), (inner+r)*sin(phi_i)];
	d1=[(outer-r)*cos(phi_o), (outer-r)*sin(phi_o)];
	
	//Block 2 fills out inner and outer radii (r-hat direction)
	a2=[(outer)*cos(theta-phi_o), (outer)*sin(theta-phi_o)];
	b2=[(inner)*cos(theta-phi_i), (inner)*sin(theta-phi_i)];
	c2=[(inner)*cos(phi_i), (inner)*sin(phi_i)];
	d2=[(outer)*cos(phi_o), (outer)*sin(phi_o)];

	//Block 3 fills out the faces in direction of curvature (theta-hat direction)
	a3=[(outer-r)*cos(theta), (outer-r)*sin(theta)];
	b3=[(inner+r)*cos(theta), (inner+r)*sin(theta)];
	c3=[(inner+r)*cos(0), (inner+r)*sin(0)];
	d3=[(outer-r)*cos(0), (outer-r)*sin(0)];
	
	h=thickness-2*r;
	H=[0,0,h];
	//The principle vectors that define the centers of the spheres and cylinders
	A=[(outer-r)*cos(theta-phi_o), (outer-r)*sin(theta-phi_o),0]+H/2;
	B=[(inner+r)*cos(theta-phi_i), (inner+r)*sin(theta-phi_i),0]+H/2;
	C=[(inner+r)*cos(phi_i), (inner+r)*sin(phi_i),0]+H/2;
	D=[(outer-r)*cos(phi_o), (outer-r)*sin(phi_o),0]+H/2;
	//The complementary vectors which are below the z axis
	Ac=A-H;
	Bc=B-H;
	Cc=C-H;
	Dc=D-H;
	union(){
		//Blocks 1-3 which flatten the faces
		translate([0,0,-thickness/2]) linear_extrude(thickness) polygon(points=[a1,b1,c1,d1]);
		translate(-H/2) linear_extrude(thickness-2*r) polygon(points=[a2,b2,c2,d2]);
		translate(-H/2) linear_extrude(thickness-2*r) polygon(points=[a3,b3,c3,d3]);
		//The spheres which round the corners, notice the calling of translation vectors above
		translate(A) sphere(r,center=true);
		translate(B) sphere(r,center=true);
		translate(C) sphere(r,center=true);
		translate(D) sphere(r,center=true);
		translate(Ac) sphere(r,center=true);
		translate(Bc) sphere(r,center=true);
		translate(Cc) sphere(r,center=true);
		translate(Dc) sphere(r,center=true);
		//The cylinders which round the edges, the (X+Y)/2 means that the cylinder connects spheres at X and Y
		translate((A+Ac)/2) cylinder(h,r,r,center=true);
		translate((B+Bc)/2) cylinder(h,r,r,center=true);
		translate((C+Cc)/2) cylinder(h,r,r,center=true);
		translate((D+Dc)/2) cylinder(h,r,r,center=true);
		translate((A+B)/2) rotate([-theta,90,0]) cylinder(width-2*r,r,r,center=true);
		translate((B+C)/2) rotate([90,0,theta/2]) cylinder(2*inner*sin((theta-2*phi_i)/2),r,r,center=true);
		translate((C+D)/2) rotate([0,90,0]) cylinder(width-2*r,r,r,center=true);
		translate((D+A)/2) rotate([90,0,theta/2]) cylinder(2*outer*sin((theta-2*phi_o)/2),r,r,center=true);
		translate((Ac+Bc)/2) rotate([-theta,90,0]) cylinder(width-2*r,r,r,center=true);
		translate((Bc+Cc)/2) rotate([90,0,theta/2]) cylinder(2*inner*sin((theta-2*phi_i)/2),r,r,center=true);
		translate((Cc+Dc)/2) rotate([0,90,0]) cylinder(width-2*r,r,r,center=true);
		translate((Dc+Ac)/2) rotate([90,0,theta/2]) cylinder(2*outer*sin((theta-2*phi_o)/2),r,r,center=true);	
	}
}