extends CharacterBody2D

@export var main_stats: StatsComponent
@export var hit_box: HitBoxComponent

func _ready() -> void:
	if hit_box == null:
		push_warning("hit box base enemy is null")
		return
	
	if main_stats == null:
		push_warning("main stats base enemy is null")
		return

	hit_box.payload = DamageInstance.new(main_stats.get_damage(), self)


func _on_timer_timeout() -> void:
	hit_box.collision_swap()
