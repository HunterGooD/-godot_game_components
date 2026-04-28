class_name DirectionComponent
extends Node

@export var sprite_2d: Sprite2D
@export var hit_box: HitBoxComponent
@export var hurt_box: HurtBoxComponent
@export var action_component: ActionComponent

var facing: DirectionEnums.Facing


func _ready() -> void:
	action_component.last_direction.connect(_on_last_direction)
	change_direction()


func _on_last_direction(_direction: Vector2) -> void:
	if _direction.length() == 0:
		return

	if abs(_direction.x) >= abs(_direction.y):
		if _direction.x > 0:
			facing = DirectionEnums.Facing.RIGHT
		else:
			facing = DirectionEnums.Facing.LEFT
	else:
		if _direction.y > 0:
			facing = DirectionEnums.Facing.UP
		else:
			facing = DirectionEnums.Facing.DOWN

	change_direction()


func change_direction() -> void:
	change_sprite()

	if hit_box != null:
		hit_box.flip_collision(facing)


func change_sprite() -> void:
	if sprite_2d == null:
		return

	match facing:
		DirectionEnums.Facing.RIGHT:
			sprite_2d.flip_h = false
		DirectionEnums.Facing.LEFT:
			sprite_2d.flip_h = true
