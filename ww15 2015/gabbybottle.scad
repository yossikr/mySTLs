x=120;
y=60;
z=12;
radi=16;
grad=0; //-30
difference(){
cube([x,y,z],true);
union(){
translate([-x/4,0,0])color([1,0,0])rotate([0,grad,0])
cylinder(h=z*4,r=radi,center=true,$fn=60);
translate([x/2,0,0])rotate([0,30,0])cube([x,y*1.1,z],true);
}
}