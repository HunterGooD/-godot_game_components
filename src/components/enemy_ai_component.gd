class_name EnemyAiComponent
extends MoveDirectionComponent

@export var aggro_range: DetectionComponent
@export var lose_range: DetectionComponent
@export var attack_range: DetectionComponent
@export var enemy: Node2D
@export var action_component: ActionComponent

var target: Node2D = null
var state: ActorState.BaseState = ActorState.BaseState.IDLE

var is_attacking: bool = false
var target_in_attack_range: bool = false


func _ready() -> void:
	if aggro_range == null:
		push_warning("aggro range is null")
		return

	if lose_range == null:
		push_warning("lose range is null")
		return

	if attack_range == null:
		push_warning("attack range is null")
		return

	aggro_range.body_entered.connect(_on_aggro_body_entered)
	lose_range.body_exited.connect(_on_lose_body_exited)
	attack_range.body_entered.connect(_on_attack_body_entered)
	attack_range.body_exited.connect(_on_attack_body_exited)

	action_component.attack_finished.connect(_on_attack_finished)
	action_component.attack_ready.connect(_on_attack_ready)
	action_component.attack_cancelled.connect(_on_attack_cancelled)


func get_vector() -> Vector2:
	match state:
		ActorState.BaseState.ATTACK:
			return Vector2.ZERO
		ActorState.BaseState.IDLE:
			return Vector2.ZERO
		ActorState.BaseState.RUN:
			if target == null:
				return Vector2.ZERO

			return enemy.global_position.direction_to(target.global_position)
	# по умолчанию не понимаем что надо и пусть стоит
	return Vector2.ZERO


func change_state(next_state: ActorState.BaseState) -> void:
	print(
		"change states ",
		ActorState.BaseState.keys()[state],
		ActorState.BaseState.keys()[next_state]
	)

	if state == next_state:
		return

	if not ActorState.can_transition(state, next_state):
		push_warning(
			(
				"Invalid enemy state transition: %s -> %s"
				% [
					ActorState.BaseState.keys()[state],
					ActorState.BaseState.keys()[next_state],
				]
			)
		)
		return

	if is_attacking and state == ActorState.BaseState.ATTACK:
		if next_state != ActorState.BaseState.IDLE:
			return

	var previous_state := state
	print(
		"change states ",
		ActorState.BaseState.keys()[state],
		" -> ",
		ActorState.BaseState.keys()[next_state]
	)
	_exit_state(previous_state)
	state = next_state
	_enter_state(next_state)


func _enter_state(new_state: ActorState.BaseState) -> void:
	match new_state:
		ActorState.BaseState.IDLE:
			print("Enemy enter IDLE")

		ActorState.BaseState.RUN:
			print("Enemy enter RUN")

		ActorState.BaseState.ATTACK:
			print("Enemy enter ATTACK")
			_start_attack()


func _exit_state(old_state: ActorState.BaseState) -> void:
	match old_state:
		ActorState.BaseState.IDLE:
			print("Enemy exit IDLE")

		ActorState.BaseState.RUN:
			print("Enemy exit RUN")

		ActorState.BaseState.ATTACK:
			print("Enemy exit ATTACK")


func _start_attack() -> void:
	if is_attacking:
		return

	is_attacking = true
	action_component.attack_action.emit()


func _on_aggro_body_entered(body: Node2D) -> void:
	print("entered", body)
	if target != null:
		return

	target = body
	change_state(ActorState.BaseState.RUN)


func _on_lose_body_exited(body: Node2D) -> void:
	print(
		"exited",
		body,
		" TARGET ",
		target,
		" iis attack range ",
		target_in_attack_range,
		" state ",
		ActorState.BaseState.keys()[state]
	)
	if body != target:
		return

	target = null
	target_in_attack_range = false

	if is_attacking:
		return

	change_state(ActorState.BaseState.IDLE)


func _on_attack_body_entered(body: Node2D) -> void:
	if body != target:
		return

	target_in_attack_range = true

	if is_attacking:
		return

	change_state(ActorState.BaseState.ATTACK)


func _on_attack_body_exited(body: Node2D) -> void:
	if body != target:
		return

	target_in_attack_range = false

	if is_attacking:
		return

	change_state(ActorState.BaseState.RUN)


func _on_attack_finished() -> void:
	is_attacking = false

	if target == null:
		change_state(ActorState.BaseState.IDLE)
		return

	change_state(ActorState.BaseState.IDLE)


func _on_attack_cancelled() -> void:
	is_attacking = false

	if target_in_attack_range:
		change_state(ActorState.BaseState.IDLE)
		return
	change_state(ActorState.BaseState.RUN)


func _on_attack_ready() -> void:
	if target_in_attack_range:
		print("change to ATTACK")
		change_state(ActorState.BaseState.ATTACK)
		return
	change_state(ActorState.BaseState.RUN)
