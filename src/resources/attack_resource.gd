class_name AttackResource
extends Resource

enum DeliveryType {
	MELEE_HITBOX,
	PROJECTILE,
}

@export var id: StringName
@export var delivery_type: DeliveryType

@export var damage := 1.0
@export var damage_multiplier := 1.0
@export var damage_tags: Array[StringName] = []

@export var startup_time := 0.1
@export var active_time := 0.1
@export var recovery_time := 0.3

@export var projectile_resource: ProjectileResource
#
@export var status_effects: Array[StatusEffectResource] = []
