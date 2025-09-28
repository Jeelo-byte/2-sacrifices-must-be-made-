extends CharacterBody2D

@onready var player = get_parent().get_node("Player")
var move_speed = 500

func _ready():
	add_to_group("enemies")

func _physics_process(delta):
	var direction = (player.position - position).normalized()
	velocity = direction * move_speed
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullets") or body.name.begins_with("Bullet"):
		queue_free()
		body.queue_free()
