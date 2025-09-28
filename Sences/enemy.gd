extends CharacterBody2D

@onready var player = get_parent().get_node("Player")

func _physics_process(delta):
	position += (player.position - position) / 50

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullets") or body.name.begins_with("Bullet"):
		queue_free()
		body.queue_free()
