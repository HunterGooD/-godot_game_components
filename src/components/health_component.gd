class_name HealthComponent
extends Node

signal hp_change(hp: float, max_hp: float)
signal dead(damage_payload: DamageInstance)

@export var main_stats: StatsComponent

var max_hp: float = 0.0
var current_hp: float = 0.0
var is_dead: bool = false
var history_damage_taken: Array[DamageInstance] = []


func _ready() -> void:
	if main_stats == null:
		push_warning("main stats in healt component not set")
		return

	max_hp = main_stats.get_max_health()
	current_hp = max_hp
	main_stats.stats_changed.connect(_on_stats_changed)


func apply_damage(damage_payload: DamageInstance) -> void:
	if is_dead:
		return

	if main_stats == null:
		return

	print("getting damage", damage_payload, " flat ", damage_payload.amount)

	var damage := _apply_armor(damage_payload.amount)
	current_hp -= damage
	current_hp = clampf(current_hp, 0.0, max_hp)
	print("final damage ", damage)
	hp_change.emit(current_hp, max_hp)

	history_damage_taken.append(damage_payload)

	if current_hp <= 0.0:
		is_dead = true
		dead.emit(damage_payload)


func _apply_armor(amount: float) -> float:
	var armor: float = main_stats.get_armor()
	return max(0.0, amount - armor)


func apply_heal(ammount: float) -> void:
	if is_dead:
		return

	current_hp += ammount
	current_hp = clampf(current_hp, 0.0, max_hp)
	hp_change.emit(current_hp, max_hp)


func _on_stats_changed():
	var new_max_hp: float = main_stats.get_max_health()
	print("new max hp ", new_max_hp, " current hp ", max_hp)
	if max_hp != new_max_hp:
		current_hp = clampf(current_hp + (new_max_hp - max_hp), 0.0, new_max_hp)
		max_hp = new_max_hp
		hp_change.emit(current_hp, max_hp)
