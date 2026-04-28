class_name InputComponent
extends MoveDirectionComponent

@export var action_component: ActionComponent
var last_direction_value: Vector2 = Vector2.ZERO


func get_vector() -> Vector2:
	var vec: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if vec != last_direction_value:
		last_direction_value = vec
		action_component.last_direction.emit(vec)
	return vec


func _unhandled_input(event: InputEvent) -> void:
	if action_component == null:
		push_warning("action components is empty for input component")
		return
	if event.is_action_pressed("dash"):
		action_component.dash_action.emit()
	if event.is_action_pressed("attack"):
		action_component.attack_action.emit()
