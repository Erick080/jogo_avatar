extends Node2D

func _ready():
	pass 


func _process(delta):
	get_parent().musica.stop()
	if Input.is_key_pressed(KEY_ENTER):
		get_parent().musica.play()
		get_parent().goto_scene('res://levels/level_1.tscn')
	pass
