class_name RewardComponent
extends Node

@export var main_stats: StatsComponent


func _ready() -> void:
	GameEvents.enemy_died.connect(_on_enemy_died_event)


func _on_enemy_died_event(event: ActorDeathEvent) -> void:
	if main_stats == null:
		push_warning("main stats component in reward components is null")
		return

	if event.stats_modif == null:
		print("event stats modifier is null")
		return

	print("stats up reward")
	main_stats.add_modifier(event.stats_modif)
