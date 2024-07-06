extends CharacterBody2D

var hp = 5
const SPEED = 3000.0
@onready var player = get_node('./AnimPlayer')

func _physics_process(delta):
	velocity = Vector2.ZERO
	print(player.name)
	if player:
		print("entrou no if player")
		velocity = position.direction_to(player.position) * SPEED
		if velocity.x > 0:
			$EnemySprite.play('stance') #right
		else:
			$EnemySprite.play('stance') #left
		move_and_slide()
	pass

func _ready():
	pass

func deal_damage():
	hp = hp - 1
