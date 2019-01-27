extends "res://ai/walking_ai.gd"


func _on_ready():
	pass


func _on_process():
	if bed == null:
		bed = get_node("/root/Game").bed
	pass

func _on_p_process(delta):
	if sees_player:
		moving = false
		rotation = lerp_angle(rotation, position.angle_to_point(player_body.position) + PI/2, delta*5)
		return


func _on_vision_range_body_entered(body):
	if body.is_in_group("player"):
		player_body = body
		sees_player = true

func _on_vision_range_body_exited(body):
	if body.is_in_group("player"):
		player_body = body
		sees_player = false
		if bubble != null:
			bubble.queue_free()
			bubble = null
