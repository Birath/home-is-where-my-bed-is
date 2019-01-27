extends Node2D

func _ready():
	pass

func _on_PlayButton_pressed():
	get_tree().change_scene("res://MainScene.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()