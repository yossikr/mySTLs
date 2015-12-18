difference(){
insert();
union(){
translate([25,10,2])cylinder(h=4,r1=8,r2=8,center=true);
translate([25,10,-2])cylinder(h=6,r1=4.1,r2=4.1,center=true);
}
}
//translate([41,-5,0])cube([2,30,2]);



/*********************************************************
 Everything after this point is just to draw the  gorillapod insert
 *********************************************************/
module insert(standOffHeight=3)
{
	insertAngle =7;
	insertLength=40;
	baseThick=2;
	Wbase=20;
	difference()
	{
		union(){
		difference(){
			color([1,0,0])roundedTrapezoid(thick=baseThick, angle=insertAngle, r1=0, r2=2.5, baseW=Wbase, length=insertLength);
			rotate([0,15,0])translate([-0.5,Wbase/2 - 17.5/2,-6])cube([15,17.5,7]);
		}
		translate([0,Wbase/8,-1*standOffHeight])
		color([0,1,0])roundedTrapezoid(thick=standOffHeight+2, angle=insertAngle, r1=0, r2=2.5, baseW=Wbase/1.4, length=insertLength);
		}
		translate([0.75,Wbase/4,1.75])rotate([0,60,0])cube([2,10,4]);
	}
}


/*********************************************************
Rounded Trapezoid modules were stolen directly from the Pocket Coin-Op
 *********************************************************/
module roundedTrapezoid(thick=5, length=19.5, r1=2, r2=9.5, angle=13.5, baseW=23) 
{
x1 = length*sin(angle);
difference()
{
trapezoidSolid(thick = thick, length = length, r1=r1, r2=r2, angle = angle, baseW=baseW);
translate([length,-1*x1,0])cube([2*r2-length,baseW+2*x1,thick]);
rotate([0,0,-1*angle])translate([0,-1*(r1+r2+5),0])cube([length,r1+r2+5, thick]);
translate([0,baseW,0]) rotate([0,0,angle])cube([ length,r1+r2+5, thick]);
}
}


module trapezoidSolid(thick=5, length=19.5, r1=1, r2=9.5, angle=13.5, baseW=23)
{
r1oSet = length/cos(angle)-r1*tan((90+angle)/2);// -r1-r1*tan(angle);//-r1/cos(angle);
sideoSet = r2*tan((90-angle)/2);// r2*(1- tan(angle));
sidelen = r1oSet-sideoSet;
bottomoSet = (length*sin(angle))-r1*tan((90+angle)/2);

rotate([0,0,-1*angle])
{
translate([r1oSet,r1,0])cylinder(h=thick, r=r1);
translate([sideoSet,r2,0])cylinder(h=thick,r=r2);
translate([sideoSet,0,0]) cube([sidelen,2*r1,thick]);
}
translate([0,baseW,0])rotate([0,0,angle])
{
translate([0,-2*r1,0])
{
translate([r1oSet,r1,0])cylinder(h=thick, r=r1);
translate([sideoSet,-r2+2*r1,0])cylinder(h=thick,r=r2);
translate([sideoSet,0,0]) cube([sidelen,2*r1,thick]);
}
}
translate([0,sideoSet,0])cube([length,baseW-2*sideoSet,thick]);
translate([r2,-bottomoSet,0])cube([length-r2,baseW+2*bottomoSet,thick]);
}