difference(){
union(){cylinder(h=12,r1=25.5,r2=25.5,center=true);
translate([0,0,35])cylinder(h=50,r1=6,r2=16,center=true);
sphere(16);
translate([0,0,60])sphere(16);
}
translate([0,0,-12])cylinder(h=12,r1=25.5,r2=25.5,center=true);
}
