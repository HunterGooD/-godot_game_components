class_name WeaponComponent
extends Node

signal attack_finished

@export var hit_box: HitBoxComponent
@export var main_stats: StatsComponent
@export var base_weapon_stats: WeaponStatResource
@export var actor: CharacterBody2D

var attack_available: bool = true
var timer_recovery_attack: Timer
var timer_active_attack: Timer
var timer_attack_delay: Timer


func _ready() -> void:
	if hit_box == null:
		push_warning("hit box is null in weapon component")
		return

	if main_stats == null:
		push_warning("main stats is null in weapon component")
		return

	if base_weapon_stats == null:
		push_warning("weapon stat resource is null for weapon component")
		return

	if actor == null:
		push_warning("actor is null for weapon component")
		return

	timer_recovery_attack = Timer.new()
	timer_recovery_attack.wait_time = base_weapon_stats.recovery_time
	timer_recovery_attack.one_shot = true
	add_child(timer_recovery_attack)

	timer_active_attack = Timer.new()
	timer_active_attack.wait_time = base_weapon_stats.active_time
	timer_active_attack.one_shot = true
	add_child(timer_active_attack)

	timer_attack_delay = Timer.new()
	timer_attack_delay.wait_time = base_weapon_stats.delay_attack
	timer_attack_delay.one_shot = true
	add_child(timer_attack_delay)

	timer_attack_delay.timeout.connect(_on_attack_delay)
	timer_active_attack.timeout.connect(_on_attack_timer_timeout)
	timer_recovery_attack.timeout.connect(_on_colldown_timer_timeout)


func try_attack() -> bool:
	if not attack_available:
		print("attack not available")
		return false

	if timer_attack_delay == null:
		push_warning("time attack delay is null in weapon component")

	timer_attack_delay.start()

	return true


func _get_damage() -> float:
	return main_stats.get_damage() + base_weapon_stats.damage


func _on_attack_timer_timeout() -> void:
	if timer_recovery_attack == null:
		push_warning("timer colldown is null for weapon componment")
		return

	hit_box.disable_collision()
	attack_finished.emit()
	timer_recovery_attack.start()


func _on_attack_delay() -> void:
	if timer_active_attack == null:
		push_warning("timer attacl is null for weapon componment")
		return

	attack_available = false
	hit_box.payload = DamageInstance.new(_get_damage(), actor)
	hit_box.enable_collision()
	timer_active_attack.start()


func _on_colldown_timer_timeout() -> void:
	attack_available = true
