extends Node2D


const WIDTH = 5
const HEIGHT = 5

const GRID_SIZE = 100.0

const ROAD_WIDTH = 10.0
const ROAD_COLOR = Color(0.2, 0.2, 0.2)

const SIDEWALK_WIDTH = 6.0
const SIDEWALK_COLOR = Color(0.4, 0.4, 0.4)

const CROSSING_WIDTH = 1.3

const MARKING_LENGTH = 3
const MARKING_WIDTH = 0.8
const MARKING_COLOR = Color(0.9, 0.9, 0.9)

onready var building = preload("res://map/buildings/Building.gd")
onready var alley = preload("res://map/buildings/Alley.gd")

var path_grid
var road_grid
var building_grid

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
		path_grid[i] = [path_x(i) != (WIDTH), path_y(i) != 0, path_x(i) != 0, path_y(i) != (HEIGHT)]
	
	### CREATE ROAD GRID ###
	road_grid = []
	road_grid.resize(2 * WIDTH * HEIGHT + WIDTH + HEIGHT)
	for index in range(road_grid.size()):
		road_grid[index] = true
	
	### CREATE BUILDING GRID ###
	building_grid = []
	building_grid.resize(WIDTH * HEIGHT)
	for index in range(building_grid.size()):
		building_grid[index] = true
	
	
	
	var x = randi() % (WIDTH - 1) 
	var y = randi() % (HEIGHT - 1)
	building.new(self, "park", x, y)
	for index in range(building_grid.size()):
		if building_grid[index]:
			building.new(self, "small_house", building_x(index), building_y(index))
	
	alley.new(self, road_index(2, 1, false), true)
	
	update()
	return

func _draw():
	for index in range(road_grid.size()):
		if road_grid[index]:
			draw_road(road_x(index), road_y(index), road_direction(index))
	
	for index in range(path_grid.size()):
		draw_intersection(index)

	for index in range(path_grid.size()):
		for dir in range(4):
			if path_grid[index][dir]:
				draw_path(index, dir)

	var label = Label.new()
	var font = label.get_font("")
	for index in range(path_grid.size()):
		pass
		#draw_string(font, Vector2(path_x(index)*GRID_SIZE, path_y(index)*GRID_SIZE), str(index)) 
	label.free()
	return
	
func draw_road(x, y, col = false):
	if col:
		var rect = Rect2(x * GRID_SIZE - ROAD_WIDTH, y * GRID_SIZE + ROAD_WIDTH, ROAD_WIDTH * 2, GRID_SIZE - ROAD_WIDTH * 2)
		self.draw_rect(rect, ROAD_COLOR, true)
		rect.position.x = x * GRID_SIZE - ROAD_WIDTH - SIDEWALK_WIDTH
		rect.size.x = SIDEWALK_WIDTH
		self.draw_rect(rect, SIDEWALK_COLOR, true)
		rect.position.x =  x * GRID_SIZE + ROAD_WIDTH
		self.draw_rect(rect, SIDEWALK_COLOR, true)
		
		self.draw_markers(x * GRID_SIZE, y * GRID_SIZE + GRID_SIZE / 2, col)
	else:
		var rect = Rect2(x * GRID_SIZE + ROAD_WIDTH, y * GRID_SIZE - ROAD_WIDTH, GRID_SIZE - ROAD_WIDTH * 2, ROAD_WIDTH * 2)
		self.draw_rect(rect, ROAD_COLOR, true)
		rect.position.y = y * GRID_SIZE - ROAD_WIDTH - SIDEWALK_WIDTH
		rect.size.y = SIDEWALK_WIDTH
		self.draw_rect(rect, SIDEWALK_COLOR, true)
		rect.position.y =  y * GRID_SIZE + ROAD_WIDTH
		self.draw_rect(rect, SIDEWALK_COLOR, true)
		
		self.draw_markers(x * GRID_SIZE + GRID_SIZE / 2, y * GRID_SIZE, col)
	return

