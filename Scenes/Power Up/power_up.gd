extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func gravity_handle(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gravity_handle(delta)
	move_and_slide()


func _on_detection_body_entered(body):
	body._power_up()
	queue_free()








