extends KinematicBody2D

export (int) var speed = 50;

var velocity = Vector2()
var moving = false

func _ready():
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
				print("You won!")

func _physics_process(delta):
	get_input()
	moving = velocity.length() > speed / 2
	if moving:
		rotation = velocity.angle() - PI/2
	move_and_slide(velocity)


func _process(delta):
	#update()
	pass
	
func get_rekt():
	print("I am fucking dead ")
