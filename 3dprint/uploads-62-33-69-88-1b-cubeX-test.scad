use <cubeX.scad>

color("white",0.5)
translate([0,0,0])
cubeX(size=10,radius=1,rounded=true,$fn=16);

%color("red")
%translate([-10,-10,-10])
%cubeX([10,10,10],radius=1,rounded=false,$fn=8);