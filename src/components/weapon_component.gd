class_name WeaponComponent
extends Node

signal attack_started
signal attack_finished
signal attack_ready
signal state_changed(previous_state: WeaponState, next_state: WeaponState)

enum WeaponState {
	READY,
	STARTUP,
	ACTIVE,
	RECOVERY,
}

@export var hit_box: HitBoxComponent
@export var marker: Marker2D
@export var main_stats: StatsComponent
@export var base_weapon_stats: WeaponStatResource
@export var actor: CharacterBody2D
@export var list_of_attacks_resources: Array[AttackResource] = []

var state: WeaponState = WeaponState.READY
var current_attack_idx: int = 0
var current_attack_resource: AttackResource = null
var timer_recovery_attack: Timer
var timer_active_attack: Timer
var timer_attack_startup: Timer


func _ready() -> void:
	if hit_box == null:
		push_warning("hit box is null in weapon component")

	if main_stats == null:
		push_warning("main stats is null in weapon component")
		return

	if base_weapon_stats == null:
		push_warning("weapon stat resource is null for weapon component")
		return

	if actor == null:
		push_warning("actor is null for weapon component")

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

	if len(list_of_attacks_resources) == 0:
		print("dont set attacks in weapon", get_instance_id())
		return false

	_change_state(WeaponState.STARTUP)
	return true


func _change_state(next_state: WeaponState) -> void:
	if state == next_state:
		return

	print(
		(
			"Invalid weapon state transition: %s -> %s"
			% [
				WeaponState.keys()[state],
				WeaponState.keys()[next_state],
			]
		)
	)
	if not _can_transition(state, next_state):
		push_warning(
			(
				"Invalid weapon state transition: %s -> %s"
				% [
					WeaponState.keys()[state],
					WeaponState.keys()[next_state],
				]
			)
		)
		return

	var previous_state := state
	state = next_state
	state_changed.emit(previous_state, next_state)

	match state:
		WeaponState.READY:
			_enter_ready()

		WeaponState.STARTUP:
			_enter_startup()

		WeaponState.ACTIVE:
			_enter_active()

		WeaponState.RECOVERY:
			_enter_recovery()


func _can_transition(from_state: WeaponState, to_state: WeaponState) -> bool:
	match from_state:
		WeaponState.READY:
			return to_state == WeaponState.STARTUP

		WeaponState.STARTUP:
			return to_state == WeaponState.ACTIVE

		WeaponState.ACTIVE:
			return to_state == WeaponState.RECOVERY

		WeaponState.RECOVERY:
			return to_state == WeaponState.READY

	return false


func _enter_ready() -> void:
	attack_ready.emit()


func _enter_startup() -> void:
	attack_started.emit()
	if len(list_of_attacks_resources) == 0:
		print("dont set attacks in weapon", get_instance_id())
		return

	var attack_resource: AttackResource = list_of_attacks_resources[current_attack_idx]
	current_attack_idx = (current_attack_idx + 1) % len(list_of_attacks_resources)
	current_attack_resource = attack_resource

	if attack_resource.startup_time <= 0.0:
		_change_state(WeaponState.ACTIVE)
		return

	timer_attack_startup.start(current_attack_resource.startup_time)


func _enter_active() -> void:
	if current_attack_resource == null:
		push_warning("attack resource is null ")
		_change_state(WeaponState.READY)
		return

	print(current_attack_resource.delivery_type)
	match current_attack_resource.delivery_type:
		AttackResource.DeliveryType.MELEE_HITBOX:
			_start_melee_attack(current_attack_resource)
		AttackResource.DeliveryType.PROJECTILE:
			_start_projectile_attack(current_attack_resource)


func _start_melee_attack(attack_resource: AttackResource) -> void:
	if hit_box == null:
		return

	hit_box.payload = DamageInstance.new(
		_get_damage(attack_resource),
		actor,
		hit_box,
		attack_resource.damage_tags,
		attack_resource.status_effects
	)
	hit_box.enable_collision()

	if base_weapon_stats.active_time <= 0.0:
		_change_state(WeaponState.RECOVERY)
		return

	timer_active_attack.start(current_attack_resource.active_time)


func _start_projectile_attack(_attack_resource: AttackResource) -> void:
	if _attack_resource.projectile_resource == null:
		push_warning("not found projectile resource in weapon ")
		_change_state(WeaponState.READY)
		return
	if marker == null:
		return
	var direction := _get_attack_direction()
	var projectile_resource := _attack_resource.projectile_resource
	var projectile := projectile_resource.projectile_scene.instantiate() as Projectile
	if projectile == null:
		push_warning("projectile scene root must have Projectile script")
		_change_state(WeaponState.RECOVERY)
		return
	get_tree().current_scene.add_child(projectile)

	(
		projectile
		. setup(
			marker.global_position,
			direction,
			(
				ProjetileStatInstanse
				. new(
					projectile_resource.id,
					projectile_resource.speed,
					projectile_resource.lifetime,
					projectile_resource.destroy_on_hit,
					projectile_resource.max_hits,
				)
			),
			#		hit_box.collision_layer,
			#		hit_box.collision_mask,
			projectile_resource.layer,
			projectile_resource.mask,
			DamageInstance.new(
				_get_damage(_attack_resource),
				actor,
				projectile,
				_attack_resource.damage_tags,
				_attack_resource.status_effects
			),
		)
	)
	if _attack_resource.active_time <= 0.0:
		_change_state(WeaponState.RECOVERY)
		return

	timer_active_attack.start(_attack_resource.active_time)


func _get_attack_direction() -> Vector2:
	if marker != null:
		var direction := Vector2.RIGHT.rotated(marker.global_rotation)

		if direction != Vector2.ZERO:
			return direction.normalized()
	return Vector2.RIGHT


func _enter_recovery() -> void:
	if hit_box != null:
		hit_box.disable_collision()

	attack_finished.emit()

	if base_weapon_stats.recovery_time <= 0.0:
		_change_state(WeaponState.READY)
		return

	timer_recovery_attack.start(current_attack_resource.recovery_time)


func _get_damage(attack_resource: AttackResource) -> float:
	return main_stats.get_damage() + attack_resource.damage * attack_resource.damage_multiplier


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
