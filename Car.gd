extends StaticBody2D

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

var prev_direction

export (int) var speed = 25
onready var map = get_parent().map
var direction = Vector2()
var current_node
var target_node
var target_pos

const RIGHT = Vector2(1, 0)
const LEFT = Vector2(-1, 0)
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)

func _ready():
	set_target_node()
	pass

func init(spawn_node, car_type):
	self.current_node = spawn_node
	self.car_type = car_type;
	displacement = cars[car_type][0][0].size / 2
	$CarShape.shape.extents = displacement
	color_scheme = car_colors[randi()%car_colors.size()]
	flip_colors = bool(randi()%2)
	
func change_target(exlude_index):
	var neighbour = map.path_connected_nodes(current_node)
	var i = randi() % neighbour.size()
	while(i == exlude_index):
		i = randi() % neighbour.size()
	target_node = neighbour[i]
	var target_x = map.path_x(target_node)
	var target_y = map.path_y(target_node)
	set_target_pos(neighbour, target_x, target_y)

func set_target_node():
	var neighbours = map.path_connected_nodes(current_node)
	if neighbours.size() == 0:
		self.queue_free()
		return
	var i = randi() % neighbours.size()
	target_node = neighbours[i]
	var target_x = map.path_x(target_node)
	var target_y = map.path_y(target_node)
	prev_direction = direction
	set_target_pos(neighbours, target_x, target_y, i)

func set_target_pos(neighbours, target_x, target_y, i = null):
	if target_x > map.path_x(current_node):
		if prev_direction == LEFT and neighbours.size() > 1:
			change_target(i)
			return
		direction = RIGHT
		target_pos = Vector2(position.x + map.GRID_SIZE, position.y)
	elif target_x < map.path_x(current_node):
		if prev_direction == RIGHT and neighbours.size() > 1:
			change_target(i)
			return
		direction = LEFT
		target_pos = Vector2(position.x - map.GRID_SIZE , position.y)
	elif target_y > map.path_y(current_node):
		if prev_direction == UP and neighbours.size() > 1:
			change_target(i)
			return
		direction = DOWN
		target_pos = Vector2(position.x, position.y + map.GRID_SIZE)
	else:
		if prev_direction == DOWN and neighbours.size() > 1:
			change_target(i)
			return
		direction = UP
		target_pos = Vector2(position.x, round(position.y - map.GRID_SIZE))

func _draw():
	for shape in cars[car_type]:
		shape[0].position -= displacement
		draw_rect(shape[0], color_scheme[int(shape[1] && flip_colors)], true)

func _physics_process(delta):
	position += direction * speed * delta

func _process(delta):
	rotation = direction.angle() + PI / 2
	current_node = current_node()
	if position.distance_to(target_pos) < 0.1:
		set_target_node()

func current_node():
	return map.path_index(int(round(position.x / map.GRID_SIZE)), int(round(position.y / map.GRID_SIZE)))


func _on_CarArea_body_entered(body):
	if body.is_in_group("player"):
		body.get_rekt()