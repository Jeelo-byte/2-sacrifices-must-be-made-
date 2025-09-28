extends Polygon2D

var player
var arrow_size = 30.0
var arrow_distance = 100.0

func _ready():
	polygon = PackedVector2Array([
		Vector2(0, -arrow_size/2),
		Vector2(-arrow_size/3, arrow_size/2),
		Vector2(arrow_size/3, arrow_size/2)
	])
	color = Color.RED
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if not player:
		player = get_tree().get_first_node_in_group("player")
		return
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	
	if enemies.size() == 0:
		visible = false
		return
	
	var center_of_gravity = Vector2.ZERO
	for enemy in enemies:
		center_of_gravity += enemy.global_position
	center_of_gravity /= enemies.size()
	
	var direction = (center_of_gravity - player.global_position).normalized()
	
	global_position = player.global_position + direction * arrow_distance
	
	rotation = direction.angle() + PI/2
	
	visible = true
