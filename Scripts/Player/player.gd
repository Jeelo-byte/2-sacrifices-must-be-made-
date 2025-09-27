extends CharacterBody2D

@export var bullet: PackedScene
@export var bullet_speed = 1500
@export var offset_scale = 140
@export var offset_rot = 270

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
	look_at((get_global_mouse_position() - anim.global_position).rotated(deg_to_rad(offset_rot)) + anim.global_position)
	
func fire():
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_position = anim.global_position + offset_scale * Vector2(cos(rotation + deg_to_rad(offset_rot + 180)), sin(rotation + deg_to_rad(offset_rot + 180)))
	bullet_instance.rotation = rotation + deg_to_rad(offset_rot)
	bullet_instance.apply_impulse(Vector2(bullet_speed, 0).rotated(rotation + deg_to_rad(offset_rot + 180)))
	get_tree().get_root().add_child(bullet_instance)
	
func kill():
	get_tree().reload_current_scene()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if "Enemy" in body.name:
		kill()


func _on_Area2D_body_entered(body):
	pass
