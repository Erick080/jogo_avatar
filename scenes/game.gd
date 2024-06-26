extends Node2D

var gameScore := 0
@onready var scoreLabel := $HUD/ScoreLabel
var player : CharacterBody2D
var sceneLimit : Marker2D
@onready var music := $Music

var currentScene = null
var currentLevel = 0
var levelPath = "res://levels/level_{lvl}.tscn"
# Script principal do jogo

func _ready() -> void:
	goto_scene(levelPath.format({"lvl":currentLevel + 1}))
	sceneLimit = $Level/SceneLimit
	player = $Level/AnimPlayer
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
	if sceneLimit == null:
		player = $Level/AnimPlayer
		#sceneLimit = $Level/SceneLimit
		#print("sceneLimit: ", sceneLimit)
		#print("player: ", player)

	# Pressione X para trocar para a proxima fase
	if Input.is_action_just_pressed("change"):
		call_deferred("goto_scene",levelPath.format({"lvl":currentLevel + 1}))

	# Pressione F para ligar/desligar o filtro passa-baixa
	if Input.is_action_just_pressed("filter"):
		var lowpass := AudioServer.get_bus_effect(1, 0) as AudioEffectLowPassFilter # 1-Music, 0-Low Pass (primeiro efeito)
		if lowpass.cutoff_hz == 500:
			lowpass.cutoff_hz = 20000
		else:
			lowpass.cutoff_hz = 500
	
func goto_scene(path: String):
	if (currentLevel != 0):
		$Level.free()
	var res := ResourceLoader.load(path)
	currentScene = res.instantiate()
	#player = get_child(0).get_node("AnimPlayer")
	add_child(currentScene)
	sceneLimit = null
	currentLevel += 1

func _on_level_level_over():
	print('level over')
	pass # Replace with function body.
