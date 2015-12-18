// an arbitrarily large number
// must be finite to allow use in geometric operations
// interaction between objects of indeterminate size results in undefined behavior
indeterminate = 1e6;

// an arbitrarily small number
// must be nonzero to meet the assumptions of the library

infinitesimal = 0.001;

// helper variables for aligning along the z axis
top = [0,0,1];
center=[0,0,0];
bottom = [0,0,-1];
up = [0,0,1];
down = [0,0,-1];
x = [1,0,0];
y = [0,1,0];
z = [0,0,1];

// properties of the last instance of rod/box/ball in the call stack
$parent_size=[0,0,0];
$parent_bounds=[0,0,0];
$parent_radius=0;
$parent_type="space";

//inhereted properties common to all geometric primitives in relativity.scad
// indicates the class(es) to render
$show = "";
$hide = "";
// indicates the class that is either assigned-to or inherited-by an object
$class = "";

//hammard product (aka "component-wise" product) for vectors
function hammard(v1,v2) = [v1.x*v2.x, v1.y*v2.y, v1.z*v2.z];


// form repeating patterns through translation
module translated(offset, n=[1]){
	for(i=n)
		translate(offset*i)
			children();
}

// form radially symmetric objects around the z axis
module rotated(offset, n=[1]){
	for(i=n)
		rotate(offset*i)
			children();
}

// form bilaterally symmetric objects using the mirror() function
module mirrored(axes=[0,0,0]){
	mirror(axes)
		children();
		children();
}

module hulled(class=""){
	if(_is_match($class, $show))
	hull()
	assign($show=class)
	children();

	children();
}

// performs the union on objects marked as positive space (i.e. objects where $class = positive), 
// and performs the difference for objects marked as negative space (i.e objects where $class = $negative)
module differed(positive, negative){
	if(_is_match($class, $show))
	difference(){
		assign($show=positive)
			children();
		assign($show=negative)
			children();
	}
}

// performs the intersection on a list of object classes
module intersected(class=""){
	if(_is_match($class, $show))
	intersection(){
		assign($show=positive)
			children();
		assign($show=negative)
			children();
	}
}

// like translate(), but use positions relative to the size of the parent object
// if tilt==true, child objects will also be oriented away from the parent object's center
module align(anchors){
	assign(anchors = len(anchors.x)==undef && anchors.x!= undef? [anchors] : anchors)
	for(anchor=anchors)
	{
		translate(hammard(anchor, $parent_bounds)/2)
		assign($outward = anchor, $inward = -anchor)
			children();
	}
}

// like rotate(), but works by aligning the zaxis to a given vector
module orient(zaxis, roll=0){
	rotate(_orient_angles(zaxis))
	rotate(roll*z)
		children();
}

// duplicates last instance of box/rod/ball in the call stack
// useful for performing hull() or difference() between parent and child 
module parent(size=undef, anchor=center){
	assign(size = size==undef? $parent_size : size)
	if($parent_type=="box") 
		box(size, anchor=anchor)
			children();
	else if($parent_type=="rod")
		rod(size, anchor=anchor)
			children();
	else if($parent_type=="ball")
		ball(size, anchor=anchor)
			children();
}

// wrapper for cube with enhanced centering functionality and cascading children
module box(size, anchor=$inward) {
	assign(size = len(size)==undef && size!= undef? [size,size,size] : size)
	assign( $parent_size = size, 
			$parent_type="box", 
			$parent_bounds=[size.x < indeterminate/2? size.x : 0,
							size.y < indeterminate/2? size.y : 0,
							size.z < indeterminate/2? size.z : 0],
			$inward=center, 
			$outward=center){
		translate(-hammard(anchor, size)/2)
			if(_is_match($class, $show)) cube(size, center=true);
		translate(-hammard(anchor, $parent_bounds)/2)
			children();
	}
}
// wrapper for cylinder with enhanced centering functionality and cascading children
module rod(size=[1,1,1], 
			h=indeterminate, d=indeterminate, r=undef, 
			anchor=$inward, orientation=top) {
	//diameter is used internally to simplify the maths
	assign(d = r!=undef? 2*r : d)
	assign(size =	len(size)==undef && size!= undef? 
							[size,size,size] : 
						d<indeterminate-1 || h<indeterminate-1? 
							[d,d,h] : 
						size)
	assign(bounds = _rotate_matrix(_orient_angles(orientation)) * [size.x,size.y,size.z,1])
	assign($parent_size = size, 
			$parent_type="rod",
			$parent_bounds=[abs(bounds.x) < indeterminate/2? abs(bounds.x) : 0,
							abs(bounds.y) < indeterminate/2? abs(bounds.y) : 0,
							abs(bounds.z) < indeterminate/2? abs(bounds.z) : 0],
			$parent_radius=sqrt(pow(h/2,2)+pow(d/2,2)),
			$inward=center, 
			$outward=center){
		translate(-hammard(anchor, [abs(bounds.x),abs(bounds.y),abs(bounds.z)])/2){
			if(_is_match($class, $show))
				orient(orientation) 
				resize(size) 
				cylinder(d=size.x, h=size.z, center=true);
		}
		translate(-hammard(anchor, $parent_bounds)/2)
			children();
	}
}
// wrapper for cylinder with enhanced centering functionality and cascading children
module ball(size=[1,1,1], d=undef, r=undef, anchor=$inward) {
	//diameter is used internally to simplify the maths
	assign(d = r!=undef? 2*r : d)
	assign(size =	len(size)==undef && size!= undef? 
							[size,size,size] : 
						d!=undef? 
							[d,d,d] : 
						size)
	assign($parent_size = size, 
			$parent_type="ball", 
			$parent_bounds=[size.x < indeterminate/2? size.x : 0,
							size.y < indeterminate/2? size.y : 0,
							size.z < indeterminate/2? size.z : 0],
			$inward=center, 
			$outward=center ){
		translate(-hammard(anchor, size)/2)
			if(_is_match($class, $show)) resize(size) sphere(d=size.x, center=true);
		translate(-hammard(anchor, $parent_bounds)/2)
			children();
	}
}

function _rotate_x_matrix(a)=
							[[1,0,0,0], 
                      [0,cos(a),-sin(a),0], 
                      [0,sin(a),cos(a),0], 
                      [0,0,0,1]]; 

function _rotate_y_matrix(a)=
							[[cos(a),0,sin(a),0], 
                      [0,1,0,0], 
                      [-sin(a),0,cos(a),0], 
                      [0,0,0,1]]; 

function _rotate_z_matrix(a)=
							[[cos(a),-sin(a),0,0], 
                      [sin(a),cos(a),0,0], 
                      [0,0,1,0], 
                      [0,0,0,1]]; 

function _rotate_matrix(a)=_rotate_z_matrix(a.z)*_rotate_y_matrix(a.y)*_rotate_x_matrix(a.x);

function _orient_angles(zaxis)=
				[-asin(zaxis.y / norm(zaxis)),
		  		 atan2(zaxis.x, zaxis.z),
		  		 0];

function _is_match(class, selector) = 
	len(search(selector, class)) > 0 || selector == "";
