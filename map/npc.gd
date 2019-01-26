extends Node
export (PackedScene) var npc

onready var map = get_parent().get_node("Map")
onready var player = get_parent().get_node("Player")
var player_grid = Vector2(0, 0)

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
	#player_grid = get_player_grid()
	player_grid = Vector2(2,2)
	
	var right_corner = Vector2(player_grid.x - 2, player_grid.y - 2)
	var spawn_grids = []
	for row in range(right_corner.y, right_corner.y+5):
		for col in range(right_corner.x, right_corner.x+5):
			var index = map.path_index(col, row)
			if index != -1:
				spawn_grids.append(index)
	spawn_npcs(spawn_grids)
	#spawn_npcs([0])


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
		for i in range(randi() % 3):
		#for i in range(1):
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
			
func spawn_infront_of_player(node, offset, direction):
	var spawn_nodes = []
	if direction == HORIZONTAL:
		for y in range(
		  clamp(node.y-abs(offset), 0, map.HEIGHT+1), 
		  clamp(node.y+abs(offset), 0, map.HEIGHT+1)
		):
			spawn_nodes.append(map.path_index(int(node.x+offset), int(y)))
	if direction == VERTICAL:
		for x in range(
		  clamp(node.x-abs(offset), 0, map.WIDTH+1), 
		  clamp(node.x+abs(offset), 0, map.WIDTH+1)
		):
			spawn_nodes.append(map.path_index(int(x), int(node.y+offset)))
	if spawn_nodes.size() > 0:
		print("Spawned ", spawn_nodes.size(), " npcs")
		spawn_npcs(spawn_nodes)
		
func _physics_process(delta):
	var cur_player_grid = get_player_grid()
	if cur_player_grid.x > player_grid.x:
		spawn_infront_of_player(cur_player_grid, 1, HORIZONTAL)
	elif cur_player_grid.x < player_grid.x:
		spawn_infront_of_player(cur_player_grid, -1, HORIZONTAL)
	elif cur_player_grid.y > player_grid.y:
		spawn_infront_of_player(cur_player_grid, 1, VERTICAL)
	elif cur_player_grid.y < player_grid.y:
		spawn_infront_of_player(cur_player_grid, -1, VERTICAL)
	
		
	player_grid = cur_player_grid
	for ai in get_tree().get_nodes_in_group("npc"):
		var ai_node = Vector2(map.path_x(ai.current_node), map.path_y(ai.current_node))
		if ai_node.distance_to(player_grid) >= 2.5:
			ai.queue_free()
