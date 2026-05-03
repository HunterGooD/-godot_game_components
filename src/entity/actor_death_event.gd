class_name ActorDeathEvent
extends RefCounted

var actor: Node
var killer: Node
var position: Vector2
var actor_kind: StringName
var xp: int = 0
var tags: Array[StringName] = []
var recycle := true
var stats_modif: StatModifierInstance
