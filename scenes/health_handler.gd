class_name HealthHandler
extends Node

@export var base_health_max : int = 2
@export var death_handler : DeathHandler = null

var current_health : int = 0

signal apply_damage(value : int)

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_damage.connect(on_apply_damage)
	pass # Replace with function body.

func handle_health() -> void:
	if current_health > 0:
		return
	if current_health <= 0:
		current_health = 0
		
		if death_handler == null:
			print("erro ao morrer")
			return
		
		death_handler.handle_death.emit()

func calculate_damage(value : int) -> void:
	current_health -= value

func on_apply_damage(value : int) -> void:
	handle_health()
	
	if value > 0:
		calculate_damage(value)
