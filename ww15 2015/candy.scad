candyr = 7.5;  // radius of hole, many thigns relative to this
overlap = 0;
wall = 2;
tolerance=1;
outwall = 6;  // guess
hheight = 25;
cheight = 10;

candyh = 5;
inleth = candyh/2;
outleth = 2;


handlewy = 6;
handlewx = candyr*2+wall+outwall+tolerance*2;
buttonx = 3;
buttony = 8;
doveoffset = 22;


slidewx = candyr*4 - overlap + wall*2;
slotwx = candyr*6 - overlap*2 + wall*2 + tolerance*2;

slidewy = candyr*2 + wall*2;
slotwy = slidewy + tolerance*2;


outr = slotwx/2 + outwall;  // minimum width

echo ("Outside radius = ",outr, " volume = ",outr*outr*3.1415926*hheight/1000);

//utility stuff

module mirror2(axis) {
  child(0);
  mirror(axis) child(0);
}

module dovetail_bot(length, offset){
  mirror2([0,1,0])
    translate([0,offset,0])
    rotate([90,0,90])
      linear_extrude(height=length, center=true, convexity=10, twist=0)
        polygon(points=[[0,0], [3,0], [5,5], [-2,5]], paths=[[0,1,2,3]]);
}

module dovetail_top(length, offset){
  mirror2([0,1,0])
    translate([0,offset,0])
	rotate([90,0,90])
	  linear_extrude(height=length, center=true, convexity=10, twist=0)
	    polygon(points=[[-0.5,-0.01], [3.5,-0.01], [5.5,5.5], [-2.5,5.5]], paths=[[0,1,2,3]]);
}


// slide
module slide() {
  translate([0,0,-candyh-tolerance]){
    difference(){
      translate([-candyr-wall, -candyr-wall , 0])
	 cube(size= [ slidewx, slidewy, candyh ], center=false);
       cylinder(h = candyh, r=candyr , center = false);
    }
    // slide handle
    translate([-handlewx-candyr-wall, -handlewy/2 ,0]){
       cube(size=[handlewx,handlewy, candyh], center=false);
    // button
       translate([0,handlewy/2,0])
	scale([buttonx/10,buttony/10,0])
	 cylinder(h=candyh, r=10, center=false);
    }
  }
} 

module bottom() {
  difference(){
    translate([0,0,-outleth-tolerance*2-candyh])
      cylinder(h=outleth+candyh+tolerance*2, r=outr, center=false);
    translate([-candyr*2-overlap, 0, -outleth-tolerance*2-candyh])
       cylinder(h = outleth, r=candyr , center = false);
    // slot
    translate([-slotwx/2, -slotwy/2, -candyh-tolerance*2])
      cube(size=[slotwx,slotwy,candyh+tolerance*2], center=false);
    // handle slot
    translate([-slotwx/2-outwall, -handlewy/2-tolerance, -candyh-tolerance*2])
       cube(size=[outwall, handlewy+tolerance*2, candyh+tolerance*2], center=false);
  }
  intersection(){
    cylinder(h=6, r=outr,center=false);
    dovetail_bot(60,doveoffset);
  }
}

module top() {
  difference() {
      cylinder(h=hheight+cheight, r=outr, center=false);
      // cone width = height for 45 deg overhang req'd for skeinforge-0006
      //cylinder(h=cheight, r1=candyr, r2=candyr+cheight, center=false);
      cylinder(h=cheight, r1=candyr, r2=outr-wall-candyr/2, center=false);
      translate([0,0,cheight])
	cylinder(h=hheight, r=outr-wall);
      dovetail_top(60,doveoffset);
  }
  // "threads" for the top
  translate([0,0,cheight+hheight])
  intersection(){
    rotate_extrude(convexity = 10)
      translate([outr-0.5,0,0])
      polygon(points=[[0,0], [0,-3], [3,0]], paths=[[0,1,2]]);
    translate([0,0,-3])
      cube(center=true,size=[outr,outr*2+10,7]);
  }
}

// note: lid is upsidown so it builds right
module lid()
{
  difference() {
    cylinder(h=5, r=outr+4.5);
    translate([0,0,1.05])  // 3*0.35 layer thickness
      cylinder(h=5, r=outr+3);
  }
  translate([0,0,2]) intersection(){
    rotate_extrude(convexity=10)
      translate([outr+3.1,0])
      polygon(points=[[0,0],[0,3],[-3,3]], paths=[[0,1,2]]);
     translate([0,0,2])
      cube(center=true,size=[outr,outr*2+10,5]);
  }
  rotate([0,0,45])
    translate([0,outr,0])
      cube(center=false,size=[3,3,5]);
  rotate([0,0,225])
    translate([0,outr,0])
      cube(center=false,size=[3,3,5]);
}



// comment out these and uncomment one at a time to export individual ports
// translate lines are to separate the parts for viewing

bottom();

slide();

//color([0.0,0.5,0.9,0.3]) 
translate([0,0,6])
  top();

translate([0,0,cheight+hheight+10])
  lid();
