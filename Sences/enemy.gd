extends CharacterBody2D

@onready var player = get_parent().get_node("Player")

func _physics_process(delta):
	position += (player.position - position) / 50


func _on_area_2d_body_entered(body: Node2D) -> void:
	if "Bullet" in body.name:
		queue_free()
