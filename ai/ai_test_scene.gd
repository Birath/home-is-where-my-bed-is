extends Node2D

export (PackedScene) var Ai
onready var map = get_node("Map")

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#randomize()
	#for i in range(0, 4):
		#var ai = Ai.instance()
		#add_child(ai)
		#ai.position = Vector2(randi() % 4, randi() % 4)
	
	var ai = Ai.instance()
	ai.init(5)
	add_child(ai)
	ai.position = Vector2(0, 15)
	
	ai = Ai.instance()
	ai.init(0)
	add_child(ai)
	ai.position = Vector2(12.5, -10)
	ai.add_to_group("Player")
		
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
