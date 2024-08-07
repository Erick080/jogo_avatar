extends Node
@onready var enemy := load("res://scenes/enemy.tscn") 
var sceneLimit : Marker2D
var gameScore = 0
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	#$HUD/ScoreLabel.set("theme_override_colors/font_color", Color(0, 0, 1))
	$AnimPlayer.updateScore.connect(_updateScore)
	$AnimPlayer.gameOver.connect(gameOver)
	$AnimPlayer.earth = true
	$AnimPlayer.fire = true
	$AnimPlayer/Camera2D.limit_bottom = $Camera2D.limit_bottom
	$AnimPlayer/Camera2D.limit_top = $Camera2D.limit_top
	$AnimPlayer/Camera2D.limit_left = $Camera2D.limit_left
	$AnimPlayer/Camera2D.limit_right = $Camera2D.limit_right
	
func _updateScore():
	gameScore = gameScore + 1
	$HUD/ColorRect/ScoreLabel.text = "Score: " + str(gameScore) 

func gameOver():
	get_parent().goto_scene('res://levels/game_over.tscn')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#atualizar barra de cooldown aqui
	$HUD/CooldownBar_Air.value = ($AnimPlayer/air_cooldown.time_left / $AnimPlayer/air_cooldown.wait_time) * 100
	$HUD/CooldownBar_Earth.value = ($AnimPlayer/earth_cooldown.time_left / $AnimPlayer/earth_cooldown.wait_time) * 100
	$HUD/CooldownBar_Water.value = ($AnimPlayer/water_cooldown.time_left / $AnimPlayer/water_cooldown.wait_time) * 100
	$HUD/CooldownBar_Fire.value = ($AnimPlayer/fire_cooldown.time_left / $AnimPlayer/fire_cooldown.wait_time) * 100
	if (gameScore >= 10):
		get_parent().goto_scene('res://levels/win.tscn')
	pass

var aux_counter = 0
func _on_area_2d_area_entered(area):
	aux_counter += 1
	print(aux_counter)


func _on_timer_timeout():
	var enemy_instance = enemy.instantiate()
	add_child(enemy_instance)
	var random_number = rng.randi_range(0,1)
	if random_number == 0:
		enemy_instance.position = $Enemy_Spawn1.position
	else:
		enemy_instance.position = $Enemy_Spawn2.position

	pass
