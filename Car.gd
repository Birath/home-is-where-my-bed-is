extends Area2D

# car is defined as [Base, Other parts]
var cars = {
	"sedan"		: [Rect2(0, 0, 6, 12), Rect2(0, 3.5, 6, 6), Rect2(1, -0.5, 1, 0.5), Rect2(4, -0.5, 1, 0.5)],
	"hatchback"	: [Rect2(0, 0, 6, 12), Rect2(0, 3.5, 6, 8.5), Rect2(1, -0.5, 1, 0.5), Rect2(4, -0.5, 1, 0.5)],
	"truck"		: [Rect2(0, 0, 6, 18), Rect2(-1, 4, 8, 14), Rect2(1, -0.5, 1, 0.5), Rect2(4, -0.5, 1, 0.5)],
	"bus"		: [Rect2(0, 0, 6, 18), Rect2(1, -0.5, 1, 0.5), Rect2(4, -0.5, 1, 0.5)],
	"player"	: [Rect2(0, 0, 2.5, 0.75), Rect2(0.75, -0.125, 1, 1)]
}

var displacement;
var car_type;

func _ready():
	init("sedan")

func init(car_type):
	self.car_type = car_type;
	displacement = cars[car_type][0].size / 2
	$CollisionShape2D.shape.extents = displacement

func _draw():
	for shape in cars[car_type]:
		shape.position -= displacement
		draw_rect(shape, Color("0000FF"), true)
	
	draw_rect(cars["player"][0], Color("FF00FF"), true)
	draw_rect(cars["player"][1], Color("FF00FF"), true)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass