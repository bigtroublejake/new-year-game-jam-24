extends Node2D

@onready var player = $Player
@onready var camera_2d = $Camera2D
@onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d = $StaticBody2D/CollisionPolygon2D/Polygon2D

# Called when the node enters the scene tree for the first time.
func _ready():
	polygon_2d.polygon = collision_polygon_2d.polygon
	print("first stage loaded")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera_2d.position = player.position
