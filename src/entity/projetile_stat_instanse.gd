class_name ProjetileStatInstanse
extends RefCounted

var id: StringName
var speed: float
var lifetime: float
var destroy_on_hit: bool
var max_hits: int


func _init(
	_id: StringName,
	_speed: float,
	_lifetime: float,
	_destroy_on_hit: bool,
	_max_hits: int,
) -> void:
	id = _id
	speed = _speed
	lifetime = _lifetime
	destroy_on_hit = _destroy_on_hit
	max_hits = _max_hits
