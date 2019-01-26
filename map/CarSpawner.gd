extends Node
export (PackedScene) var car

onready var map = get_parent().get_node("Map")
onready var player = get_parent().get_node("Player")
var player_grid = Vector2(0, 0)

func _ready():
	player_grid = Vector2(2,2)
	
	var right_corner = Vector2(player_grid.x - 2, player_grid.y - 2)
	var spawn_grids = []
	for row in range(right_corner.y, right_corner.y+5):
		for col in range(right_corner.x, right_corner.x+5):
			spawn_grids.append(map.path_index(col, row))
	spawn_cars(spawn_grids)
	
func get_player_grid():
	var x = int(round(player.position.x)) / int(map.GRID_SIZE)
	var y = int(round(player.position.y)) / int(map.GRID_SIZE)
	return Vector2(x,y)
	
func spawn_cars(grid_indexes):
	var ai
	for grid in grid_indexes:
		for i in range(0, randi() % 4):
			ai = car.instance()
			ai.init(grid, "sedan")
			add_child(ai)
			ai.position.x = map.path_x(grid) * map.GRID_SIZE
			ai.position.y = map.path_y(grid) * map.GRID_SIZE

func _physics_process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	var cur_player_grid = get_player_grid()
	if cur_player_grid.x > player_grid.x:
		print("Spawn x+2")
	elif cur_player_grid.x < player_grid.x:
		print("spawn x-2")
	elif cur_player_grid.y > player_grid.y:
		print("spawn y+2")
	elif cur_player_grid.y < player_grid.y:
		print("spawn y-2")
		
	player_grid = cur_player_grid
