class_name WeaponComponent
extends Node

signal attack_started
signal attack_finished
signal attack_ready

enum WeaponState {
	READY,
	STARTUP,
	ACTIVE,
	RECOVERY,
}

@export var hit_box: HitBoxComponent
@export var main_stats: StatsComponent
@export var base_weapon_stats: WeaponStatResource
@export var actor: CharacterBody2D

var state: WeaponState = WeaponState.READY
var timer_recovery_attack: Timer
var timer_active_attack: Timer
var timer_attack_startup: Timer


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
	timer_recovery_attack.one_shot = true
	add_child(timer_recovery_attack)

	timer_active_attack = Timer.new()
	timer_active_attack.one_shot = true
	add_child(timer_active_attack)

	timer_attack_startup = Timer.new()
	timer_attack_startup.one_shot = true
	add_child(timer_attack_startup)

	timer_attack_startup.timeout.connect(_on_attack_startup)
	timer_active_attack.timeout.connect(_on_active_attack_timer_timeout)
	timer_recovery_attack.timeout.connect(_on_recovery_timer_timeout)


func try_attack() -> bool:
	if state != WeaponState.READY:
		return false

	if timer_attack_startup == null:
		push_warning("time attack delay is null in weapon component")
		return false

	_change_state(WeaponState.STARTUP)
	return true


func _change_state(next_state: WeaponState) -> void:
	if state == next_state:
		return

	state = next_state

	match state:
		WeaponState.READY:
			_enter_ready()

		WeaponState.STARTUP:
			_enter_startup()

		WeaponState.ACTIVE:
			_enter_active()

		WeaponState.RECOVERY:
			_enter_recovery()


func _enter_ready() -> void:
	attack_ready.emit()


func _enter_startup() -> void:
	attack_started.emit()
	if base_weapon_stats.delay_attack <= 0.0:
		_change_state(WeaponState.ACTIVE)
		return

	timer_attack_startup.start(base_weapon_stats.delay_attack)


func _enter_active() -> void:
	if hit_box == null:
		return

	hit_box.payload = DamageInstance.new(_get_damage(), actor)
	hit_box.enable_collision()

	if base_weapon_stats.active_time <= 0.0:
		_change_state(WeaponState.RECOVERY)
		return

	timer_active_attack.start(base_weapon_stats.active_time)


func _enter_recovery() -> void:
	if hit_box != null:
		hit_box.disable_collision()

	attack_finished.emit()

	if base_weapon_stats.recovery_time <= 0.0:
		_change_state(WeaponState.READY)
		return

	timer_recovery_attack.start(base_weapon_stats.recovery_time)


func _get_damage() -> float:
	return main_stats.get_damage() + base_weapon_stats.damage


func _on_active_attack_timer_timeout() -> void:
	if state != WeaponState.ACTIVE:
		return

	_change_state(WeaponState.RECOVERY)


func _on_attack_startup() -> void:
	if state != WeaponState.STARTUP:
		return

	_change_state(WeaponState.ACTIVE)


func _on_recovery_timer_timeout() -> void:
	if state != WeaponState.RECOVERY:
		return

	_change_state(WeaponState.READY)
