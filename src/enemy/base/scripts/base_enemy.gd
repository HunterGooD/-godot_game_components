extends CharacterBody2D

@export var main_stats: StatsComponent
@export var label: Label
@export var healt_component: HealthComponent


func _ready() -> void:
	if main_stats == null:
		push_warning("main stats base enemy is null")
		return

	if healt_component == null:
		push_warning("health_component is null for base enemy")
		return

	healt_component.hp_change.connect(set_text)


func set_text(current_hp: float, max_hp: float) -> void:
	if label == null:
		push_warning("label in base enemy is null")
		return

	label.text = str(int(current_hp), "/", int(max_hp))
