$fn=360;

module torus(outerRadius, innerRadius)
{
  r=(outerRadius-innerRadius)/2;
  rotate_extrude() translate([innerRadius+r,0,0]) circle(r,$fn=90);	
}
module outside_circular_radius(outerRadius, roundingRadius)
  {
  translate([0,0,-roundingRadius])
    rotate_extrude()
	  translate([outerRadius-roundingRadius,0,0])
        difference()
          {
	      square(roundingRadius+0.1);
	      circle(roundingRadius,$fn=60);
	      }
  }

  //build platform for debug
  color([0.5,0.5,0.5,0.1]) translate([-50,-50,-1.01]) %cube([100,100,1]);

 //#translate([0,0,3]) torus(outerRadius=(30+6)/2,innerRadius=(30-6)/2);
  
 difference()
   {
   union()
     {
     cylinder(r=48/2,h=30);
     //translate([0,0,108-15]) sphere(r=15);
     //translate([0,0,3]) torus(outerRadius=(30+6)/2,innerRadius=(30-6)/2);
     }
   translate([0,0,15]) torus(outerRadius=(48+11+11)/2,innerRadius=(48-4-4)/2);
   translate([0,0,30]) outside_circular_radius(outerRadius=48/2,roundingRadius=3); 
   difference()
     {
     translate([0,0,9.7645]) outside_circular_radius(outerRadius=48/2,roundingRadius=3);  
     cylinder(r=45.9/2,h=20);
     }

   mirror([0,0,1])
     difference()
       {
       translate([0,0,9.7645-30]) outside_circular_radius(outerRadius=48/2,roundingRadius=3);  
       translate([0,0,-30]) cylinder(r=45.9/2,h=20);
       }

   translate([0,0,-1]) #cylinder(r=1.25,h=20);
   }
