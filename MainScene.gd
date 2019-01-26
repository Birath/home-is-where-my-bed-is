extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var game_time = 120

func _ready():
	init()

func init():
	$Timer.wait_time = game_time
	$Timer.start()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Timer_timeout():
	print("Game overrrrrr")
	get_parent().get_node("Timer").stop()
	get_parent().get_node("Hud").show_game_over()
