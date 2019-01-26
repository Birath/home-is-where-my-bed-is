extends Node2D


const WIDTH = 10
const HEIGHT = 10

const GRID_SIZE = 100.0

const ROAD_WIDTH = 10.0
const ROAD_COLOR = Color(0.2, 0.2, 0.2)

const SIDEWALK_WIDTH = 6.0
const SIDEWALK_COLOR = Color(0.4, 0.4, 0.4)


var path_grid
var road_grid


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
	for index in range(road_grid.size()):
		road_grid[index] = true
	
	road_grid[road_index(2, 1, true)] = false
	
	update()
	return

func _draw():
	for index in range(road_grid.size()):
		if road_grid[index]:
			draw_road(road_x(index), road_y(index), road_direction(index), true)
	for index in range(road_grid.size()):
		if road_grid[index]:
			draw_road(road_x(index), road_y(index), road_direction(index))

func draw_road(x, y, col = false, sidewalk = false):
	if col:
		var rect = Rect2(x * GRID_SIZE - ROAD_WIDTH, y * GRID_SIZE, ROAD_WIDTH * 2, GRID_SIZE)
		if not sidewalk:
			self.draw_rect(rect, ROAD_COLOR, true)
		else:
			rect.position.x = x * GRID_SIZE - ROAD_WIDTH - SIDEWALK_WIDTH
			rect.size.x = SIDEWALK_WIDTH
			self.draw_rect(rect, SIDEWALK_COLOR, true)
			rect.position.x =  x * GRID_SIZE + ROAD_WIDTH
			self.draw_rect(rect, SIDEWALK_COLOR, true)
	else:
		var rect = Rect2(x * GRID_SIZE, y * GRID_SIZE - ROAD_WIDTH, GRID_SIZE, ROAD_WIDTH * 2)
		if not sidewalk:
			self.draw_rect(rect, ROAD_COLOR, true)
		else:
			rect.position.y = y * GRID_SIZE - ROAD_WIDTH - SIDEWALK_WIDTH
			rect.size.y = SIDEWALK_WIDTH
			self.draw_rect(rect, SIDEWALK_COLOR, true)
			rect.position.y =  y * GRID_SIZE + ROAD_WIDTH
			self.draw_rect(rect, SIDEWALK_COLOR, true)

func path_index(x, y):
	return x + y * (WIDTH + 1);

func path_x(index):
	return index % (WIDTH + 1)

func path_y(index):
	return index / (WIDTH + 1)

func path_coords(index):
	return Vector2(path_x(index), path_y(index))

func path_connected_nodes(index):
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


func road_index(x, y, col = false):
	var index = 0
	if col:
		return WIDTH * (HEIGHT + 1) + x * HEIGHT + y
	else:
		return x + y * WIDTH
	return index

func road_x(index):
	if road_direction(index):
		return (index -  WIDTH * (HEIGHT + 1)) / HEIGHT
	return index % WIDTH

func road_y(index):
	if road_direction(index):
		return (index -  WIDTH * (HEIGHT + 1)) % HEIGHT
	return index / WIDTH

# True if col, false if row
func road_direction(index):
	return index >= WIDTH * (HEIGHT + 1)

func get_road(x, y, direction):
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










