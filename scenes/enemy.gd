extends CharacterBody2D

var hp = 3
var SPEED = 100.0
const JUMP_VELOCITY = -400.0
@onready var player = get_node('../AnimPlayer')
@onready var stun_timer = $StunTimer

func _physics_process(_delta):
	velocity = Vector2.ZERO
	if player and stun_timer.is_stopped():
		velocity = position.direction_to(player.position) * SPEED
		if velocity.x > 0:
			$EnemySprite.play('run_right')
		else:
			$EnemySprite.play('run_left')
		move_and_slide()

func _ready():
	motion_mode = 1
	pass

func deal_damage():
	hp = hp - 1
