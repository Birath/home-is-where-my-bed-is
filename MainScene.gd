extends Node2D

var game_time = 10

func _ready():
	init()

func init():
	$Timer.wait_time = game_time
	$Timer.start()

func _on_Timer_timeout():
	print("Game overrrrrr")
	get_node("Hud").show_game_over()
