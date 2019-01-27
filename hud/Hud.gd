extends CanvasLayer

func _ready():
	$ReplayButton.hide()
	$MenuButton.hide()
	$GameOverLabel.hide()
	$GameWonLabel.hide()

func show_game_won():
	$Victory.playing = true
	$GameWonLabel.text += String(int(get_parent().get_node("Timer").time_left))
	$GameWonLabel.show()
	game_end()

func show_game_over():
	$Defeat.playing = true
	$GameOverLabel.show()
	game_end()
	
func game_end():
	$Music.playing = false
	$ReplayButton.show()
	$MenuButton.show()
	
func _on_ReplayButton_pressed():
	get_tree().change_scene("res://MainScene.tscn")

func _on_MenuButton_pressed():
	get_tree().change_scene("res://MenuScene.tscn")
