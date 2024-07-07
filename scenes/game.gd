extends Node2D

var gameScore := 0
@onready var scoreLabel := $HUD/ScoreLabel
var player : CharacterBody2D

var currentScene = null
var currentLevel = 0
var levelPath = "res://levels/level_{lvl}.tscn"
var level
# Script principal do jogo

func _ready() -> void:
	goto_scene(levelPath.format({"lvl":currentLevel + 1}))
	player = $Level/AnimPlayer
	player.gameOver
	var level = get_node('Level')
	#print(sceneLimit.position)
	#music.play()

# Callback chamado quando o timer gerar um timeout
func _on_timer_timeout() -> void:
	print("Timer!")

# Chamada através de call_group
func updateScore():
	gameScore += 1
	#if !music.playing:
	#	music.play()
	scoreLabel.text = "Score: " + str(gameScore)

func _physics_process(delta: float) -> void:
	#player = $Level/AnimPlayer
	# Pressione X para trocar para a proxima fase
	if Input.is_action_just_pressed("change"):
		call_deferred("goto_scene",levelPath.format({"lvl":currentLevel + 1}))
	
func goto_scene(path: String):
	if (currentLevel != 0):
		level.queue_free()
	var res := ResourceLoader.load(path)
	currentScene = res.instantiate()
	#player = get_child(0).get_node("AnimPlayer")
	add_child(currentScene)
	level = currentScene
	if(currentLevel < 2):
		currentLevel += 1

func gameOver():
	print('level over')
	pass # Replace with function body.
