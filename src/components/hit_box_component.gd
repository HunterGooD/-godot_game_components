class_name HitBoxComponent
extends Area2D

var payload: DamageInstance
var collision_shape: CollisionShape2D

func _ready() -> void:
	var node: Node = get_child(0)
	if node is CollisionShape2D:
		collision_shape = node as CollisionShape2D 

func collision_swap() -> void:
	if collision_shape == null:
		return

	collision_shape.disabled = !collision_shape.disabled
