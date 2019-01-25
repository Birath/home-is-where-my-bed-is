extends Node2D


var path_grid;
var road_grid

const WIDTH = 10;
const HEIGHT = 10;

const GRID_SIZE = 50.0;

enum Direction {
	RIGHT,
	UP,
	LEFT,
	DOWN
}

func _ready():
	### CREATE PATH GRID ###
	path_grid = []
	path_grid.resize((WIDTH + 1) * (HEIGHT + 1))
	for i in range(path_grid.size()):
		path_grid[i] = [path_x(i) != (WIDTH + 1), path_y(i) != 0, path_x(i) != 0, path_y(i) != (HEIGHT + 1)]
	
	### CREATE ROAD GRID ###
	road_grid = []
	road_grid.resize(2*WIDTH*HEIGHT + WIDTH + HEIGHT)
	for road in road_grid:
		road = true
	return

static func path_index(x, y):
	return x + y * (WIDTH + 1);

static func path_x(index):
	return index % (WIDTH + 1)

static func path_y(index):
	return index / (WIDTH + 1)

static func path_coords(index):
	return Vector2(path_x(index), path_y(index))

static func path_connected_nodes(index):
	var x = path_x(index)
	var y = path_y(index)
	var connected = []
	if path_grid[index][RIGHT]:
		connected.append(path_index(y, x + 1))
	if path_grid[index][UP]:
		connected.append(path_index(y - 1, x))
	if path_grid[index][LEFT]:
		connected.append(path_index(y, x - 1))
	if path_grid[index][DOWN]:
		connected.append(path_index(y + 1, x))
	return connected


static func road_index(x, y, col = false):
	var index = 0
	if col:
		return WIDTH * (HEIGHT + 1) + x * HEIGHT + y
	else:
		return x + y * WIDTH
	return index

static func road_x(index, col = false):
	if col:
		return (index -  WIDTH * (HEIGHT + 1)) / HEIGHT
	return index % WIDTH

static func road_y(index, col = false):
	if col:
		return (index -  WIDTH * (HEIGHT + 1)) % HEIGHT
	return index / WIDTH

static func get_road(x, y, direction):
	match(direction):
		UP:
			return
		DOWN:
			return
		LEFT:
			return
		RIGHT:
			return
	return null










