class_name InputComponent
extends MoveDirectionComponent

signal dash_pressed

func get_vector() -> Vector2: 
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dash"):
		dash_pressed.emit()
