class_name HitBoxComponent
extends Area2D

signal hit(area2d: Area2D)

@export var offset_collision: Vector2

@export var collision_shape: CollisionShape2D
var payload: DamageInstance


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area2d: Area2D) -> void:
	if area2d is HurtBoxComponent:
		hit.emit(area2d)


func enable_collision() -> void:
	if collision_shape == null:
		return

	collision_shape.disabled = false


func disable_collision() -> void:
	if collision_shape == null:
		return

	collision_shape.disabled = true


func flip_collision(facing: DirectionEnums.Facing) -> void:
	if collision_shape == null:
		return

	match facing:
		DirectionEnums.Facing.RIGHT:
			collision_shape.position.x = offset_collision.x
			collision_shape.position.y = 0.0
			collision_shape.rotation = 0.0
		DirectionEnums.Facing.LEFT:
			collision_shape.position.x = offset_collision.x * -1
			collision_shape.position.y = 0.0
			collision_shape.rotation = 0.0
		DirectionEnums.Facing.UP:
			collision_shape.position.y = offset_collision.y
			collision_shape.position.x = 0.0
			collision_shape.rotation = 0.0
			collision_shape.rotate(deg_to_rad(90))
		DirectionEnums.Facing.DOWN:
			collision_shape.position.y = offset_collision.y * -1
			collision_shape.position.x = 0.0
			collision_shape.rotation = 0.0
			collision_shape.rotate(deg_to_rad(90))
