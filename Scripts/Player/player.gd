extends CharacterBody2D

@export var bullet: PackedScene
@export var bullet_speed = 1000

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var movespeed = 500

# --- NEW ---
# Moved the animation logic here from main.gd.
func _ready():
	anim.play("idle")

func _physics_process(delta):
	var direction = Vector2()
	
	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1
	
	if Input.is_action_just_pressed("LMB"):
		fire()
	
	if direction != Vector2.ZERO:
		velocity = direction.normalized() * movespeed
	else:
		velocity = Vector2.ZERO 
		
	move_and_slide()
	look_at(get_global_mouse_position())
	
func fire():
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_position = global_position
	bullet_instance.rotation = rotation
	bullet_instance.apply_impulse(Vector2(bullet_speed, 0).rotated(rotation))
	get_tree().get_root().add_child(bullet_instance)
	
func kill():
	get_tree().reload_current_scene()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if "Enemy" in body.name:
		kill()


func _on_Area2D_body_entered(body):
	pass
	
	
