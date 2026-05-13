# временный класс для проверки спавна проджектайлов тут обитает хардкод
extends Node2D

@export var marker: Marker2D
@export var weapon: WeaponComponent

var target: CharacterBody2D


func _ready() -> void:
	var n := get_tree()
	var p := n.root.get_node("Main/Player")
	if p is CharacterBody2D:
		target = p


func _physics_process(_delta: float) -> void:
	look_at(target.position)


func _on_timer_timeout() -> void:
	weapon.try_attack()
