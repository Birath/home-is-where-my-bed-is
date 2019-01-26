extends KinematicBody2D

# car is defined as [[Base, is_base_layer], [Other part, is_base_layer]]
var cars = {
	"sedan"		: [[Rect2(0, 0, 6, 12), true], [Rect2(0, 3.5, 6, 6), false], [Rect2(1, -0.5, 1, 0.5), true], [Rect2(4, -0.5, 1, 0.5), true]],
	"hatchback"	: [[Rect2(0, 0, 6, 12), true], [Rect2(0, 3.5, 6, 8.5), false], [Rect2(1, -0.5, 1, 0.5), true], [Rect2(4, -0.5, 1, 0.5), true]],
	"truck"		: [[Rect2(0, 0, 6, 18), true], [Rect2(-1, 4, 8, 14), false], [Rect2(1, -0.5, 1, 0.5), true], [Rect2(4, -0.5, 1, 0.5), true]],
	"bus"		: [[Rect2(0, 0, 6, 18), true], [Rect2(1, -0.5, 1, 0.5), true], [Rect2(4, -0.5, 1, 0.5), true]],
}

# Cars have two colors, we randomly pick from this list
var car_colors = [[Color("005A5B"), Color("008C72")], [Color("6C5B7B"), Color("C06C84")], [Color("8F1D2C"), Color("5A142A")]]

var displacement;
var car_type;
var color_scheme;
var flip_colors;

export (int) var speed = 25
onready var map = get_parent().map
var direction = Vector2()
var current_node
var target_node

const RIGHT = Vector2(1, 0)
const LEFT = Vector2(-1, 0)
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)

func _ready():
	pass
	set_target_node()

func init(spawn_node, car_type):
	print(spawn_node)
	self.current_node = spawn_node
	self.car_type = car_type;
	displacement = cars[car_type][0][0].size / 2
	$CarArea.get_node("CarShape").shape.extents = displacement
	color_scheme = car_colors[randi()%car_colors.size()]
	flip_colors = bool(randi()%2)
	
func set_target_node():
	var neighbour = map.path_connected_nodes(current_node)
	target_node = neighbour[randi() % neighbour.size()]
	var target_x = map.path_x(target_node)
	var target_y = map.path_y(target_node)
	
	
	
	if target_x > map.path_x(current_node):
		direction = RIGHT
	elif target_x < map.path_x(current_node):
		direction = LEFT
	elif target_y > map.path_y(current_node):
		direction = DOWN
	else:
		direction = UP

func _draw():
	for shape in cars[car_type]:
		shape[0].position -= displacement
		draw_rect(shape[0], color_scheme[int(shape[1] && flip_colors)], true)

func _physics_process(delta):
	move_and_slide(direction * speed)

func _process(delta):
	rotation = direction.angle() + PI / 2
	current_node = current_node()
	if current_node == target_node:
		print("Reached target")
		set_target_node()

func current_node():
	return map.path_index(int(round(position.x)) / int(map.GRID_SIZE), int(round(position.y)) / int(map.GRID_SIZE))