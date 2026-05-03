extends Node2D

@export var rect: ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.player_died.connect(_on_player_death)


func _on_player_death(event: ActorDeathEvent) -> void:
	rect.visible = true


func _on_button_pressed() -> void:
	GameManager.restart_run()
