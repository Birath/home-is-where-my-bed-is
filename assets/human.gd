extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _draw():
	var shoulder_color = Color(randf(), randf(), randf(), 1)
	var shoulder = Rect2(-1.25, -0.375, 2.5, 0.75)
	
	var head_color = shoulder_color.contrasted()
	var head = Rect2(-0.5, -0.5, 1, 1)
	
	draw_rect(shoulder, shoulder_color, true)
	draw_rect(head, head_color, true)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
func _physics_process(delta):
	get_parent().velocity

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
