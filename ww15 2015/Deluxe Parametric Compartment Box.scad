/* Parametric compartment box by Tomi T. Salo <ttsalo@iki.fi> 2012. */

include <MCAD/boxes.scad>

$fn = 60;

module myRoundedBox(size, radius, sidesonly, center) {
  if (radius == 0) {
    cube(size, center = center);
  } else {
    if (center == true) {
      roundedBox(size, radius, sidesonly);
    } else {
      translate(size / 2)roundedBox(size, radius, sidesonly);
    }
  }
}

/* Handle for a box. Extends from X=0 towards negative Y-values, scaled according
    to total Z height. */
module handle(style, totalZ) {
  radius = 0.1;
  overhang = 30;
  scale(totalZ)
  union () {
    translate([0, 0, 0.8])rotate(90 + overhang, [1, 0, 0])
       translate([0, 0, -0.1])cylinder(r = radius, h = 0.4);
    translate([0, 0, 0.2])rotate(90 - overhang, [1, 0, 0])
       translate([0, 0, -0.1])cylinder(r = radius, h = 0.4);
    translate([0, -0.3 * cos(overhang), 0.2 + sin(overhang) * 0.3])
       sphere(r = radius);  
    translate([0, -0.3 * cos(overhang), 0.8 - sin(overhang) * 0.3])
       sphere(r = radius);
    translate([0, -0.3 * cos(overhang), 0.2 + sin(overhang) * 0.3])
       cylinder(r = radius, h = 0.6 - 0.6 * sin(overhang));
  }
}

/* isBottom: whether we're making the bottom or the top part 
   columns: the number of compartments in the X-direction.
   rows: the number of compartments in the Y-direction.
   columnWidth: the internal width of each compartment (in the X-direction).
   rowHeight: the internal height of each compartment (in the Y-direction). 
   boxThickness: the internal thichness of the compartments (in the 
     Z-direction).
   bottomThickness: the thickness of the bottom material.
   topThickness: the thickness of the top material.
   outerWallThickness: the thickness of the outer walls of the bottom 
     section and the outer lip of the top section.
   innerWallThickness: the thickness of the internal walls between 
     compartments.
   topLipThickness: the thickness of the short walls protruding into 
     the compartments.
   topLipHeight: the height of the short walls protruding into the 
     compartments.
   topFitTolerance: extra space between the bottom section parts and the 
     corresponding grooves in the top section (this much between every edge). 
   cornerRounding: internal corners are rounded with the given radius
   handleStyle: if non-zero, a handle is added to bottom part
*/
module compartmentBox(isBottom, columns, rows, columnWidth, rowHeight, boxThickness, 
                      bottomThickness, topThickness, outerWallThickness, 
                      innerWallThickness, topLipThickness, topLipHeight, 
                      topFitTolerance, cornerRounding, handleStyle) {
  botX = columns * columnWidth + (columns - 1) * innerWallThickness + 
                2 * outerWallThickness;
  botY = rows * rowHeight + (rows - 1) * innerWallThickness + 
                2 * outerWallThickness;
  botZ = bottomThickness + boxThickness;  
  echo(str("Total size (mm): ", botX, " * ", botY, " * ", botZ));
  if (isBottom)
    {
      /* The bottom section is modelled by one big cube (plus a possible handle) 
          with the compartments subtracted out. */
       difference() {
         union () {
           //cube([botX, botY, botZ], center = false);
           myRoundedBox([botX, botY, botZ],cornerRounding,  true, false);
           if (handleStyle != 0) {
             translate([botX/2, 0, 0])handle(handleStyle, botZ);
           }
         }
         for (i = [0 : (columns - 1)])
           {
             for (j = [0 : (rows - 1)])
              {
                translate([outerWallThickness + (columnWidth + 
                                                 innerWallThickness) * i,
                           outerWallThickness + (rowHeight + 
                                                 innerWallThickness) * j,
                           bottomThickness])
                myRoundedBox([columnWidth, rowHeight, boxThickness * 2],
                             cornerRounding, false, false);
             }
          }
      }
    } else {
    /* The top is made of an union of: 
       1) Top plate 
       2) Outer top lip made with a difference
       3) Internal compartment lips each made by subtracting the hollow 
          portion out of a solid block. */
    union() {
      translate([-topFitTolerance, -topFitTolerance, 0])
        cube([columns * columnWidth + (columns - 1) * innerWallThickness + 
              2 * outerWallThickness + 2 * topFitTolerance,
              rows * rowHeight + (rows - 1) * innerWallThickness + 
              2 * outerWallThickness +
	      2 * topFitTolerance, topThickness], center = false);
      difference () {
        translate([-(outerWallThickness + topFitTolerance) , 
                   -(outerWallThickness + topFitTolerance), 0])
          cube([columns * columnWidth + (columns - 1) * innerWallThickness + 
                4 * outerWallThickness + 2 * topFitTolerance,
                rows * rowHeight + (rows - 1) * innerWallThickness + 
                4 * outerWallThickness +
                2 * topFitTolerance,
                topThickness + topLipHeight], center = false);
        translate([-topFitTolerance, -topFitTolerance, 0])
          cube([columns * columnWidth + (columns - 1) * innerWallThickness + 
                2 * outerWallThickness + 2 * topFitTolerance,
                rows * rowHeight + (rows - 1) * innerWallThickness + 
                2 * outerWallThickness + 2 * topFitTolerance,
                topThickness + topLipHeight], center = false);
      }
      
      
      for (i = [0 : (columns - 1)])
        {
          for (j = [0 : (rows - 1)])
            {
              difference () {
                translate([outerWallThickness + (columnWidth + 
                                                 innerWallThickness) * i +
                           topFitTolerance,
                           outerWallThickness + (rowHeight + 
                                                 innerWallThickness) * j +
                           topFitTolerance,
                           topThickness]) 
                  myRoundedBox([columnWidth - 2 * topFitTolerance , 
                                rowHeight - 2 * topFitTolerance, 
                                topLipHeight], cornerRounding, true, false);
                translate([outerWallThickness + (columnWidth + 
                                                 innerWallThickness) * i + 
                           topLipThickness + topFitTolerance,
                           outerWallThickness + (rowHeight + 
                                                 innerWallThickness) * j +
                           topLipThickness + topFitTolerance,
                           topThickness]) 
                  myRoundedBox([columnWidth - 
                                2 * topLipThickness - 
                                2 * topFitTolerance, 
                                rowHeight - 
                                2 * topLipThickness - 
                                2 * topFitTolerance, 
                                topLipHeight],
                               cornerRounding, true, false);
                                
              }
            }
        }
    }
  }
}

