extends Marker2D
var thrown
var speed = 750
var original_pos = position
var is_in_origin
var direcao
# Called when the node enters the scene tree for the first time.
func _ready():
	is_in_origin = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if thrown:
		is_in_origin = false
		if direcao == 0:
			position -= transform.x * speed * delta
		elif direcao == 1:
			position += transform.x * speed * delta
	pass

func throw(direction): #0 esquerda 1 direita
	thrown = true
	direcao = direction
	
func return_to_origin():
	thrown = false
	position = original_pos
	is_in_origin = true
