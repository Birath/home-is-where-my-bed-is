extends StaticBody2D

var obstacles = {
	"thingy" : [[Rect2(0, 0, 8, 8), Color("00FFFF")]]
}

var width = 4
var height = 4
var obstacle_bounds = Rect2(0, 0, width, height)

var displacement;
var obstacle_type;

func _ready():
	# Pick random obstacle
	obstacle_type = obstacles.keys()[randi()%obstacles.size()]

	displacement = obstacle_bounds.size / 2
	$ObstacleShape.shape.extents = displacement

func _draw():
	for shape in obstacles[obstacle_type]:
		shape[0].position -= displacement
		draw_rect(shape[0], shape[1], true)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
