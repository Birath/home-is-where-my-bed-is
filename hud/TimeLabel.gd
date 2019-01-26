extends Label

onready var timer = get_node("/root/Game/Timer")

func _ready():
	pass

func _process(delta):
	text = String(int(timer.time_left))