/*
 * Lampklem
 * Klem om Roos' daglichtlamp ook op de keukentafel te kunnen gebruiken
 * 2012-10-07, JvO New
 *
 */

// parameters
c=true; // center True/False

// DXF file and layers
dxf="Lampklem.dxf";
layer1="0";
layer1="1";
scale=1.0;
h1=40.0;	// height
h2=47.0;	// depth hole
dia=12.5;
//echo("dxf:", dxf);

klem(h1,dia, h2);

module klem( h, dia ) {
	difference() {
		linear_extrude( file=dxf, layer=layer1, height=h, scale=scale, center=c );
		translate( [40,126,0] ) rotate( [90,0,0] ) cylinder( r=dia/2, h=h2 );
	}
}

// END