/* Cabinet and drawer.
    isCabinet: if true, produces the cabinet, otherwise one piece of drawer
    columns: number of vertical columns of compartments in the cabinet
    rows: number of horizontal rows of compartments in the cabinet
    drawerColumns: number of columns (left to right) of compartments in a drawer
    drawerRows: number of rows (front to back) of compartments in a drawer
    columnWidth, rowHeight, boxThickness: internal dimensions of one compartment,
       same as the main compartmentBox
    thinWall: thickness of all walls except outer walls of the cabinet
    thickWall: outer walls of the cabinet
    fitTolerance: extra space for the drawers in each dimension
    cornerRounding: if not 0, internal corners of compartments are rounded
    handleStyle: set 1 for the default handle style */    

module cabinet(isCabinet, columns, rows, drawerColumns, drawerRows, columnWidth, rowHeight, 
                              boxThickness, thinWall, thickWall, 
                              fitTolerance, cornerRounding, handleStyle) {
  if (isCabinet == true) {
    compartmentBox(true, columns, rows, 
                                    drawerColumns * columnWidth + (drawerColumns + 1) * thinWall + fitTolerance,
                                    boxThickness + thinWall + fitTolerance,
                                    drawerRows * rowHeight + (drawerRows + 1) * thinWall + fitTolerance,
                                    thickWall, 0, thickWall, thinWall, 0, 0, 0, 0, 0);
  } else {
    compartmentBox(true, drawerColumns, drawerRows, columnWidth, rowHeight, boxThickness, 
                      thinWall, 0, thinWall, thinWall, 0, 0, 0,
                      cornerRounding, handleStyle);
  }
}

/* Cabinet calculated from the total size instead of compartment size. */
module cabinetBySize(isCabinet, columns, rows, drawerColumns, drawerRows, 
                              totalColumnWidth, totalRowHeight, totalBoxThickness, 
                              thinWall, thickWall, 
                              fitTolerance, cornerRounding, handleStyle) {
  colW = (totalColumnWidth - 2 * thickWall - columns * fitTolerance - (columns - 1) * (thinWall)) / columns;
  rowH = (totalRowHeight - 2 * thickWall - rows * fitTolerance - (rows - 1) * (thinWall)) / rows;
  boxT = totalBoxThickness - thickWall - fitTolerance;
  dColW = (colW - (drawerColumns + 1) * thinWall) / drawerColumns;
  dRowH = (boxT - (drawerRows + 1) * thinWall) / drawerRows;
  dBoxT = rowH - thinWall;
  echo(str("Total design size (mm): ", totalColumnWidth, " * ", totalRowHeight, " * ", 
                     totalBoxThickness));
  echo(str("Drawer size (mm): ", colW, " * ", rowH, " * ", boxT));
  echo(str("Compartment size (mm): ", dColW, " * ", dRowH, " * ", dBoxT));
  cabinet(isCabinet, columns, rows, drawerColumns, drawerRows, dColW, dRowH, dBoxT,
                              thinWall, thickWall, 
                              fitTolerance, cornerRounding, handleStyle);
} 

thinWall = 1.6;
thickWall = 1.6;



//cabinet(true, 1, 2, 2, 2, 20, 20, 15, thinWall, thickWall, 1.0, 5, 1);
//cabinet(false, 2, 9, 3, 3, 30, 38, 19, thinWall, thickWall, 1.0, 5, 1);
//cabinetBySize(false, 1, 6, 2, 1, 195, 195, 120, thinWall, thickWall, 1.0, 5, 1);
//compartmentBox(false, 2, 2, 20, 20, 20, 1, 1, thinWall, thinWall, thinWall, 4, 0.5, 5, 0);

//For Yael?
//cabinet(false, 2, 2, 2, 1, 55, 60, 45, thinWall, thickWall, 0.5, 5, 0);

// For Toothpick in car
//cabinet(false, 2, 2, 2, 1, 12, 7, 30, thinWall, thickWall, 0.5, 3.5, 0);


compartmentBox(true, 2, 1, 12, 7, 30, thinWall, 0, thinWall, thinWall, 0, 0, 0,3.5, 0);

//compartmentBox(false, 2, 2, 20, 20, 20, 1, 1, thinWall, thinWall, thinWall, 4, 0.5, 5, 0);
//compartmentBox(false, 2, 1, 55, 60, 45, 1, 1, thinWall, thinWall, thinWall, 4, 0.5, 5, 0);
                      
