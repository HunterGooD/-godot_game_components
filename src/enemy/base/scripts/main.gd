extends Node2D

@export var rect: ColorRect
@export var label: Label

var win_text: StringName = &"You win"
var failed_text: StringName = &"Game Over"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.player_died.connect(_on_player_death)
	GameEvents.enemy_died.connect(_on_enemy_died)


func _on_player_death(_event: ActorDeathEvent) -> void:
	label.text = failed_text
	rect.visible = true


func _on_enemy_died(_event: ActorDeathEvent) -> void:
	label.text = win_text
	GameEvents.run_victory.emit()
	rect.visible = true


func _on_button_pressed() -> void:
	GameManager.restart_run()
