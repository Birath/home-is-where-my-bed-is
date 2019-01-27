extends KinematicBody2D

export (int) var speed = 50;

var velocity = Vector2()
var moving = false

var allow_input = true

func _ready():
	pass

func get_input():
	if not allow_input:
		return
	velocity = Vector2()
	if Input.is_action_pressed('player_up'):
		velocity.y -= 1
	if Input.is_action_pressed('player_down'):
		velocity.y += 1
	if Input.is_action_pressed('player_left'):
		velocity.x -= 1
	if Input.is_action_pressed('player_right'):
		velocity.x += 1
	velocity = velocity.normalized() * speed

	if Input.is_action_just_pressed('player_interact'):
		var closest_body
		var closest_distance = -1
		for body in $InteractArea.get_overlapping_bodies():
			if body.is_in_group("npc"):
				if closest_body == null or position.distance_to(body.position) < closest_distance:
					closest_body = body
					closest_distance = position.distance_to(body.position)
		if closest_body != null:
			closest_body.interact_with()

		for area in $InteractArea.get_overlapping_areas():
			if area.is_in_group("bed"):
				hide_player()
				print("You won!")
				get_parent().get_node("Timer").set_paused(true)
				get_parent().get_node("Hud").show_game_won()

func _physics_process(delta):
	get_input()
	moving = velocity.length() > speed / 2
	if moving:
		rotation = velocity.angle() - PI/2
	move_and_slide(velocity)


func _process(delta):
	pass

func get_rekt():
	hide_player()
	print("I am fucking dead ")
	get_parent().get_node("Timer").set_paused(true)
	get_parent().get_node("Hud").show_game_over()

func hide_player():
	allow_input = false
	$PlayerShape.disabled = true
	self.visible = false
	velocity = Vector2(0, 0)
	