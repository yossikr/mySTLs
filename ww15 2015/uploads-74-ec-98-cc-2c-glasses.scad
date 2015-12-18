// remember to print with 0% infill and no solid top layers.
// Suggested settings: 5 solid base layers, 0 top layers, 3 perimeters, 0% infill, cooling fan on
// NB This isn't a quick file to render, estimates somewhere between 2 to 10 minutes. Be patient!

// wall thickness (of the sliced part)
// this is how thick your shell is, so print a test block with the number of perimeters
// that you're planning to use for this (1.1mm is for 3 perimeters, 0.3mm nozzle)
wallT = 1.1;
// inner radius of ribs, mm
rad1 = 3; 
// outer radius of ribs, mm
rad2 = 5; 
// total length of glasses, mm
tHeight = 143;

// don't modify these variables
shrink = 0.76;
$fs=0.5;
hSec = (tHeight-24)/31;

module glassesClearance() {                                 
	minkowski() {
		scale([shrink,shrink,1])
		linear_extrude(height = 0.1) {
			//////////////////////////////////////////////////////////////////////
			// this is a polygon that describes the prism shape of the glasses. //
			// cut a hole in a bit of card that your glasses _just_ fit through //
			// and translate these points into this polygon                     //
			//////////////////////////////////////////////////////////////////////
			polygon(points = [[0,-2],[0,33],[4,42],[27,34],[25,22]],
				path = [1,2,3,4,5]);
		}
	}
}

module vertPrismProfile1(secHeight, secProtrude, basRad) {
	cylinder(h=secHeight, r1=basRad, r2=basRad+secProtrude);
}

module vertPrismProfile2(secHeight, secProtrude, basRad) {
	cylinder(h=secHeight, r2=basRad, r1=basRad+secProtrude);
}

// male part, change the following line to "if (0) {" to suppress rendering the male part.
if (1) {
	intersection() {
		mirror([1,0,0]) {
			minkowski() {
				glassesClearance();
				cylinder(h=rad1, r1=0, r2=rad1);
			}
			for ( i = [0:7] ) {
				translate([0,0,i*hSec*2+rad1]) minkowski() {
					glassesClearance();
					vertPrismProfile1(hSec, rad2-rad1, rad1);
				}
				translate([0,0,i*hSec*2+hSec+rad1]) minkowski() {
					glassesClearance();
					vertPrismProfile2(hSec, rad2-rad1, rad1);
				}
			}
			translate([0,0,8*hSec*2+rad1]) minkowski() {
				glassesClearance();
				cylinder(h=22, r=rad1);
			}
			////////////////////////////////////////////////////////////
			// Friction Locks                                         //
			// If you modify the glasses profile you should fiddle    //
			// where these friction lock appear in the upper part of  //
			// the male section. Exact positioning is hard to judge,  //
			// if you print the female first, uncomment the line      //
			// marked below to just print the mating half of the male // 
			// part in isolation.                                     //
			////////////////////////////////////////////////////////////
			translate([6.4,13.5,8*hSec*2+rad1+11]) intersection() {
				hull() {
					translate([0,0,-5]) sphere(r=10.2);
					translate([0,0,5])  sphere(r=10.2);
				}
				translate([0,0,0]) cube([22,22,22], center=true);
			}
			translate([10,22.7,8*hSec*2+rad1+11]) intersection() {
				hull() {
					translate([0,0,-5]) sphere(r=10.2);
					translate([0,0,5])  sphere(r=10.2);
				}
				translate([0,0,0]) cube([22,22,22], center=true);
			}
		}
	// uncomment the following line if you want to only print the mating section of the male part
	//translate([0,0,8*hSec*2+rad1]) cylinder(h=22, r=200);
	}
}

// female part, change the following line to "if (0) {" to suppress rendering the female part.
if(1) {
	translate([40,0,0]) {
		minkowski() {
			glassesClearance();
			cylinder(h=rad1, r1=0, r2=rad1);
		}
		for ( i = [0:7] ) {
			translate([0,0,i*hSec*2+rad1]) minkowski() {
				glassesClearance();
				vertPrismProfile1(hSec, rad2-rad1, rad1);
			}
			translate([0,0,i*hSec*2+hSec+rad1]) minkowski() {
				glassesClearance();
				vertPrismProfile2(hSec, rad2-rad1, rad1);
			}
		}
		translate([0,0,8*hSec*2+rad1]) minkowski() {
			glassesClearance();
			vertPrismProfile1(hSec, rad2-rad1, rad1);
		}
		for ( i = [0:5] ) {
			translate([0,0,hSec*8*2+rad1+hSec+2*2*i])  minkowski() {
				glassesClearance();
				vertPrismProfile1(2, 0.1+wallT+rad1-rad2, rad2);
			}
			translate([0,0,hSec*8.25*2+rad1+hSec+2*2*i]) minkowski() {
				glassesClearance();
				vertPrismProfile2(2, 0.1+wallT+rad1-rad2, rad2);
			}
		}
	}
}

//translate([-20,0,rad1]) cylinder(h=tHeight/2-11,r=10);