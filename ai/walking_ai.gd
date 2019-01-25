extends KinematicBody2D

onready var rotate = get_node("rotate")

var speed = 0

var sees_player = false

var player_body
var target_rotation
var start_rotation

func init(speed):
	self.speed = speed

func _draw():
	var shoulder_color = Color(randf(), randf(), randf(), 1)
	var shoulder = Rect2(-1.25, -0.375, 2.5, 0.75)
	
	var head_color = shoulder_color.contrasted()
	var head = Rect2(-0.5, -0.5, 1, 1)
	
	draw_rect(shoulder, shoulder_color, true)
	draw_rect(head, head_color, true)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	pass

func _process(delta):
	if sees_player:
		var rot = lerp_angle(rotation, target_rotation, delta*5)
		rotation = rot
		
			#TODO something funny
		"""		
		if not rotate.is_active():
			rotate.interpolate_property(self, 'rotation', 
			rotation, rotation + position.angle_to_point(player_body.position),
			0.5, Tween.TRANS_QUAD, Tween.EASE_IN
			)
			rotate.start()
		"""
		
			
	else:
		move_and_slide(Vector2(0, -speed))
	
static func lerp_angle(a, b, t):
	if abs(a-b) >= PI:
		if a > b:
			a = normalize_angle(a) - 2.0 * PI
		else:
			b = normalize_angle(b) - 2.0 * PI
	return lerp(a, b, t)


static func normalize_angle(x):
	return fposmod(x + PI, 2.0*PI) - PI

func _on_vision_range_body_entered(body):
	if body.is_in_group("Player"):
		player_body = body
		sees_player = true
		target_rotation = rotation + position.angle_to_point(player_body.position) - PI/2




func _on_vision_range_body_exited(body):
	if body.is_in_group("Player"):
		player_body = body
		sees_player = false
