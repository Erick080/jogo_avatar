class_name DeathHandler
extends Node

@export var parent : Node2D = null

signal handle_death

# Called when the node enters the scene tree for the first time.
func _ready():
	handle_death.connect(on_handle_death)

func on_handle_death() -> void:
	parent.queue_free()
