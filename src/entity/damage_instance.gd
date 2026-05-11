class_name DamageInstance
extends RefCounted

var amount: float
var attacker: Node
var source: Node  # в основном для projectiles or traps
var tags: Array[StringName]
var status_effects: Array[StatusEffectResource]


func _init(
	_amount: float,
	_attacker: Node,
	_source: Node,
	_tags: Array[StringName] = [],
	_status_effects: Array[StatusEffectResource] = []
) -> void:
	amount = _amount
	attacker = _attacker
	_source = _source
	tags = _tags
	status_effects = _status_effects
