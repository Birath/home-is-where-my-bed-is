extends KinematicBody2D

export (int) var speed = 300;

var velocity = Vector2()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func get_input():
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
	
	if Input.is_action_pressed('player_interact'):
		for body in $InteractArea.get_overlapping_bodies():
			if body.is_in_group("npc"):
				body.interact_with()

func _process(delta):
	get_input()
	move_and_slide(velocity)