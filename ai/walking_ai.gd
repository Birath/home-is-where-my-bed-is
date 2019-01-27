extends KinematicBody2D

onready var map = get_node("/root/Game/Map")
onready var bed = get_node("/root/Game").bed
export (PackedScene) var speech_bubble
var bubble

var sees_player = false
var player_body
var draw_speech_bubble = false
var interacted_with = false
var answer

var current_node
var target_node
var target_pos

var avoid_obstacle = false
var avoid_direction
var avoid_target

const RIGHT = Vector2(1, 0)
const LEFT = Vector2(-1, 0)
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
var velocity
var prev_direction
var speed = 10
var moving = false

func init(spawn_node):
	self.current_node = spawn_node

func _ready():
	_on_ready()

func _on_ready():
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
	prev_direction = velocity
	set_target_pos(neighbours, target_x, target_y, i)

func set_target_pos(neighbours, target_x, target_y, i = null):
	if target_x > map.path_x(current_node):
		if prev_direction == LEFT and neighbours.size() > 1:
			change_target(i)
			return
		velocity = RIGHT
		target_pos = Vector2(position.x + map.GRID_SIZE, position.y)
	elif target_x < map.path_x(current_node):
		if prev_direction == RIGHT and neighbours.size() > 1:
			change_target(i)
			return
		velocity = LEFT
		target_pos = Vector2(position.x - map.GRID_SIZE , position.y)
	elif target_y > map.path_y(current_node):
		if prev_direction == UP and neighbours.size() > 1:
			change_target(i)
			return
		velocity = DOWN
		target_pos = Vector2(position.x, position.y + map.GRID_SIZE)
	else:
		if prev_direction == DOWN and neighbours.size() > 1:
			change_target(i)
			return
		velocity = UP
		target_pos = Vector2(position.x, round(position.y - map.GRID_SIZE))
	
func _process(delta):
	_on_process()
	
func _on_process():
	current_node = current_node()
	if position.distance_to(target_pos) < 0.1:
		set_target_node()

func _physics_process(delta):
	_on_p_process(delta)

func _on_p_process(delta):
	if sees_player:
		moving = false
		rotation = lerp_angle(rotation, position.angle_to_point(player_body.position) + PI/2, delta*5)
		return
	if avoid_obstacle:
		if position.distance_to(avoid_target) < 0.1:
			avoid_obstacle = false
		else:
			moving = true
			rotation = avoid_direction.angle() - PI / 2
			move_and_slide(avoid_direction * speed)
	else:
		if velocity != null:
			moving = true
			rotation = velocity.angle() - PI / 2
			move_and_slide(velocity*speed)

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
	if bubble != null:
		return
	if interacted_with:
		bubble = speech_bubble.instance()
		bubble.init(answer)
	else:
		var horizontal 
		var vertical
		bubble = speech_bubble.instance()
		if bed.global_position.x > global_position.x:
			horizontal = bubble.directions.RIGHT
		elif bed.global_position.x < global_position.x:
			horizontal = bubble.directions.LEFT
		if bed.global_position.y > global_position.y:
			vertical = bubble.directions.DOWN
		else:
			vertical = bubble.directions.UP 
		var rand_val = rand_range(0, 1) 
		if rand_val < 0.20:
			bubble.init(bubble.directions.NONE)
			answer = bubble.directions.NONE
		elif 0.20 <= rand_val and rand_val < 0.60:
			bubble.init(horizontal)
			answer = horizontal
		else:
			bubble.init(vertical)
			answer = vertical
		interacted_with = true
	bubble.position = position
	bubble.position.y -= 3
	bubble.rotate(PI)
	get_parent().add_child(bubble)
	$Oomph.playing = true

static func normalize_angle(x):
	return fposmod(x + PI, 2.0*PI) - PI

func get_avoid_direction():
	if velocity in [RIGHT, LEFT]:
		if position.y > map.path_y(target_node):
			avoid_direction = DOWN
			avoid_target = Vector2(position.x, position.y + map.ROAD_WIDTH * 2 + map.SIDEWALK_WIDTH)
			target_pos.y += map.ROAD_WIDTH * 2 + map.SIDEWALK_WIDTH
		else:
			avoid_direction = UP
			avoid_target = Vector2(position.x, position.y - map.ROAD_WIDTH * 2 - map.SIDEWALK_WIDTH)
			target_pos.y -= (map.ROAD_WIDTH * 2 + map.SIDEWALK_WIDTH)
			
	else:
		if position.x > map.path_x(target_node):
			avoid_target = Vector2(position.x - map.ROAD_WIDTH * 2 - map.SIDEWALK_WIDTH, position.y)
			target_pos.x -= (map.ROAD_WIDTH * 2 + map.SIDEWALK_WIDTH)
			avoid_direction = LEFT
		else:
			avoid_target = Vector2(position.x + map.ROAD_WIDTH * 2 + map.SIDEWALK_WIDTH, position.y)			
			target_pos.x += map.ROAD_WIDTH * 2 + map.SIDEWALK_WIDTH
			avoid_direction = RIGHT

func _on_vision_range_body_entered(body):
	if body.is_in_group("player"):
		player_body = body
		sees_player = true
	if body.is_in_group("obstacle"):
		get_avoid_direction()
		avoid_obstacle = true
		
func _on_vision_range_body_exited(body):
	if body.is_in_group("player"):
		player_body = body
		sees_player = false
		if bubble != null:
			bubble.queue_free()
			bubble = null