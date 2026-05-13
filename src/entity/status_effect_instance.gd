class_name StatusEffectInstance
extends RefCounted

var definition: StatusEffectResource
var source_damage: DamageInstance
var source_id: StringName

var remaining_time: float
var stacks := 1
var tick_timer := 0.0


func _init(
	_definition: StatusEffectResource, _source_damage: DamageInstance, _source_id: StringName
) -> void:
	definition = _definition
	source_damage = _source_damage
	source_id = _source_id
	remaining_time = definition.duration
