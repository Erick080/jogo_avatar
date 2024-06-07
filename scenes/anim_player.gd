extends CharacterBody2D

@export var speed = 400.0
@onready var sprite = $AangSprite
@onready var elementSprite = load("ElementSprite")
#@onready var box := preload("res://objects/box.tscn"
@export var box : PackedScene
var attacking = false
var element

#func _ready() -> void:
#	element = elementSprite.instance()
	
func get_8way_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	#print(input_direction)
	if attacking:
		velocity = input_direction * 0
	else: 
		velocity = input_direction * speed
	
func get_atk_input():
	if Input.is_key_pressed(KEY_E):
		attacking = true
	
func animate():
	if attacking == true:
		sprite.play("atk_air")
		if sprite.frame == 4:
			$ElementSprite.z_index = 1
			$ElementSprite.play("test")
		await $ElementSprite.animation_finished
		$ElementSprite.z_index = 0
		attacking = false
	elif velocity.x > 0:
		sprite.play("run_right")
	elif velocity.x < 0: 
		sprite.play("run_left")
	elif velocity.y > 0:
		sprite.play("run_left")
	elif velocity.y < 0:
		sprite.play("run_right")	
	else:
		sprite.play("stance")
			

	
func move_8way(delta):
	get_8way_input()
	get_atk_input()
	animate()
	#move_and_slide()
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		move_and_collide(velocity * delta * 10)

	
func _physics_process(delta):
	move_8way(delta)
	
