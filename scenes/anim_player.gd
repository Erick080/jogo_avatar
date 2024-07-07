extends CharacterBody2D

@export var speed = 400.0
@export var box : PackedScene
@onready var sprite = $AangSprite
@onready var elementSprite = $ElementSprite
@onready var healthBar = $HealthBar
signal updateScore
signal gameOver
const maxHealth = 5
var currentHealth = maxHealth
var attacking = false
var earth = false
var fire = false
var element = "air"
var ultima_posicao = -1

func _ready():
	motion_mode = 1
	pass

func _physics_process(delta):
	move_8way(delta)

func get_8way_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	if attacking:
		velocity = input_direction * 0
	else: 
		velocity = input_direction * speed

func get_atk_input():
	if Input.is_key_pressed(KEY_E):
		attacking = true

func updateHealth():
	healthBar.value = currentHealth * 100 / maxHealth
	pass

func move_8way(delta):
	get_8way_input()
	get_atk_input()
	animate()
	move_and_collide(velocity * delta)

func _on_area_2d_right_body_entered(body): #hitou algo
	if body.name != 'StaticBody2D':
		updateScore.emit()
		body.queue_free()

func _on_area_2d_body_entered(body): #se ele tomou um hit
	if body.name != 'AnimPlayer' and body.name != 'StaticBody2D':
		print('tomou hit')
		currentHealth -= 1
		updateHealth()
		if currentHealth <= 0:
			gameOver.emit()
			pass
		if body.velocity.x > 0:
			body.position.x -= 100
		else:
			body.position.x += 100
	pass # Replace with function body.

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
