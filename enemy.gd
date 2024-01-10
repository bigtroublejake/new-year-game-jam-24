extends CharacterBody2D

@export var speed : int
var player_chase = false
var player: CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	pass
	
	
func gravity_handle(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func _physics_process(delta):
	gravity_handle(delta)
	move_and_slide()
	if player_chase:
		position.x = move_toward(position.x, player.position.x, speed * delta)


func _on_detection_area_body_entered(body):
	if body != null:
		player = body
		player_chase = true

	
	
func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	


func _on_collision_detection_body_entered(body):
	body._take_damage()
