extends CharacterBody2D

@export var speed = 400.0
@onready var sprite = $AangSprite
@onready var elementSprite = load("ElementSprite")
@export var box : PackedScene
var attacking = true
var element
var ultima_posicao = -1
signal updateScore

func _ready():
	motion_mode = 1
	pass
	
func get_8way_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
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
			if ultima_posicao == 0:
				$ElementSprite.transform = $AtkLeftMarker.transform
				$ElementSprite.flip_h = true
				$AtkLeftMarker/Area2DLeft.monitoring = true
			else:
				$ElementSprite.transform = $AtkRightMarker.transform
				$ElementSprite.flip_h = false
				$AtkRightMarker/Area2DRight.monitoring = true
			$ElementSprite.z_index = 1
			$ElementSprite.play("test")
		await $ElementSprite.animation_finished
		$ElementSprite.z_index = 0
		attacking = false
		$AtkLeftMarker/Area2DLeft.monitoring = false
		$AtkRightMarker/Area2DRight.monitoring = false
	elif velocity.x > 0:
		$AangSprite.flip_h = false
		sprite.play("run_right")
		ultima_posicao = 1
	elif velocity.x < 0:
		$AangSprite.flip_h = true 
		sprite.play("run_right")
		ultima_posicao = 0
	elif velocity.y != 0:
		if ultima_posicao == 0:	
			$AangSprite.flip_h = true
		else:
			$AangSprite.flip_h = false
		sprite.play("run_right")
	else:
		if ultima_posicao == 0:	
			$AangSprite.flip_h = true
		else:
			$AangSprite.flip_h = false
		sprite.play("stance")
		
var aux_count = 0
func move_8way(delta):
	get_8way_input()
	get_atk_input()
	animate()
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		#velocity = velocity.bounce(collision_info.get_normal())
		#move_and_collide(velocity * delta * 10)
		aux_count+=1
		#print(aux_count)
	
func _physics_process(delta):
	move_8way(delta)

func _on_area_2d_right_body_entered(body):
	#print(body.name)
	updateScore.emit()
	body.queue_free()
	
	