func draw_intersection(index):
	var x = path_x(index)
	var y = path_y(index)
	var rect = Rect2(x * GRID_SIZE - ROAD_WIDTH, y * GRID_SIZE - ROAD_WIDTH, ROAD_WIDTH * 2, ROAD_WIDTH * 2)
	self.draw_rect(rect, ROAD_COLOR, true)
	
	var offset = ROAD_WIDTH + SIDEWALK_WIDTH / 2
	
	var road_sides = [
		get_road(x, y, UP) != -1 and road_grid[get_road(x, y, UP)], 
		get_road(x, y, DOWN) != -1 and road_grid[get_road(x, y, DOWN)],
		get_road(x, y, LEFT) != -1 and road_grid[get_road(x, y, LEFT)],
		get_road(x, y, RIGHT) != -1 and road_grid[get_road(x, y, RIGHT)]
	]
	
	draw_sidewalk(x * GRID_SIZE, y * GRID_SIZE - offset, false, road_sides[0])
	draw_sidewalk(x * GRID_SIZE, y * GRID_SIZE + offset, false, road_sides[1])
	draw_sidewalk(x * GRID_SIZE - offset, y * GRID_SIZE, true, road_sides[2])
	draw_sidewalk(x * GRID_SIZE + offset, y * GRID_SIZE, true, road_sides[3])
	
	return

func draw_markers(x, y, col = false):
	var count = int((GRID_SIZE / 2 - ROAD_WIDTH - SIDEWALK_WIDTH) / MARKING_LENGTH)
	var current = 0
	if count % 2 == 0:
		current = -MARKING_LENGTH
	else:
		draw_marker(x, y, col)
		count -= 1
	for i in range(count / 2):
		current += MARKING_LENGTH * 2
		draw_marker(x + current * int(not col), y + current * int(col), col)
		draw_marker(x - current * int(not col) , y - current * int(col), col)
	return

func draw_marker(x, y, col):
	var rect
	if col:
		rect = Rect2(x - MARKING_WIDTH / 2, y - MARKING_LENGTH / 2, MARKING_WIDTH, MARKING_LENGTH)
	else:
		rect = Rect2(x - MARKING_LENGTH / 2, y - MARKING_WIDTH / 2, MARKING_LENGTH, MARKING_WIDTH)
	draw_rect(rect, MARKING_COLOR, true)
	return

func draw_sidewalk(x, y, col = false, road = false):
	var rect
	if col:
		rect = Rect2(x - SIDEWALK_WIDTH / 2, y - ROAD_WIDTH, SIDEWALK_WIDTH, ROAD_WIDTH * 2)
	else:
		rect = Rect2(x - ROAD_WIDTH, y - SIDEWALK_WIDTH / 2, ROAD_WIDTH * 2, SIDEWALK_WIDTH)
	var coli = int(col)
	if road:
		draw_rect(rect, ROAD_COLOR, true)
		var count = int(ROAD_WIDTH / CROSSING_WIDTH)
		var current = 0
		if count % 2 == 0:
			current = -CROSSING_WIDTH
		else:
			draw_crossing_marking(x, y, col)
			count -= 1
		for i in range(count / 2):
			current += CROSSING_WIDTH * 2
			draw_crossing_marking(x + current * int(not col), y + current * coli, col)
			draw_crossing_marking(x - current * int(not col) , y - current * coli, col)
	else:
		draw_rect(rect, SIDEWALK_COLOR, true)
	return

func draw_crossing_marking(x, y, col = false):
	var rect
	if col:
		rect = Rect2(x - SIDEWALK_WIDTH / 2, y - CROSSING_WIDTH / 2, SIDEWALK_WIDTH, CROSSING_WIDTH)
	else:
		rect = Rect2(x - CROSSING_WIDTH / 2, y - SIDEWALK_WIDTH / 2, CROSSING_WIDTH, SIDEWALK_WIDTH)
	draw_rect(rect, MARKING_COLOR, true)

func draw_path(index, dir):
	var x = path_x(index) * GRID_SIZE
	var y = path_y(index) * GRID_SIZE
	var x2 = x + int(dir == RIGHT) * GRID_SIZE / 4 - int(dir == LEFT) * GRID_SIZE / 4
	var y2 = y + int(dir == DOWN) * GRID_SIZE / 4 - int(dir == UP) * GRID_SIZE / 4
	
	draw_line(Vector2(x, y), Vector2(x2, y2), Color(1, 0, 0))
	return

func path_index(x, y):
	if x < 0 or y < 0 or x > WIDTH or y > HEIGHT:
		return -1
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
	if x < 0 or y < 0:
		return -1
	if x > WIDTH or y > HEIGHT:
		return -1
	if col:
		if y >= HEIGHT:
			return -1
		return int(WIDTH * (HEIGHT + 1) + x * HEIGHT + y)
	else:
		if x >= WIDTH:
			return -1
		return int(x + y * WIDTH)
	return -1

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

func building_x(index):
	return index % WIDTH

func building_y(index):
	return index / HEIGHT

func building_index(x, y):
	return x + y * WIDTH

func building_occupy(index):
	building_grid[index] = false



