extends Node2D

enum directions {
	RIGHT,
	LEFT,
	UP,
	DOWN,
	NONE
}

var direction

func _draw():
	draw_speech_bubble()
	draw_arrow()
	
func init(direction):
	self.direction = direction

func draw_speech_bubble():
	var corner_points = 10
	var corner_radius = 0.3
	var x = -1.5
	var y = -1.5
	var width = 3
	var height = 3
	
	var points = PoolVector2Array()
	
	for i in range(corner_points+1):
		var angle_point = i * PI/2 / corner_points - PI/2
		points.push_back(Vector2(width-corner_radius + x, corner_radius + y) + Vector2(cos(angle_point), sin(angle_point)) * corner_radius)
	
	for i in range(corner_points+1):
		var angle_point = PI/2 + i * PI/2 / corner_points - PI/2
		points.push_back(Vector2(width-corner_radius + x, height-corner_radius + y) + Vector2(cos(angle_point), sin(angle_point)) * corner_radius)
	
	for i in range(corner_points+1):
		var angle_point = PI + i * PI/2 / corner_points - PI/2
		points.push_back(Vector2(corner_radius + x, height-corner_radius + y) + Vector2(cos(angle_point), sin(angle_point)) * corner_radius)
	# 
	"""
	for i in range(corner_points+1):
		var angle_point = 3*PI/2 + i * PI/2 / corner_points - PI/2
		points.push_back(Vector2(corner_radius + x, corner_radius + y) + Vector2(cos(angle_point), sin(angle_point)) * corner_radius)
	"""
	points.push_back(Vector2(x, y - 0.5))
	points.push_back(Vector2(x + 0.5, y))
	draw_polygon(points, PoolColorArray([Color(1,1,1)]))

func draw_arrow():
	$Questionmark.hide()
	$Dot.hide()
	$Arrow.show()
	match direction:
		RIGHT:
			$Arrow.rotation = PI
		LEFT:
			$Arrow.rotation = 0
		UP:
			$Arrow.rotation = PI/2
		DOWN:
			$Arrow.rotation = 3*PI/2
		NONE:
			$Questionmark.show()
			$Dot.show()
			$Arrow.hide()
			
	
func _ready():
	#$Questionmark.rotate(PI)
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
