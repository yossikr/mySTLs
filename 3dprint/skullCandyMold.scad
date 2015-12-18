/* ----------------------------------------------------------------------
Skull with Pointed Teeth Chocolate Mold
----------------------------
Created with a scanned with 123D Catch. The raw scan is available here: 
123dapp.com/obj-Catch/Skull-with-Pointed-Teeth/859975
---------------------------
This mold is a work in progress, it is currently only partially parametric.  
Make sure you download the vampireSkull_0.2.stl file and place it in the same folder.
You may want to adjust the wall width to a larger number.  This will print, but it may be porous when you 
attempt to pour mold material into it. I used liquid tape on the bottom to make it water tight.   
----------------------------
Anna Kaziunas France
www.kaziunas.com
10.21.2012
derived from acker's parametric box http://www.thingiverse.com/thing:15113
which was derived from hippiegunnut's http://www.thingiverse.com/thing:12307
----------------------------------------------------------------------*/

//skull spacing
filename = "vampireSkull_0.2.stl"; //name of the STL to scale
skullStartXPos = 30;
skullStartYPos = 23;
skullStartZPos = 0.9;
skullXSpacing = 45;
skullYSpacing = 35;

//mould pour box vars
//Replicator max build platform: 225 x 145 x 150 mm
compx = 140;		// Size of compartments, X
compy = 112;		// Size of compartments, Y
wall = 1.3;		// Width of wall ("thin" by default")
nox = 1;			// Number of compartments, X
noy = 1;			// Number of compartments, Y
deep = 35;		// Depth of compartments

union() {
	//import that thing! Move it around in rows that are sort of adjusted for the size of the box! 
	for ( i = [skullStartYPos : skullYSpacing : compy] ) {
		translate ([skullStartXPos,i,skullStartZPos]) import(filename, convexity=30);
		translate ([skullStartXPos+skullXSpacing,i,skullStartZPos]) import(filename, convexity=30);
		translate ([skullStartXPos+skullXSpacing*2,i,skullStartZPos]) import(filename, convexity=30);
	}
	//create the mold pour box with acker's parametric box code 
	difference() {
		//create the outside box, can be multiple compartments if you like
		cube ( size = [nox * (compx + wall) + wall, noy * (compy + wall) + wall, (deep + wall)], center = false);
		for ( ybox = [ 0 : noy - 1]) {
	             for( xbox = [ 0 : nox - 1]) {
					translate([ xbox * ( compx + wall ) + wall, ybox * ( compy + wall ) + wall, wall])
					cube ( size = [ compx, compy, deep+1 ]);
				}
		}
	}
}

