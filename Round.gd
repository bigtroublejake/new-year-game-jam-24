extends Node2D


@export var velocity: Vector2




func _process(delta: float) -> void:
	translate(velocity * delta)
