extends Node2D


@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

var dialogue_preload : Object

func _ready():
	dialogue_preload = load(dialogue_resource.resource_path)


func dialogue() -> void:
	DialogueManager.show_dialogue_balloon(dialogue_preload, dialogue_start)
