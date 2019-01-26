extends KinematicBody2D

export (int) var speed = 50;

var velocity = Vector2()

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
	
	if velocity.length() > 0:
		if !$AnimationPlayer.is_playing():
			$AnimationPlayer.play("Walking")
	else:
		$AnimationPlayer.stop()
	
	if Input.is_action_just_pressed('player_interact'):
		for body in $InteractArea.get_overlapping_bodies():
			if body.is_in_group("npc"):
				body.interact_with()
				break
		for area in $InteractArea.get_overlapping_areas():
			if area.is_in_group("bed"):
				print("You won!")

func _physics_process(delta):
	get_input()
	move_and_slide(velocity)


func _process(delta):
	#update()
	pass

func _draw():
	var shoulder_color = Color(randf(), randf(), randf(), 1)
	var shoulder = Rect2(-1.25, -0.375, 2.5, 0.75)
	
	var head_color = shoulder_color.contrasted()
	var head = Rect2(-0.5, -0.5, 1, 1)
	
	draw_rect(shoulder, shoulder_color, true)
	draw_rect(head, head_color, true)