extends Area2D
signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	hit.connect(on_hit)
	pass # Replace with function body.

func on_hit() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
