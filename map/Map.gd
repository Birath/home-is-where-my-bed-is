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
	
	remove_road(road_index(0, 1))
	
	update()
	return

func _draw():
	for index in range(road_grid.size()):
		if road_grid[index]:
			draw_road(road_x(index), road_y(index), road_direction(index), true)
	for index in range(road_grid.size()):
		if road_grid[index]:
			draw_road(road_x(index), road_y(index), road_direction(index))

	for index in range(path_grid.size()):
		for dir in range(4):
			if path_grid[index][dir]:
				draw_path(index, dir)

	var label = Label.new()
	var font = label.get_font("")
	for index in range(path_grid.size()):
		draw_string(font, Vector2(path_x(index)*GRID_SIZE, path_y(index)*GRID_SIZE), str(index)) 
	label.free()
	return
	
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
	return

func draw_path(index, dir):
	var x = path_x(index) * GRID_SIZE
	var y = path_y(index) * GRID_SIZE
	var x2 = x + int(dir == RIGHT) * GRID_SIZE / 4 - int(dir == LEFT) * GRID_SIZE / 4
	var y2 = y + int(dir == DOWN) * GRID_SIZE / 4 - int(dir == UP) * GRID_SIZE / 4
	
	draw_line(Vector2(x, y), Vector2(x2, y2), Color(1, 0, 0))
	return

func path_index(x, y):
	return x + y * (WIDTH + 1)

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
		connected.append(path_index(x + 1, y))
	if path_grid[index][UP]:
		connected.append(path_index(x, y - 1))
	if path_grid[index][LEFT]:
		connected.append(path_index(x - 1, y))
	if path_grid[index][DOWN]:
		connected.append(path_index(x, y + 1))
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
			return road_index(x, y - 1, true)
		DOWN:
			return road_index(x, y, true)
		LEFT:
			return road_index(x - 1, y, false)
		RIGHT:
			return road_index(x, y, false)
	return -1

func remove_road(index, only_from_path = false):
	if not only_from_path:
		road_grid[index] = false
	
	var dir
	var x = road_x(index)
	var y = road_y(index)
	if road_direction(index): 
		dir = DOWN
	else:
		dir = RIGHT
	path_grid[path_index(x, y)][dir] = false
	path_grid[path_index(x + int(dir == RIGHT), y + int(dir == DOWN))][(dir + 2) % 4] = false






