extends Node2D

@onready var collision_polygon_2d: CollisionPolygon2D = $"Test Platform/CollisionPolygon2D"
@onready var polygon_2d: Polygon2D = $"Test Platform/CollisionPolygon2D/Polygon2D"
@onready var player : Player = $Player
@onready var camera_2d: Camera2D = $Camera2D

var startPos : Vector2


@onready var collision_shape2d = $"Test Platform/CollisionPolygon2D"
@onready var sprite2d = $"Test Platform/CollisionPolygon2D/Polygon2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon_2d.polygon = collision_polygon_2d.polygon
	startPos = player.position
	
	sprite2d.polygon = collision_polygon_2d.polygon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera_2d.position = player.position
	
	if player.position.y >= 500:
		player.position = startPos
	
