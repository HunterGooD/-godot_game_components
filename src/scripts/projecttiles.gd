class_name Projectile
extends Node2D

signal finished(projectile: Projectile)

@export var hit_box: HitBoxComponent

var direction: Vector2 = Vector2.RIGHT
var main_stat: ProjetileStatInstanse

var _life_time_left: float = 0.0
var _hits_count := 0
var _is_active := false


func _ready() -> void:
	if hit_box == null:
		push_warning("hit_box is null in Projectile")
		return
	hit_box.hit.connect(_on_hit)
	hit_box.disable_collision()



func setup(
	start_position: Vector2,
	start_direction: Vector2,
	projectile_stat: ProjetileStatInstanse,
	layer: int,
	mask: int,
	damage: DamageInstance
) -> void:
	global_position = start_position
	direction = start_direction.normalized()
	main_stat = projectile_stat
	_life_time_left = main_stat.lifetime
	_is_active = true

	if direction != Vector2.ZERO:
		rotation = direction.angle()

	if hit_box != null:
		hit_box.payload = damage
		hit_box.set_collision_layer_value(layer, true)
		hit_box.set_collision_mask_value(mask, true)
		hit_box.enable_collision()


func _physics_process(delta: float) -> void:
	if not _is_active:
		return

	global_position += direction * main_stat.speed * delta

	_life_time_left -= delta
	if _life_time_left <= 0.0:
		_finish()


func _on_hit(_area2d: Area2D) -> void:
	_hits_count += 1

	if main_stat.destroy_on_hit:
		_finish()
		return

	if main_stat.max_hits >= 0 and _hits_count >= main_stat.max_hits:
		_finish()


func _finish() -> void:
	if not _is_active:
		return

	set_process(false)
	set_physics_process(false)

	_is_active = false

	finished.emit(self)
	queue_free()
