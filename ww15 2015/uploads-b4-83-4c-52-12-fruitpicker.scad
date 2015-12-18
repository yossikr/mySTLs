/*-----------------------------------------------------------------------------------

 fruitpicker
 (c) 2014 by Stemer114 (stemer114@gmail.com)
 http://www.thingiverse.com/Stemer114/designs
 License: licensed under the 
          Creative Commons - Attribution - Share Alike license. 
          http://creativecommons.org/licenses/by-sa/3.0/

 Credits: 
          MCAD Library - Polyholes Copyright 2011 Nophead (of RepRap fame)
          It is licensed under the terms of Creative Commons Attribution 3.0 Unported.
          https://github.com/SolidCode/MCAD/blob/master/polyholes.scad

-----------------------------------------------------------------------------------
*/

//-----------------------------------------------------------------------------------
//libraries
//-----------------------------------------------------------------------------------
//polyholes lib is in local dir
use <MCAD/polyholes.scad>

//-----------------------------------------------------------------------------------
// View settings
// (when exporting single stls for printing, enable these one by one)
//-----------------------------------------------------------------------------------
show_picker = true;  

//-----------------------------------------------------------------------------------
// printer/printing settings
// (some dimensions are tuned to printer settings)
//-----------------------------------------------------------------------------------
layer_h = 0.3;  //layer height when printing
nozzle_d = 0.4; //nozzle size (adjust for your printer)

//-----------------------------------------------------------------------------------
//global configuration settings
//-----------------------------------------------------------------------------------
de = 0.1; //epsilon param, so differences are scaled and do not become manifold
//fn_hole = 12;  //fn setting for round holes/bores (polyholes use their own algorithm)


//-----------------------------------------------------------------------------------
//parametric settings (object dimensions)
//-----------------------------------------------------------------------------------
P10 = 140;  //outer diameter (picker is only half circle)
P11 = 5;    //thickness
P12 = 30;   //height
//Aussparungen
P20 = 17;   //height
P21 = 10;   //width
P22 = 9;   //count
P23 = 210;   //exception angle (where handle is connected)
//attachment bores
P25 = 3.2;  //diameter
P26 = (P12-P20)/2;  //height offset from base
P27 = 15;    //backside outer bore offset from edge
P28 = 35;    //         inner
//connector
P30 = 35;  //length
P31 = 30;  //inner length
P32 = 21.2;  //inner dia
P33 = 23;    //outer dia
P35 = 30;    //height
P36 = 30;    //width


//-----------------------------------------------------------------------------------
// main rendering
//-----------------------------------------------------------------------------------

assembly();

//-----------------------------------------------------------------------------------
// modules
//-----------------------------------------------------------------------------------

module assembly()
{
    union()
    {

        if (show_picker) {
            picker();
        }  //end if

        }  //end union
}  //end module


module picker()
{
    difference()
    {
        union()
        {
            //base ring
            //cut half of it away
            difference()
            {
            ring(h=P12, od=P10, id=P10-2*P11);
            translate([0, -P10/2-de, -de])
                cube([P10, P10+2*de, P12+2*de]);
            }
            //flat wall
            translate([0, -P10/2, 0])
            cube([P11, P10, P12]);

            //connector body with handle cutout
            translate([P11/2, -P36/2, 0])
                difference()
                {
                    cube([P30, P36, P35]);
                    translate([P30-P31+de, P36/2, P35/2])
                        rotate([0, 90, 0])
                        cylinder(h=P31, r1=P32/2, r2=P33/2, center=false);
                }


        }  //union 1

        union()
        {
            //cutouts
            translate([0, 0, P12-P20+de])
                for ( i = [0 : P22-1] )
                {
                    rotate( 0.5 * P23 + i * (360 - P23) / (P22-1), [0, 0, 1])
                        translate([P10/2-2*P11, 0, 0])
                        {
                        translate([0, -P21/2, 0]) cube([P10, P21, P20+de]);
                        translate([0, 0, -P26]) rotate([90, 0, 90]) polyhole(h=P10, d=P25);

                        }
                }

            //attachment bores in flat side
            //outer
            translate([-de, -P10/2+P27, P26])
                rotate([90, 0, 90]) polyhole(h=P11+2*de, d=P25);
            translate([-de, P10/2-P27, P26])
                rotate([90, 0, 90]) polyhole(h=P11+2*de, d=P25);
            //inner
            translate([-de, -P10/2+P28, P26])
                rotate([90, 0, 90]) polyhole(h=P11+2*de, d=P25);
            translate([-de, P10/2-P28, P26])
                rotate([90, 0, 90]) polyhole(h=P11+2*de, d=P25);
  


        }  //union 2
    }  //difference
}

//a ring with heigth h, outside diameter od and inside diameter id
module ring(
        h=1,
        od = 10,
        id = 5
        ) 
{
    difference() {
        cylinder(h=h, r=od/2);
        translate([0, 0, -de])
            cylinder(h=h+2*de, r=id/2);
    }
}


