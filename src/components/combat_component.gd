class_name CombatComponent
extends Node

@export var weapon_component: WeaponComponent
@export var action_component: ActionComponent

func _ready() -> void:
	if action_component == null:
		push_warning("action component is null for combat component")
		return

	if weapon_component == null:
		push_warning("_ready() weapon component is null for combat component")
	
	action_component.attack_action.connect(_on_attack_action)

	
func _on_attack_action() -> void:
	if weapon_component == null:
		push_warning("_on_attack_action() weapon component is null for combat component")
		return
	
	weapon_component.try_attack()