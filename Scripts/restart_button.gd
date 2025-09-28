extends Button

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		position = player.global_position - get_viewport().size / 2 + Vector2(0, -100)
