class_name ProjectileResource
extends Resource

@export var id: StringName

@export var projectile_scene: PackedScene = null

@export var layer: int
@export var mask: int

@export var speed := 600.0
@export var lifetime := 3.0

@export var destroy_on_hit := true
@export var max_hits := -1  # infinite
