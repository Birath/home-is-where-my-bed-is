extends StaticBody2D

# Obstacle is 6x6
var obstacles = {
	#"thingy" : [[Rect2(0, 0, 8, 8), Color("00FFFF")]],
	"mannos_holos" : [],
	"barrier" : []
}

var width = 4
var height = 4
var obstacle_bounds = Rect2(0, 0, width, height)

var displacement;
var obstacle_type;

func _ready():
	# Pick random obstacle
	obstacle_type = obstacles.keys()[randi()%obstacles.size()]
	
	if obstacle_type == "mannos_holos":
		var hool = load("res://enteties/obstacles/Manhole.tscn").instance()
		self.add_child(hool)
		$ObstacleShape.shape = hool.get_child(0).shape
		return
		
	if obstacle_type == "barrier":
		var bar = load("res://enteties/obstacles/Barrier.tscn").instance()
		self.add_child(bar)
		$ObstacleShape.shape = hool.get_child(0).shape
		return

	displacement = obstacle_bounds.size / 2
	$ObstacleShape.shape.extents = displacement

func _draw():
	if obstacle_type == "mannos_holos" or obstacle_type == "barrier":
		return
	for shape in obstacles[obstacle_type]:
		shape[0].position -= displacement
		draw_rect(shape[0], shape[1], true)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
