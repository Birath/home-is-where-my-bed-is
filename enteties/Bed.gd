extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _draw():
	var bed = Rect2(-2.25, -3.5, 4.5, 7)
	var beddings = Rect2(-2.125, -3.375, 4.25, 6.875)
	var pillow = Rect2(-1.25, 2.5, 2.5, 1)
	draw_rect(bed, Color("#8B4513"), true)
	draw_rect(beddings, Color(1,1,1), true)
	draw_rect(pillow, Color("#5d9cf4"), true)
	
	
func _ready():
	position.x = randi() % 400
	position.y = randi() % -400
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
