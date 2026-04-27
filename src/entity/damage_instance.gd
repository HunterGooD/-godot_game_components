class_name DamageInstance
extends RefCounted

var amount: float
var source: Node

func _init(_amount: float, _source: Node = null) -> void:
	amount = _amount
	source = _source
