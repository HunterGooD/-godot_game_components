class_name Projectile
extends Node2D

signal finished(projectile: Projectile)

@export var hit_box: HitBoxComponent

var direction: Vector2 = Vector2.RIGHT
var speed: float = 600.0
var lifetime: float = 3.0

var _life_time_left: float = 0.0
var _is_active := false


func _ready() -> void:
	setup(
		position,
		direction,
		speed,
		3.0,
		DamageInstance.new(1.0, self, self),
	)
	hit_box.hit.connect(_on_hit)


func setup(
	start_position: Vector2,
	start_direction: Vector2,
	projectile_speed: float,
	projectile_lifetime: float,
	damage: DamageInstance
) -> void:
	global_position = start_position
	direction = start_direction.normalized()
	speed = projectile_speed
	lifetime = projectile_lifetime
	_life_time_left = lifetime
	_is_active = true

	if direction != Vector2.ZERO:
		rotation = direction.angle()

	if hit_box != null:
		hit_box.payload = damage
		hit_box.enable_collision()


func _physics_process(delta: float) -> void:
	if not _is_active:
		return

	global_position += direction * speed * delta

	_life_time_left -= delta
	if _life_time_left <= 0.0:
		_finish()


func _on_hit(_area2d: Area2D) -> void:
	_finish()


func _finish() -> void:
	if not _is_active:
		return

	set_process(false)
	_is_active = false

	finished.emit(self)
	queue_free()
