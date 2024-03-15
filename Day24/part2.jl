struct Vec3D
	x :: Int128
	y :: Int128
	z :: Int128
end

struct Hailstone
	p :: Vec3D
	v :: Vec3D
end

h_0 = Hailstone(
	Vec3D(291493672529314, 259618209733833, 379287136024123),
	Vec3D(-9, 119, -272),
)

h_1 = Hailstone(
	Vec3D(308409248682955, 156803514643857, 424989308414284),
	Vec3D(-78, 236, -255),
)

h_2 = Hailstone(
	Vec3D(195379943194796, 213851381371727, 355270583377422),
	Vec3D(25, 14, -15),
)

h_3 = Hailstone(
	Vec3D(297329579961934, 122004770593749, 344090716183747),
	Vec3D(-87, 185, -36)
)

A = [
	(h_0.v.y - h_1.v.y) (h_1.v.x - h_0.v.x) (0) (h_1.p.y - h_0.p.y) (h_0.p.x - h_1.p.x) (0) ;

	(h_0.v.z - h_1.v.z) (0) (h_1.v.x - h_0.v.x) (h_1.p.z - h_0.p.z) (0) (h_0.p.x - h_1.p.x) ;

	
	(h_0.v.y - h_2.v.y) (h_2.v.x - h_0.v.x) (0) (h_2.p.y - h_0.p.y) (h_0.p.x - h_2.p.x) (0) ;

	(h_0.v.z - h_2.v.z) (0) (h_2.v.x - h_0.v.x) (h_2.p.z - h_0.p.z) (0) (h_0.p.x - h_2.p.x) ;

	
	(h_0.v.y - h_3.v.y) (h_3.v.x - h_0.v.x) (0) (h_3.p.y - h_0.p.y) (h_0.p.x - h_3.p.x) (0) ;

	(h_0.v.z - h_3.v.z) (0) (h_3.v.x - h_0.v.x) (h_3.p.z - h_0.p.z) (0) (h_0.p.x - h_3.p.x) ;
]

b = [
	(h_0.p.x*h_0.v.y - h_0.p.y*h_0.v.x - h_1.p.x*h_1.v.y + h_1.p.y*h_1.v.x),
	(h_0.p.x*h_0.v.z - h_0.p.z*h_0.v.x - h_1.p.x*h_1.v.z + h_1.p.z*h_1.v.x),

	(h_0.p.x*h_0.v.y - h_0.p.y*h_0.v.x - h_2.p.x*h_2.v.y + h_2.p.y*h_2.v.x),
	(h_0.p.x*h_0.v.z - h_0.p.z*h_0.v.x - h_2.p.x*h_2.v.z + h_2.p.z*h_2.v.x),

	(h_0.p.x*h_0.v.y - h_0.p.y*h_0.v.x - h_3.p.x*h_3.v.y + h_3.p.y*h_3.v.x),
	(h_0.p.x*h_0.v.z - h_0.p.z*h_0.v.x - h_3.p.x*h_3.v.z + h_3.p.z*h_3.v.x),
]

result = A \ b

println(result[1] + result[2] + result[3])
