extends Node
@onready var enemy := preload("res://scenes/enemy.tscn") 
var sceneLimit : Marker2D
var gameScore := 0
var e
signal level_over
# Called when the node enters the scene tree for the first time.
func _ready():
	e = enemy.instantiate()
	e.position = $AnimPlayer.position
	add_child(e)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var position = ($AnimPlayer.position - e.position).normalized()
	
	pass


func _on_anim_player_teste():
	#if abs(e.position.x - $AnimPlayer.position.x) < 30 and abs(e.position.y - $AnimP.position.y) < 30:
	#	print('registrado')
		#matar npc
		#incrementar pontuacao
	gameScore+=1
	if gameScore == 10:
		level_over.emit()
	pass # Replace with function body.
	
		
