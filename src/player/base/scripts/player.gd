extends CharacterBody2D

@export var label: Label
@export var healt_component: HealthComponent


func _ready() -> void:
	if healt_component == null:
		push_warning("health_component is null")
		return

	healt_component.hp_change.connect(set_text)


func set_text(current_hp: float, max_hp: float) -> void:
	if label == null:
		push_warning("label in player is null")
		return

	if healt_component == null:
		push_warning("health component is null")
		return

	label.text = str(int(current_hp), "/", int(max_hp))
