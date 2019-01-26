extends AudioStreamPlayer


func _process(delta):
	if Input.is_action_just_pressed("play_music"):
		playing = not playing
