extends Node2D

var total : float = 0

func _ready() -> void:
	update_score(total)
	
func _process(delta: float) -> void:
	#print(delta)
	total += delta
	update_score(total)

func _input(event: InputEvent) -> void:
	#print(event.as_text())
	if event.is_action_pressed("ui_left"):
		print("Left arrow com callback _input")
	
func update_score(current_score: float) -> void:
	$Score.text = str(current_score	) # converte para string
	
