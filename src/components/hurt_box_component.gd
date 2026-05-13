class_name HurtBoxComponent
extends Area2D

@export var health_component: HealthComponent
@export var status_effect_receiver: StatusEffectReceiverComponent


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area is HitBoxComponent:
		var hit_box: HitBoxComponent = area as HitBoxComponent
		if hit_box.payload == null:
			push_warning("hit box dont have payload")
			return

		if health_component != null:
			health_component.apply_damage(hit_box.payload)

		if status_effect_receiver != null:
			print(hit_box.payload.status_effects)
			status_effect_receiver.apply_effects(hit_box.payload.status_effects, hit_box.payload)
