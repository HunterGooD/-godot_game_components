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


func get_vector() -> Vector2:
	if is_attacking:
		return Vector2.ZERO
	match state:
		ActorState.BaseState.ATTACK:
			action_component.attack_action.emit()
			is_attacking = true
			return Vector2.ZERO
		ActorState.BaseState.IDLE:
			return Vector2.ZERO
		ActorState.BaseState.RUN:
			var direction: Vector2 = enemy.global_position.direction_to(target.global_position)
			return direction
	# по умолчанию не понимаем что надо и пусть стоит
	return Vector2.ZERO


func _on_aggro_body_entered(body: Node2D) -> void:
	print("entered", body)
	if target != null:
		return
	state = ActorState.BaseState.RUN
	target = body


func _on_lose_body_exited(_body: Node2D) -> void:
	print("exited", _body)
	target = null
	state = ActorState.BaseState.IDLE


func _on_attack_body_entered(_body: Node2D) -> void:
	state = ActorState.BaseState.ATTACK


func _on_attack_body_exited(_body: Node2D) -> void:
	state = ActorState.BaseState.RUN
	is_attacking = false


func _on_attack_finished():
	is_attacking = false
	print("attack finis ", is_attacking, " state ", state)
