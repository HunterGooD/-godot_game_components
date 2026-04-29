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
	weapon_component.attack_finished.connect(_on_attack_finished)


func _on_attack_action() -> void:
	if weapon_component == null:
		push_warning("_on_attack_action() weapon component is null for combat component")
		return

	print("attack!!!!!!!!!!!!!")
	if not weapon_component.try_attack():
		print("attack finished!!!!!!!!!!!!!")
		action_component.attack_finished.emit()

func _on_attack_finished(): 
	action_component.attack_finished.emit()