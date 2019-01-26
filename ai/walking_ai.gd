extends KinematicBody2D

onready var map = get_parent().map
var sees_player = false
var player_body
var target_rotation

var current_node
var target_node
var target_pos

const RIGHT = Vector2(1, 0)
const LEFT = Vector2(-1, 0)
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
var direction
var prev_direction
var speed = 10

func init(spawn_node):
	self.current_node = spawn_node

func _draw():
	var shoulder_color = Color(randf(), randf(), randf(), 1)
	var shoulder = Rect2(-1.25, -0.375, 2.5, 0.75)
	
	var head_color = shoulder_color.contrasted()
	var head = Rect2(-0.5, -0.5, 1, 1)
	
	draw_rect(shoulder, shoulder_color, true)
	draw_rect(head, head_color, true)

func _ready():
	set_target_node()

func set_target_node():
	var neighbour = map.path_connected_nodes(current_node)
	if neighbour.size() == 0:
		self.queue_free()
		return
	target_node = neighbour[randi() % neighbour.size()]
	var target_x = map.path_x(target_node)
	var target_y = map.path_y(target_node)
	prev_direction = direction
	if prev_direction == RIGHT:
		pass
		
	if target_x > map.path_x(current_node):
		direction = RIGHT
		target_pos = Vector2(position.x + map.GRID_SIZE, position.y)
		print(target_pos)
	elif target_x < map.path_x(current_node):
		direction = LEFT
		target_pos = Vector2(position.x - map.GRID_SIZE , position.y)
	elif target_y > map.path_y(current_node):
		direction = DOWN
		target_pos = Vector2(position.x, position.y + map.GRID_SIZE)
	else:
		direction = UP
		target_pos = Vector2(position.x, position.y - map.GRID_SIZE)		
	
func _process(delta):
	current_node = current_node()
	if position.distance_to(target_pos) < 0.1:
		set_target_node()

func _physics_process(delta):
	if sees_player:
		rotation = lerp_angle(rotation, position.angle_to_point(player_body.position) + PI/2, delta*5)
	else:
		if direction != null:
			move_and_slide(direction*speed)

func current_node():
	var x = 0
	var y = 0
	match direction:
		RIGHT:
			x = position.x + map.SIDEWALK_WIDTH / 2 + map.ROAD_WIDTH
			if prev_direction == UP:
				y = position.y - map.SIDEWALK_WIDTH / 2 - map.ROAD_WIDTH
			elif prev_direction == DOWN:
				y = position.y + map.SIDEWALK_WIDTH / 2 + map.ROAD_WIDTH	
		LEFT:
			x = position.x - map.SIDEWALK_WIDTH / 2 - map.ROAD_WIDTH
			if prev_direction == UP:
				y = position.y - map.SIDEWALK_WIDTH / 2 - map.ROAD_WIDTH
			elif prev_direction == DOWN:
				y = position.y + map.SIDEWALK_WIDTH / 2 + map.ROAD_WIDTH
		UP:
			if prev_direction == RIGHT:
				x = position.x + map.SIDEWALK_WIDTH / 2 + map.ROAD_WIDTH
			elif prev_direction == LEFT:
				x = position.x - map.SIDEWALK_WIDTH / 2 - map.ROAD_WIDTH 
			y = position.y - map.SIDEWALK_WIDTH / 2 - map.ROAD_WIDTH
		DOWN:
			if prev_direction == RIGHT:
				x = position.x + map.SIDEWALK_WIDTH / 2 + map.ROAD_WIDTH
			elif prev_direction == LEFT:
				x = position.x - map.SIDEWALK_WIDTH / 2 - map.ROAD_WIDTH 
			y = position.y + map.SIDEWALK_WIDTH / 2 + map.ROAD_WIDTH
	return map.path_index(int(round(x)) / int(map.GRID_SIZE), int(round(y)) / int(map.GRID_SIZE))

static func lerp_angle(a, b, t):
	if abs(a-b) >= PI:
		if a > b:
			a = normalize_angle(a) - 2.0 * PI
		else:
			b = normalize_angle(b) - 2.0 * PI
	return lerp(a, b, t)

func interact_with():
	print("Interacted!")

static func normalize_angle(x):
	return fposmod(x + PI, 2.0*PI) - PI

func _on_vision_range_body_entered(body):
	if body.is_in_group("player"):
		player_body = body
		sees_player = true
		
func _on_vision_range_body_exited(body):
	if body.is_in_group("player"):
		player_body = body
		sees_player = false
