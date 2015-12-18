$fn=360;
//cylinder(h=30,r=8.25);
//cylinder(h=30,r=8.3);
//cylinder(h=30,r=8.4);
//cylinder(h=30,r=8.16);

/* Glasses box
difference() {
cylinder(h=134.3,r=27);
translate([0,0,1.6])
 cylinder(h=140,r=25.5);
}
*/

difference() {
cylinder(h=22,r=28.5);
translate([0,0,5])
 cylinder(h=42,r=27);

translate([0,0,1.6])
 cylinder(h=41.6,r=25.5);
}