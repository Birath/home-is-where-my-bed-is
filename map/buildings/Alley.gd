extends StaticBody2D

var map

const BARRIER_WIDTH = 10
const BARRIER_COLOR = Color(0.5, 0, 0)

onready var shapes
onready var bed = preload("res://enteties/Bed.tscn")


func _init(map, road_index, spawn_bed = false):
	map.get_node("buildings").add_child(self)
	self.map = map
	map.remove_road(road_index)
	
	self.position = Vector2(map.road_x(road_index) + 1.0 / 2, map.road_y(road_index)) * map.GRID_SIZE
	

	
	self.shapes = [
		[Rect2(0, -(map.ROAD_WIDTH + map.SIDEWALK_WIDTH), map.GRID_SIZE / 2 - map.ROAD_WIDTH - map.SIDEWALK_WIDTH, (map.ROAD_WIDTH + map.SIDEWALK_WIDTH) * 2), BARRIER_COLOR, true],
		[Rect2(-map.GRID_SIZE / 2 + map.ROAD_WIDTH + map.SIDEWALK_WIDTH, -(map.ROAD_WIDTH + map.SIDEWALK_WIDTH), map.GRID_SIZE / 2 - map.ROAD_WIDTH - map.SIDEWALK_WIDTH, (map.ROAD_WIDTH + map.SIDEWALK_WIDTH) * 2), map.SIDEWALK_COLOR, false],
		[Rect2(-map.GRID_SIZE / 2 + map.ROAD_WIDTH + map.SIDEWALK_WIDTH, -(map.ROAD_WIDTH + map.SIDEWALK_WIDTH), map.GRID_SIZE / 2 - map.ROAD_WIDTH - map.SIDEWALK_WIDTH, map.ROAD_WIDTH), BARRIER_COLOR, true],
		[Rect2(-map.GRID_SIZE / 2 + map.ROAD_WIDTH + map.SIDEWALK_WIDTH, (map.ROAD_WIDTH + map.SIDEWALK_WIDTH) - map.ROAD_WIDTH, map.GRID_SIZE / 2 - map.ROAD_WIDTH - map.SIDEWALK_WIDTH, map.ROAD_WIDTH), BARRIER_COLOR, true]
	]
	
	for shape in self.shapes:
		if shape[2]:
			var c = CollisionShape2D.new()
			var s = RectangleShape2D.new()
			s.extents = shape[0].size / 2
			c.shape = s
			c.position += shape[0].position + (shape[0].size / 2)
			self.add_child(c)
	
	if spawn_bed:
		var b = bed.instance()
		b.position = Vector2(-5, 0)
		self.add_child(b)
		get_node("/root/Game").bed = b
		
	
	return

func _draw():
	for shape in shapes:
		draw_rect(shape[0], shape[1], true)
	return