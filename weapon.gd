extends CharacterBody2D
@onready var detection = $detection

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func gravity_handle(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_dif_player = get_global_mouse_position().x - global_position.x
	gravity_handle(delta)
	move_and_slide()
	var body = detection.get_overlapping_bodies()
	if body.size() > 0:
		if body[0].has_method("_weapon_pickup"):
			body[0]._weapon_pickup(mouse_dif_player)
			queue_free()





