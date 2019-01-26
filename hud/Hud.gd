extends CanvasLayer

func _ready():
	$ReplayButton.hide()
	$GameOverLabel.hide()
	$GameWonLabel.hide()

func show_game_won():
	$GameWonLabel.text += String(int(get_parent().get_node("Timer").time_left))
	$GameWonLabel.show()
	$ReplayButton.show()

func show_game_over():
	$GameOverLabel.show()
	$ReplayButton.show()
	
func _on_ReplayButton_pressed():
	get_tree().change_scene("res://MainScene.tscn")