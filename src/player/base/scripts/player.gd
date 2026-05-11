extends CharacterBody2D

@export var label: Label
@export var healt_component: HealthComponent


func _ready() -> void:
	if healt_component == null:
		push_warning("health_component is null")
		return

	healt_component.hp_change.connect(set_text)
	set_text(healt_component.current_hp, healt_component.max_hp)
	healt_component.dead.connect(_on_died_signal)


func set_text(current_hp: float, max_hp: float) -> void:
	if label == null:
		push_warning("label in player is null")
		return

	if healt_component == null:
		push_warning("health component is null")
		return

	label.text = str(int(current_hp), "/", int(max_hp))


func _on_died_signal(damage_payload: DamageInstance) -> void:
	set_process(false)
	var event: ActorDeathEvent = ActorDeathEvent.new()
	event.actor = self
	event.actor_kind = &"player"
	event.killer = damage_payload.attacker
	event.position = position
	event.xp = 10

	GameEvents.player_died.emit(event)
	queue_free()
