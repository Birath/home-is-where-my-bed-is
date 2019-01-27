extends Node
export (PackedScene) var npc
export (float) var spawn_radius

onready var map = get_parent().get_node("Map")
onready var player = get_parent().get_node("Player")
var player_grid = Vector2(0, 0)
var spawn_grids = []

enum {
	HORIZONTAL,
	VERTICAL
}

enum {
	NORTH_WEST,
	NORTH_EAST,
	SOUTH_WEST,
	SOUTH_EAST	
}

func _ready():
	spawn_radius *= map.GRID_SIZE
	player_grid = get_player_grid()
	_on_spawn_timer_timeout()

func get_player_grid():
	var x = int(round(player.position.x)) / int(map.GRID_SIZE)
	var y = int(round(player.position.y)) / int(map.GRID_SIZE)
	return Vector2(x,y)

func shuffle_list(list):
    var shuffled_list = [] 
    var index_list = range(list.size())
    for i in range(list.size()):
        var x = randi() % index_list.size()
        shuffled_list.append(list[index_list[x]])
        index_list.remove(x)
    return shuffled_list

func spawn_npcs(grid_indexes):
	var ai
	for grid in grid_indexes:
		var avaliable_directions = shuffle_list([NORTH_WEST, NORTH_EAST, SOUTH_WEST, SOUTH_EAST])
		for i in range(randi() % 3 + 1):
			ai = npc.instance()
			ai.init(grid)
			match avaliable_directions.front():
				NORTH_WEST:
					ai.position.x = map.path_x(grid) * map.GRID_SIZE + map.ROAD_WIDTH + map.SIDEWALK_WIDTH / 2 
					ai.position.y = map.path_y(grid) * map.GRID_SIZE + map.ROAD_WIDTH + map.SIDEWALK_WIDTH / 2
				NORTH_EAST:
					ai.position.x = map.path_x(grid) * map.GRID_SIZE - map.ROAD_WIDTH - map.SIDEWALK_WIDTH / 2
					ai.position.y = map.path_y(grid) * map.GRID_SIZE + map.ROAD_WIDTH + map.SIDEWALK_WIDTH / 2
				SOUTH_WEST:
					ai.position.x = map.path_x(grid) * map.GRID_SIZE + map.ROAD_WIDTH + map.SIDEWALK_WIDTH / 2 
					ai.position.y = map.path_y(grid) * map.GRID_SIZE - map.ROAD_WIDTH - map.SIDEWALK_WIDTH / 2				
				SOUTH_EAST:					
					ai.position.x = map.path_x(grid) * map.GRID_SIZE - map.ROAD_WIDTH - map.SIDEWALK_WIDTH / 2 
					ai.position.y = map.path_y(grid) * map.GRID_SIZE - map.ROAD_WIDTH - map.SIDEWALK_WIDTH / 2				
			add_child(ai)
			avaliable_directions.pop_front()
			
func _physics_process(delta):
	if spawn_grids.size() > 0:
		spawn_npcs(spawn_grids)
		spawn_grids = []

	for ai in get_tree().get_nodes_in_group("walking_npc"):
		if ai.position.distance_to(player.position) >= 200:
			ai.queue_free()

func _on_spawn_timer_timeout():
	for grid in range(map.path_grid.size()):
		var coords = map.path_coords(grid)
		if player.position.distance_to(coords * map.GRID_SIZE) < spawn_radius:
			spawn_grids.append(grid)
