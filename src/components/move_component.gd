class_name MoveComponent
extends Node

@export var target: Node
@export var main_stats: StatsComponent
@export var move_direction: MoveDirectionComponent


func _physics_process(_delta: float) -> void:
	if target == null:
		return

	var direction := move_direction.get_vector()
	target.velocity = direction * main_stats.get_move_speed()
	target.move_and_slide()
