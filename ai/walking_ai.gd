extends KinematicBody2D

onready var map = get_parent().map
var sees_player = false
var player_body
var draw_speech_bubble = false

var current_node
var target_node
var target_pos

const RIGHT = Vector2(1, 0)
const LEFT = Vector2(-1, 0)
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
var direction
var prev_direction
var speed = 20

func init(spawn_node):
	self.current_node = spawn_node

func _draw():
	var shoulder_color = Color(randf(), randf(), randf(), 1)
	var shoulder = Rect2(-1.25, -0.375, 2.5, 0.75)
	
	var head_color = shoulder_color.contrasted()
	var head = Rect2(-0.5, -0.5, 1, 1)
	
	draw_rect(shoulder, shoulder_color, true)
	draw_rect(head, head_color, true)
	if draw_speech_bubble:
		speech_bubble()

func speech_bubble():
	var corner_points = 10
	var corner_radius = 0.3
	var x = 1
	var y = 1
	var width = 3
	var height = 2
	
	var points = PoolVector2Array()
	
	for i in range(corner_points+1):
		var angle_point = i * PI/2 / corner_points - PI/2
		points.push_back(Vector2(width-corner_radius + x, corner_radius + y) + Vector2(cos(angle_point), sin(angle_point)) * corner_radius)
	
	for i in range(corner_points+1):
		var angle_point = PI/2 + i * PI/2 / corner_points - PI/2
		points.push_back(Vector2(width-corner_radius + x, height-corner_radius + y) + Vector2(cos(angle_point), sin(angle_point)) * corner_radius)
	
	for i in range(corner_points+1):
		var angle_point = PI + i * PI/2 / corner_points - PI/2
		points.push_back(Vector2(corner_radius + x, height-corner_radius + y) + Vector2(cos(angle_point), sin(angle_point)) * corner_radius)
	# 
	"""
	for i in range(corner_points+1):
		var angle_point = 3*PI/2 + i * PI/2 / corner_points - PI/2
		points.push_back(Vector2(corner_radius + x, corner_radius + y) + Vector2(cos(angle_point), sin(angle_point)) * corner_radius)
	"""
	points.push_back(Vector2(x, y - 0.5))
	points.push_back(Vector2(x + 0.5, y))
	draw_polygon(points, PoolColorArray([Color(1,1,1)]))

func _ready():
	randomize()
	set_target_node()

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
	return map.path_index(int(round(position.x / map.GRID_SIZE)), int(round(position.y / map.GRID_SIZE)))

static func lerp_angle(a, b, t):
	if abs(a-b) >= PI:
		if a > b:
			a = normalize_angle(a) - 2.0 * PI
		else:
			b = normalize_angle(b) - 2.0 * PI
	return lerp(a, b, t)


	
func interact_with():
	print("Interacted with")
	draw_speech_bubble = true
	update()

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
