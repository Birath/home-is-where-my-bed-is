extends StaticBody2D

var GRID_SIZE
var ROAD_WIDTH

var buildings
var building
var map

func _init(map, building, x, y):
	map.get_node("buildings").add_child(self)
	self.map = map
	self.building = building
	self.GRID_SIZE = map.GRID_SIZE
	self.ROAD_WIDTH = map.ROAD_WIDTH + map.SIDEWALK_WIDTH
	
	self.position = Vector2(x, y) * map.GRID_SIZE
	
	self.buildings = {
		"park" : [
			[[Vector2(1, 1), map.RIGHT], [Vector2(1, 1), map.UP], [Vector2(1, 1), map.LEFT], [Vector2(1, 1), map.DOWN]],
			[Vector2(0, 0), Vector2(0, 1), Vector2(1, 0), Vector2(1, 1)],
			[[Rect2(ROAD_WIDTH, ROAD_WIDTH, (GRID_SIZE - ROAD_WIDTH) * 2, (GRID_SIZE - ROAD_WIDTH) * 2), Color("02A676"), false]]
		],
		"small_house" : [
			[],
			[Vector2(0, 0)],
			[[Rect2(ROAD_WIDTH, ROAD_WIDTH, GRID_SIZE - ROAD_WIDTH * 2, GRID_SIZE - ROAD_WIDTH * 2), Color(0.5, 0, 0), true]],
		]
	}
	
	for road in buildings[building][0]:
		map.remove_road(map.get_road(road[0].x, road[0].y, road[1]))
	for grid in buildings[building][1]:
		map.building_occupy(map.building_index(grid.x + x, grid.y + y))
	
	for shape in buildings[building][2]:
		if shape[2]:
			var c = CollisionShape2D.new()
			var s = RectangleShape2D.new()
			s.extents = shape[0].size / 2
			c.shape = s
			c.position += shape[0].position + (shape[0].size / 2)
			self.add_child(c)
	
	return

func _draw():
	for shape in buildings[building][2]:
		draw_rect(shape[0], shape[1], true)
	return