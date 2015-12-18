$fn=50;

$radius=|radius|;
$pipediameterext=|pipediameterext|;
$lenght3=80;


$thickness= |thickness| ;
$lenght= 80 ;


$width= 5;
$pipediameterint=$pipediameterext-$thickness;

$radius2=$radius;
$lenght2=$radius*5;
$cutting=$radius2+($width)/2+$thickness;
$shift=15;

difference()                                           // pipe hole 
{ 
union() {
difference () 
{
 cylinder ($lenght,$radius,$radius,center=true );
 union() {
  translate([0,0,-$shift]) {
   translate([0,0,-$lenght/2])                   // large bottom hole
    cylinder ($lenght+1,$radius-$thickness,$radius- $thickness,center=true );
   translate ([$cutting,0,$radius2])             // right cyl hole
    rotate (90,[1,0,0])
     cylinder ($lenght2,$radius2,$radius2,center=true);
   translate ([$cutting,0,$radius2+$lenght/2])  // right cube hole
    cube ([$radius2*2,$lenght2,$lenght],center=true);
   translate ([-$cutting,0,$radius2])
    rotate (90,[1,0,0])
     cylinder ($lenght2,$radius2,$radius2,center=true);
   translate ([-$cutting,0,$radius2+$lenght/2])
    cube ([$radius2*2,$lenght2,$lenght],center=true);
   
   translate ([0,0,$lenght/2])
   cylinder ($lenght/2,$radius*3,$radius*3, center=true);
}
}
}
    translate ([0,0,$lenght/2-$shift])
   cylinder ($lenght3,$pipediameterext*1.5,$pipediameterext,center=true);
}
    translate ([0,0,$lenght/2-$shift])
   cylinder ($lenght3+1,$pipediameterint*1.5,$pipediameterint,center= true);
}
