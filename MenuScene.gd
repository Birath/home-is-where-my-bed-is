extends Node2D

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _on_PlayButton_pressed():
		get_tree().change_scene("res://MainScene.tscn")
