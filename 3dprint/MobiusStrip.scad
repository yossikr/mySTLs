dowelRad = 0.5*0.25*25.4;
holeRad = 7.55/2;
linearSideLength = 12*2*dowelRad;
loopAngleOffset = 180/12;
width = 49;
turnAngleOffset = 180/12;
height = 7.55+4;

difference ()
{
	union ()
	{
		translate([-linearSideLength/2,-width/2,0])
		cube([linearSideLength,width,height]);
		translate([-linearSideLength/2,0,0])
		cylinder(r=width/2,h=height,$fn=50);
		translate([linearSideLength/2,0,0])
		cylinder(r=width/2,h=height,$fn=50);
		translate([-linearSideLength/2,-width/2-6.35/2-2,0])
		cube([linearSideLength,6.35+4,height]);
	}
	union ()
	{
		translate([-linearSideLength/2,-width/2+6.35/2+5,0])
		cube([linearSideLength,width-6.35-10,height]);
		translate([-linearSideLength/2,0,0])
		cylinder(r=width/2-6.35/2-5,h=height,$fn=50);
		translate([linearSideLength/2,0,0])
		cylinder(r=width/2-6.35/2-5,h=height,$fn=50);
	}
	// Straight holes
	union ()
	{
		for (i=[1:13])
		{
			translate([-linearSideLength/2+2*(i-1)*dowelRad,width/2,0])
			cylinder(r=holeRad,h=height,$fn=8);
		}
	}
	// Turn holes one side
	union ()
	{
		translate([linearSideLength/2,0,0])
		{
			for (i=[1:11])
			{
				translate([(width/2)*sin(i*turnAngleOffset),(width/2)*cos(i*turnAngleOffset),0])
				cylinder (r=holeRad,h=height,$fn=8);
			}
		}
	}
	// Turn holes other side
	union ()
	{
		translate([-linearSideLength/2,0,0])
		{
			for (i=[1:11])
			{
				translate([-(width/2)*sin(i*turnAngleOffset),(width/2)*cos(i*turnAngleOffset),0])
				cylinder (r=holeRad,h=height,$fn=8);
			}
		}
	}
	// Half loop holes
	union ()
	{
		for (i=[1:12])
		{
			translate([-linearSideLength/2+2*(i-1)*dowelRad,-width/2,height/2])
			rotate(a=-(i-1)*loopAngleOffset,v=[1,0,0])
			{
				cylinder(r=holeRad,h=2*height,center=true,$fn=8);
				translate([-holeRad,-12,-height]) cube([2*holeRad,12,2*height]);
			}
		}
	}
	// Last half loop hole
	translate([linearSideLength/2,-width/2,0]) cylinder(r=holeRad,h=height,$fn=8);
}