extends StaticBody2D


func init(x, y, width, height):
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.extents = Vector2(width / 2, height / 2)
	self.position = Vector2(x + width / 2, y + height / 2)
	
	$Polygon2D.position = Vector2(-width / 2, -height / 2)
	$Polygon2D.polygon[0] = Vector2(0, 0)
	$Polygon2D.polygon[1] = Vector2(0 + width, 0)
	
	$Polygon2D.polygon[2] = Vector2(0 + width, 0 + height)
	$Polygon2D.polygon[3] = Vector2(0, 0 + height)
	
	print("building wall...")