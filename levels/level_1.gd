extends Node
@onready var enemy := load("res://scenes/enemy.tscn") 
var sceneLimit : Marker2D
var gameScore = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD/ScoreLabel.set("theme_override_colors/font_color", Color(0, 1, 0))
	pass # Replace with function body


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var position = ($AnimPlayer.position - e.position).normalized()
	if (gameScore == 5):
		get_parent().goto_scene('res://levels/level_2.tscn')
	pass

func teste_sinal():
	print('teste')

var aux_counter = 0
func _on_area_2d_area_entered(area):
	aux_counter += 1
	print(aux_counter)


func _on_area_2d_left_area_entered(area):
	print('hit registrado')
	gameScore += 1
	$HUD/ScoreLabel.text = "Score: " + str(gameScore)  
	pass # Replace with function body.


func _on_area_2d_right_area_entered(area):
	gameScore += 1
	$HUD/ScoreLabel.text = "Score: " + str(gameScore)  
	print('hit registrado')
	pass # Replace with function body.

