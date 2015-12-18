include <MCAD/units.scad>
use <Measurement.scad>
use <write.scad>

M1 = 23.5;
M2 = 12.6;
M3 = 16.3;
M4 = 32.8;
M5 = 2;
M6 = 22.6;
M7 = 29.3;
M8 = 4;
M9 = 2.7;
M10 = M2/2;
M11 = 2.65;
M12 = (M4-M1)/2;
M13 = 2.25;

servo("front");
translate([-17,0,0]) rotate([0,0,90])servo("left");
translate([-55,M1,0]) rotate([0,0,-90])servo("right");
translate([0,M7,M6 + 15]) rotate([90,0,0])servo("top");
translate([0,0,M6 + M7 + 15]) rotate([-90,0,0])servo("bottom");
translate([-17,M2,M7+5]) rotate([0,0,180])servo("back");


module servo(view = false) {
		if(view == "front")
		{
			translate([M1/2,0,M6/2])
			rotate([90,0,0])
			color("Black")write(view,t=2,h=5,center=true);

			translate([0,0,-5])
			measurement("horizontal",view,M1,"M1");

			translate([-((M4-M1)/2),0,-12])
			measurement("horizontal",view,M4,"M4");

			translate([-7,0,0])
			measurement("vertical",view,M3,"M3","above");

			translate([-7,0,M6])
			measurement("vertical",view,M8,"M8","above");

			translate([M1 + 7,0,0])
			measurement("vertical",view,M6,"M6");

			translate([0,0,M7])
			measurement("horizontal",view,M10,"M10","above");

			translate([M1,0,M3+M5])
			measurement("horizontal",view,M12,"M12","above");

		}

		if(view == "left")
		{
			translate([0,M2/2,M6/2])
			rotate([90,0,-90])
			color("Black")write(view,t=2,h=5,center=true);

			translate([0,0,-5])
			measurement("horizontal",view,M2,"M2");

			translate([0,M2 + 3,M3])
			measurement("vertical",view,M5,"M5","above");

			translate([0,M2 + 3,M6+M8])
			measurement("vertical",view,M9,"M9","above");

			translate([0,-4,0])
			measurement("vertical",view,M7,"M7","above");
		}

		if(view == "top")
		{
			translate([M1/2,M2/2,M7])
			color("Black")write(view,t=2,h=5,center=true);

			translate([M4-M12-M11,M10,M7])
			measurement("horizontal",view,M11,"M11");

			translate([-M12+M11,0,M7])
			measurement("vertical",view,M10,"M10","above");
		}

		if(view == "right")
		{
			translate([M1,M2/2,M6/2])
			rotate([90,0,90])
			color("Black")write(view,t=2,h=5,center=true);

			translate([0,0,-5])
			measurement("horizontal",view,M2,"M2");

			translate([0,-4,0])
			measurement("vertical",view,M7,"M7","above");

		}

		if(view == "back")
		{
			translate([M1/2,M2,M6/2])
			rotate([90,0,-180])
			color("Black")write(view,t=2,h=5,center=true);

			translate([M1 + 7,M2,0])
			measurement("vertical",view,M6,"M6","above");

			translate([M10,M2,M7])
			measurement("horizontal",view,M13,"M13","above");
		}

		if(view == "bottom")
		{
			translate([M1/2,M2/2,0])
			rotate([180,0,0])
			color("Black")write(view,t=2,h=5,center=true);

			translate([-((M4-M1)/2),-5,0])
			measurement("horizontal",view,M4,"M4","above");

			translate([-((M4-M1)/2),0,0])
			measurement("vertical",view,M2,"M2","above");

		}

	color("LightBlue", 0.5) {
		cube([M1,M2,M6]);
		translate([-M12,0,M3]) difference() {
			cube([M4,M2,M5]);
			translate([M11,M10,-epsilon]) cylinder(r=1,h=M5+2*epsilon,$fn=45);
			translate([M4-M11,M10,-epsilon]) cylinder(r=1,h=M5+2*epsilon,$fn=45);
		}
		translate([M10,M10,M6-epsilon]) cylinder(r=M2/2,h=M8+epsilon,$fn=45);
		translate([M10,M10,M6+M8-epsilon]) cylinder(r=M13,h=M9+epsilon,$fn=45);
	}
}

