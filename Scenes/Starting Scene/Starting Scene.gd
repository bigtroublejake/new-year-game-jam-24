extends Node2D

# Polygons inside of "Test Platforms"
@onready var collision_polygon_2d: CollisionPolygon2D = $"Test Platforms/CollisionPolygon2D"
@onready var polygon_2d: Polygon2D = $"Test Platforms/CollisionPolygon2D/Polygon2D"

@onready var collision_polygon_2d_2 = $"Test Platforms/CollisionPolygon2D2"
@onready var polygon_2d_2 = $"Test Platforms/CollisionPolygon2D2/Polygon2D"


# Rest of the nodes
@onready var player : Player = $Player
@onready var camera_2d: Camera2D = $Camera2D
@onready var fade_timer = $"Test Platforms/Area2D/Timer"

var startPos : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon_2d.polygon = collision_polygon_2d.polygon
	polygon_2d_2.polygon = collision_polygon_2d_2.polygon
	startPos = player.position
	RenderingServer.set_default_clear_color(Color.DEEP_SKY_BLUE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera_2d.position = player.position
	
	if player.position.y >= 500:
		player.position = startPos


func _on_area_2d_body_entered(body):
	if body == player:
		await Fade.fade_out().finished
		fade_timer.start()
		print("Scene transition")


# REMOVE THIS ONCE WE HAVE A SCENE TO TRANSITION TO
func _on_timer_timeout():
	Fade.fade_in()
