class_name StatsComponent
extends Node

signal stats_changed(type: StatEnums.StatType, value: float)

@export var base_stats: ActorStatsResource

var modifiers: Array[StatModifierInstance] = []

func add_modifier(mod: StatModifierInstance) -> void:
	modifiers.append(mod)
	stats_changed.emit(mod.stat_type, mod.value)

func remove_modifiers_by_source(source_id: StringName) -> void:
	var idx: int = modifiers.find_custom(func(m: StatModifierInstance): return m.source_id == source_id)
	var mod: StatModifierInstance = modifiers.get(idx)
	modifiers = modifiers.filter(func(m: StatModifierInstance): return m.source_id != source_id)
	if mod != null:
		stats_changed.emit(mod.stat_type, mod.value)

func get_stat(stat_id: StatEnums.StatType) -> float:
	var value := _get_base_value(stat_id)

	for mod in modifiers:
		if mod.stat_type == stat_id and mod.mode == StatEnums.Mode.FLAT:
			value += mod.value

	for mod in modifiers:
		if mod.stat_type == stat_id and mod.mode == StatEnums.Mode.MULTIPLY:
			value *= (1.0 + mod.value)

	return value

func get_max_health() -> float:
	return get_stat(StatEnums.StatType.MAX_HEALTH)

func get_move_speed() -> float:
	return get_stat(StatEnums.StatType.MOVE_SPEED)

func get_armor() -> float:
	return get_stat(StatEnums.StatType.ARMOR)

func get_damage() -> float:
	return get_stat(StatEnums.StatType.DAMAGE)

func get_dash_charges() -> int:
	return max(0, int(round(get_stat(StatEnums.StatType.DASH_CHARGES))))

func _get_base_value(stat_id: StatEnums.StatType) -> float:
	match stat_id:
		StatEnums.StatType.MAX_HEALTH:
			return base_stats.max_health
		StatEnums.StatType.MOVE_SPEED:
			return base_stats.move_speed
		StatEnums.StatType.ARMOR:
			return base_stats.armor
		StatEnums.StatType.DAMAGE:
			return base_stats.damage
		StatEnums.StatType.DASH_CHARGES:
			return float(base_stats.dash_charges)
		_:
			return 0.0