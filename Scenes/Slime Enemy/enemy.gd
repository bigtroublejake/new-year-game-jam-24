extends CharacterBody2D

@export var speed : int 
@export var acceleration : int
var player_chase = false
var player: CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	pass
	
	
func gravity_handle(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func _physics_process(delta):
	gravity_handle(delta)
	
	if player_chase:
		if player.position.x > position.x:
			velocity.x = move_toward(velocity.x, speed, acceleration * delta * 60)
			animated_sprite_2d.flip_h = false
		if player.position.x < position.x:
			velocity.x = move_toward(velocity.x, -speed, acceleration * delta * 60)
			animated_sprite_2d.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration / 2 * delta * 60)
	
	move_and_slide()
	
	_update_animation()


func _update_animation():
	if velocity.x != 0:
		animated_sprite_2d.play("move")
	elif velocity.x == 0:
		animated_sprite_2d.play("idle")

func _on_detection_area_body_entered(body):
	if body != null:
		player = body
		player_chase = true

	
	
func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	


func _on_collision_detection_body_entered(body):
	body._take_damage()
