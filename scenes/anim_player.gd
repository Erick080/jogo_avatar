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
var current_element #elemento que o jogador seleciona para atacar
var current_attack = "atk_{element}"
var current_sfx = "{element}_SFX"
var ultima_posicao = -1
var earth_projectile_intact
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
	if sprite.animation_finished:
		if Input.is_key_pressed(KEY_LEFT):
			if $air_cooldown.is_stopped():
				attacking = true
				current_element = 'air'
				$air_cooldown.start()
		elif Input.is_key_pressed(KEY_RIGHT):
			if $earth_cooldown.is_stopped() and earth:
				attacking = true
				current_element = 'earth'
				$earth_cooldown.start()
		elif Input.is_key_pressed(KEY_UP):
			if $water_cooldown.is_stopped():
				attacking = true
				current_element = 'water'
				$water_cooldown.start()
		elif Input.is_key_pressed(KEY_DOWN):
			if $fire_cooldown.is_stopped() and fire:
				attacking = true
				current_element = 'fire'
				$fire_cooldown.start()

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
		body.deal_damage()
		match current_element:
			'air': #joga inimigos para tras
				if body.velocity.x > 0:
					body.position.x -= 100
				else:
					body.position.x += 100
			'earth': #stun
				body.stun_timer.start() 
			'water': #slow
				body.SPEED /= 2
			'fire': #insta kill
				body.hp = 0
		if body.hp == 0:
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
		sprite.play(current_attack.format({"element":current_element}))
		
		var sfx = get_node(current_sfx.format({"element":current_element}))
		if sprite.frame == 4:
			if !sfx.playing:
				sfx.play()
			if ultima_posicao == 0:
				$ElementSprite.transform = $AtkLeftMarker.transform
				$ElementSprite.flip_h = true
				$AtkLeftMarker/Area2DLeft.monitoring = true
			else:
				$ElementSprite.transform = $AtkRightMarker.transform
				$ElementSprite.flip_h = false
				$AtkRightMarker/Area2DRight.monitoring = true
			$ElementSprite.z_index = 1
			$ElementSprite.play(current_element)
		await $ElementSprite.animation_finished
		$ElementSprite.z_index = 0
		attacking = false
		sfx.stop()
		$AtkLeftMarker/Area2DLeft.monitoring = false
		$AtkRightMarker/Area2DRight.monitoring = false
	elif velocity.x > 0:
		if !$RunningGrassSFX.playing:
			$RunningGrassSFX.play()
		$AangSprite.flip_h = false
		sprite.play("run_right")
		ultima_posicao = 1
	elif velocity.x < 0:
		if !$RunningGrassSFX.playing:
			$RunningGrassSFX.play()
		$AangSprite.flip_h = true 
		sprite.play("run_right")
		ultima_posicao = 0
	elif velocity.y != 0:
		if !$RunningGrassSFX.playing:
			$RunningGrassSFX.play()
		if ultima_posicao == 0:	
			$AangSprite.flip_h = true
		else:
			$AangSprite.flip_h = false
		sprite.play("run_right")
	else:
		$RunningGrassSFX.stop()
		if ultima_posicao == 0:	
			$AangSprite.flip_h = true
		else:
			$AangSprite.flip_h = false
		sprite.play("stance")
