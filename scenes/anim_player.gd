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
var earth = true
var fire = true
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
	if !attacking:
		if Input.is_key_pressed(KEY_LEFT) and $air_cooldown.is_stopped():
			attacking = true
			current_element = 'air'
		elif Input.is_key_pressed(KEY_RIGHT) and $earth_cooldown.is_stopped() and earth:
			attacking = true
			current_element = 'earth'
		elif Input.is_key_pressed(KEY_UP) and $water_cooldown.is_stopped():
			attacking = true
			current_element = 'water'
		elif Input.is_key_pressed(KEY_DOWN) and $fire_cooldown.is_stopped() and fire:
			attacking = true
			current_element = 'fire'

func updateHealth():
	healthBar.value = currentHealth * 100 / maxHealth
	pass

func move_8way(delta):
	get_8way_input()
	get_atk_input()
	animate()
	move_and_collide(velocity * delta)

func _on_atk_body_entered(body): #hitou algo
	if body.name != 'StaticBody2D' and body.name != "AnimPlayer":
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

func _on_player_body_entered(body): #se ele tomou um hit
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

func verificaPosicao():
	if ultima_posicao == 0:
		$ElementSprite.flip_h = true
		match current_element:
			'air': 
				$ElementSprite.transform = $AirLeftMarker.transform
				$AirLeftMarker/Area2D.monitoring = true
			'earth':
				$ElementSprite.transform = $EarthLeftMarker.transform
				$EarthLeftMarker/Area2D.monitoring = true
			'water':
				$ElementSprite.transform = $WaterLeftMarker.transform
				$WaterLeftMarker/Area2D.monitoring = true
			'fire':
				$ElementSprite.transform = $FireLeftMarker.transform
				$FireLeftMarker/Area2D.monitoring = true
	else:
		$ElementSprite.flip_h = false
		match current_element:
			'air': 
				$ElementSprite.transform = $AirRightMarker.transform
				$AirRightMarker/Area2D.monitoring = true
			'earth':
				$ElementSprite.transform = $EarthRightMarker.transform
				$EarthRightMarker/Area2D.monitoring = true
			'water':
				$ElementSprite.transform = $WaterRightMarker.transform
				$WaterRightMarker/Area2D.monitoring = true
			'fire':
				$ElementSprite.transform = $FireRightMarker.transform
				$FireRightMarker/Area2D.monitoring = true

func desligarAtaques():
	match current_element:
			'air': 
				$AirRightMarker/Area2D.monitoring = false
				$AirLeftMarker/Area2D.monitoring = false
			'earth':
				$EarthRightMarker/Area2D.monitoring = false
				$EarthLeftMarker/Area2D.monitoring = false
			'water':
				$WaterRightMarker/Area2D.monitoring = false
				$WaterLeftMarker/Area2D.monitoring = false
			'fire':
				$FireRightMarker/Area2D.monitoring = false
				$FireLeftMarker/Area2D.monitoring = false

func animate():
	if attacking == true:
		sprite.play(current_attack.format({"element":current_element}))
		
		var sfx = get_node(current_sfx.format({"element":current_element}))
		var frameStart : int = 0
		if current_element == "air":
			frameStart = 4
			$air_cooldown.start()
		elif current_element == "earth":
			frameStart = 4
			$earth_cooldown.start()
		elif current_element == "fire":
			frameStart = 2
			$fire_cooldown.start()
		elif current_element == "water":
			frameStart = 0
			$water_cooldown.start()
		if sprite.frame == frameStart:
			if !sfx.playing:
				sfx.play()
			verificaPosicao()
			$ElementSprite.z_index = 1
			$ElementSprite.play(current_element)
		await $ElementSprite.animation_finished
		$ElementSprite.z_index = 0
		attacking = false
		sfx.stop()
		desligarAtaques()
	else:
		if velocity.x != 0 or velocity.y != 0:
			if !$RunningGrassSFX.playing:
				$RunningGrassSFX.play()
		else:
			$RunningGrassSFX.stop()
		if velocity.x > 0:
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
