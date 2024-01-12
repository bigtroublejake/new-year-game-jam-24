extends Node2D

# Polygons inside of "Test Platforms"
@onready var collision_polygon_2d: CollisionPolygon2D = $"Test Platforms/CollisionPolygon2D"
@onready var polygon_2d: Polygon2D = $"Test Platforms/CollisionPolygon2D/Polygon2D"

@onready var collision_polygon_2d_2 = $"Test Platforms/CollisionPolygon2D2"
@onready var polygon_2d_2 = $"Test Platforms/CollisionPolygon2D2/Polygon2D"


# Rest of the nodes
@onready var player : Player = $Player
@onready var camera_2d: Camera2D = $Camera2D

var startPos : Vector2


@onready var collision_shape2d = $"Test Platforms/CollisionPolygon2D"
@onready var sprite2d = $"Test Platforms/CollisionPolygon2D/Polygon2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon_2d.polygon = collision_polygon_2d.polygon
	polygon_2d_2.polygon = collision_polygon_2d_2.polygon
	startPos = player.position
	RenderingServer.set_default_clear_color(Color.DEEP_SKY_BLUE)
	
	sprite2d.polygon = collision_polygon_2d.polygon



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera_2d.position = player.position
	
	if player.position.y >= 500:
		player.position = startPos


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		await Fade.fade_out().finished
		
		get_tree().change_scene_to_file("res://Scenes/First Stage/first_stage.tscn")
		
		print("Scene transition")
		body.position = startPos
		Fade.fade_in()



