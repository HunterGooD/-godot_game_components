class_name HurtBoxComponent
extends Area2D

@export var health_component: HealthComponent

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	print("asdasdas")
	if area is HitBoxComponent:
		var hit_box: HitBoxComponent = area as HitBoxComponent

		if hit_box.payload != null && health_component != null:
			health_component.apply_damage(hit_box.payload)
		else:
			push_warning("hit box dont have payload or healht component dont set")
