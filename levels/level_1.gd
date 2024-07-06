extends Node

@onready var enemy := load("res://scenes/enemy.tscn") 
var sceneLimit : Marker2D
var gameScore = 0
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD/ScoreLabel.set("theme_override_colors/font_color", Color(0, 1, 0))
	$AnimPlayer.updateScore.connect(_updateScore)

func _updateScore():
	gameScore = gameScore + 1
	$HUD/ScoreLabel.text = "Score: " + str(gameScore) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (gameScore == 5):
		get_parent().goto_scene('res://levels/level_2.tscn')

var aux_counter = 0
func _on_area_2d_area_entered(area):
	aux_counter += 1
	print(aux_counter)


func _on_timer_timeout():
	var enemy_instance = enemy.instantiate()
	add_child(enemy_instance)
	var random_number = rng.randi_range(0,1)
	if random_number == 0:
		enemy_instance.position = $EnemySpawn1.position
	else:
		enemy_instance.position = $EnemySpawn2.position
	pass # Replace with function body.
