extends CharacterBody2D

@export var speed = 300.0
@onready var sprite = $AangSprite
#@onready var box := preload("res://objects/box.tscn"
@export var box : PackedScene


#func _ready() -> void:
#	sprite = $PlayerSprite
	
func get_8way_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	print(input_direction)
	velocity = input_direction * speed
	
func get_side_input():
	velocity.x = 0
	var vel := Input.get_axis("left", "right")
	velocity.x = vel * speed
	
func animate():
	if velocity.x > 0:		
		sprite.play("run_right")
	elif velocity.x < 0:
		sprite.play("run_left")
	elif velocity.y > 0:
		sprite.play("stance")
	elif velocity.y < 0:
		sprite.play("stance")
	else:
		sprite.play("stance")
			

	
func move_8way(delta):
	get_8way_input()
	animate()
	#move_and_slide()
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		move_and_collide(velocity * delta * 10)

	
func _physics_process(delta):
	move_8way(delta)
	
