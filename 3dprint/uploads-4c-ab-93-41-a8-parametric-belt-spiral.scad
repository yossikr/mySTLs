h=17;				// height of links (width of belt)
g=0.45;				// gap between bar and enclosing shape to provide smooth rotation
ir=1.5;				// radius of bar
or=ir+g;			// radius of cylinder around bar
oor=3;				// width of links
ooratio = 0.7;	// roundness of round links: 1 - round, 0.1 is extremely skinny, 0.7 is what I use
s=7;				// spacing between links
m=2;				// 2mm radius on corners of rectangle links
oorm=oor-m/2;	// inner rectangle width for minkowski for rectangle links
irm=ir-m;			// inner rectangle height "

round=1;
octagon=2;
shape=round;	// shape of links

spiral(5,1);

//translate([-52,-55,0])
//	#cube([120,120,10]);

module spiral(max=20, n=1) {
	rotate([0,0,360/(2+sqrt(n)*3)])
		if (n==max) {
			clipped_cblock();
		} else {
			clipped_vblock();
		}
	if (n<max) {
		rotate([0,0,360/(2+sqrt(n)*3)])
			translate([0,-s,0])
				spiral(max,n+1);
	}
}

module bar() {
	if (shape==round) {
		translate([0,0,-2*ir]) scale([1,ooratio,1]) cylinder(r=oor,h=2*h);
		}
	else {
		translate([-oorm,-irm,-2*ir]) minkowski() {
			cube([2*oorm,2*irm,2*h]);
			cylinder(r=m, h=1, $fn=8);
			}
		}
	}

module x() {
	difference() {
		union() {
			cylinder(r=ir, h=h, $fn=16);
			translate([0,-h,0]) cylinder(r=ir, h=h, $fn=32);
			rotate([45,0,0]) bar();
			}
		union() {
			//translate([-1.5*oor,-2*oor,-1.5*oor]) cube([s+2*oor,4*oor,1.5*oor]);
			//translate([-1.5*oor,-2*h,h]) cube([s+2*oor,2*oor+2*h,h/2+g]);
			}
		}
	}

module v() {
	difference() {
		union() {
			cylinder(r=ir, h=h, $fn=16);
			rotate([45,0,0]) 
				if (shape==round) {
					translate([0,0,-2*ir]) scale([1,ooratio,1]) cylinder(r=oor,h=h);
					}
				else {
					translate([-oorm,-irm,-ir]) minkowski() {
						cube([2*oorm,2*irm,h]);
						cylinder(r=m, h=1, $fn=8);
						}
					}
			}
		union() {
			//translate([-1.5*oor,-oor,-1.5*oor]) cube([s+2*oor,2*oor,1.5*oor]);
			translate([-1.5*oor,-oor-h,h/2]) cube([s+2*oor,2*oor+h,h/2+g]);
			translate([0,-s,0]) cylinder(r=or,h=h, $fn=32);
			}
		}
	}

module vblock() {
	v();
	translate([0,0,h]) rotate([0,180,0]) v();
	}

module xblock() {
	x();
	translate([0,0,h]) rotate([0,180,0]) x();
	}

module cblock() {
	difference() {
		union() {
			v();
			translate([0,0,h]) rotate([0,180,0]) v();
			}
		translate([0,-s-ir+g,0]) cube([oor,2*(ir)-g,h]);
		}
	}



module clipped_vblock() {
	intersection() {
		vblock();
		translate([-h/2,-h,0])
			cube([h,2*h,h]);
	}
}

module clipped_cblock() {
	intersection() {
		cblock();
		translate([-h/2,-h,0])
			cube([h,2*h,h]);
	}
}


