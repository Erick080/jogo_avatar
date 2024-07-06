extends CharacterBody2D

var hp = 5
const SPEED = 100.0
const JUMP_VELOCITY = -400.0
@onready var player = get_node('../AnimPlayer')

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player:
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
