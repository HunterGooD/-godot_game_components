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
	healt_component.dead.connect(_on_died_signal)
	set_text(healt_component.current_hp, healt_component.max_hp)


func set_text(current_hp: float, max_hp: float) -> void:
	if label == null:
		push_warning("label in base enemy is null")
		return

	label.text = str(int(current_hp), "/", int(max_hp))


func _on_died_signal() -> void:
	set_process(false)
	var event: ActorDeathEvent = ActorDeathEvent.new()
	event.actor = self
	event.actor_kind = &"enemy"
#	event.killer = NULL # подумать как тут получать того кто убил
	event.position = position
	event.xp = 10
	event.stats_modif = StatModifierInstance.new(
		StatEnums.StatType.MAX_HEALTH,
		StatEnums.Mode.FLAT,
		10.0,
		&"max_hp_for_kill",
		[&"kill", &"enemy", &"flat_hp"]
	)

	GameEvents.enemy_died.emit(event)
	queue_free()
