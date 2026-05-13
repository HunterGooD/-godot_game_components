class_name StatusEffectReceiverComponent
extends Node

@export var main_stats: StatsComponent
@export var health_component: HealthComponent

var current_effects: Dictionary[StringName, StatusEffectInstance] = {}


func _process(delta: float) -> void:
	for effect_id in current_effects.keys():
		print("have is ", effect_id)
		var instance: StatusEffectInstance = current_effects[effect_id]
		instance.remaining_time -= delta

		match instance.definition.effect_type:
			StatusEffectResource.EffectType.DOT:
				_process_default_dot(instance, delta)

				if instance.remaining_time <= 0.0:
					_remove_effect(effect_id)

			StatusEffectResource.EffectType.SPEED:
				if instance.remaining_time <= 0.0:
					_remove_effect(effect_id)

			StatusEffectResource.EffectType.MAX_HP:
				if instance.remaining_time <= 0.0:
					_remove_effect(effect_id)


func _process_default_dot(inst: StatusEffectInstance, delta: float) -> void:
	inst.tick_timer += delta
	print(
		"tick timer ",
		inst.tick_timer,
		" tick interval ",
		inst.definition.tick_interval,
		" duration ",
		inst.remaining_time,
		" delta ",
		delta
	)
	if inst.remaining_time >= 0.0 && inst.tick_timer < inst.definition.tick_interval:
		return

	inst.tick_timer = 0.0

	if health_component == null:
		return

	var tick_damage := inst.definition.damage_per_stack * float(inst.stacks)

	var dot_type: StringName = inst.definition.DOTType.keys()[inst.definition.dot_type]
	var damage := DamageInstance.new(
		tick_damage, inst.source_damage.attacker, self, [dot_type, &"damage_over_time"], []
	)
	if health_component == null:
		push_warning("health component in status effect reciver is null")
		return
	health_component.apply_damage(damage)


func _remove_effect(effect_id: StringName) -> void:
	if not current_effects.has(effect_id):
		return

	var instance: StatusEffectInstance = current_effects[effect_id]

	if main_stats != null:
		main_stats.remove_modifiers_by_source(instance.source_id)

	current_effects.erase(effect_id)


func apply_effects(effects: Array[StatusEffectResource], damage: DamageInstance) -> void:
	for effect_resource in effects:
		print("GET THE EFFECT !!!!!!!!!!!!!!! ", effect_resource)
		apply_effect(effect_resource, damage)


func apply_effect(effect_def: StatusEffectResource, damage: DamageInstance) -> void:
	if effect_def == null:
		return

	match effect_def.effect_type:
		StatusEffectResource.EffectType.SPEED:
			_apply_speed(effect_def)

		StatusEffectResource.EffectType.DOT:
			_apply_dot(effect_def, damage)

		StatusEffectResource.EffectType.MAX_HP:
			pass


func _apply_speed(effect_def: StatusEffectResource):
	var effect_id := effect_def.id
	var instance: StatusEffectInstance
	var affix: float = 1.0

	var source_id := StringName(
		(
			"status:reciever:%s:%s"
			% [effect_def.SpeedType.keys()[effect_def.speed_type], get_instance_id()]
		)
	)
	var type_speed: StringName = StatusEffectResource.SpeedType.keys()[effect_def.speed_type]

	match effect_def.speed_type:
		StatusEffectResource.SpeedType.POSITIVE:
			affix = 1.0

		StatusEffectResource.SpeedType.NEGATIVE:
			affix = 0.0

	if current_effects.has(effect_id):
		instance = current_effects[effect_id]
		instance.stacks += 1
		instance.remaining_time = effect_def.duration
	else:
		instance = StatusEffectInstance.new(effect_def, null, source_id)
		current_effects[effect_id] = instance

	var speed_modifier: StatModifierInstance = (
		StatModifierInstance
		. new(
			StatEnums.StatType.MOVE_SPEED,
			StatEnums.Mode.MULTIPLY,
			(effect_def.speed_percent + affix) * instance.stacks,
			source_id,
			[type_speed, &"speed"],
		)
	)

	main_stats.remove_modifiers_by_source(source_id)
	main_stats.add_modifier(speed_modifier)
	current_effects[effect_id] = instance


func _apply_dot(effect_def: StatusEffectResource, damage: DamageInstance):
	match effect_def.dot_type:
		StatusEffectResource.DOTType.POTION, StatusEffectResource.DOTType.FIRE, StatusEffectResource.DOTType.CURSED, StatusEffectResource.DOTType.MADNES:
			_apply_default_dot(effect_def, damage)


func _apply_default_dot(
	effect_def: StatusEffectResource,
	damage: DamageInstance,
) -> void:
	var effect_id := effect_def.id
	var instance: StatusEffectInstance

	if current_effects.has(effect_id):
		instance = current_effects[effect_id]
		instance.stacks += 1
		instance.remaining_time = effect_def.duration
		instance.source_damage = damage
	else:
		var source_id := StringName(
			(
				"status:reciever:%s:%s"
				% [effect_def.DOTType.keys()[effect_def.dot_type], get_instance_id()]
			)
		)
		instance = StatusEffectInstance.new(effect_def, damage, source_id)
		current_effects[effect_id] = instance
