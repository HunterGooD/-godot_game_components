extends Node

enum RunState {
	NOT_STARTED,
	RUNNING,
	PAUSED,
	LEVEL_UP_SELECT,
	DEFEAT,
	VICTORY,
}

var state: RunState = RunState.NOT_STARTED


func _ready() -> void:
	GameEvents.player_died.connect(_on_player_died)
	GameEvents.run_victory.connect(_on_run_victory)
	GameEvents.level_up.connect(_on_level_up)
	start_run()


func start_run() -> void:
	if state == RunState.RUNNING:
		return

	state = RunState.RUNNING
	get_tree().paused = false


func pause_run() -> void:
	if state != RunState.RUNNING:
		return

	state = RunState.PAUSED
	get_tree().paused = true


func resume_run() -> void:
	if state != RunState.PAUSED and state != RunState.LEVEL_UP_SELECT:
		return

	state = RunState.RUNNING
	get_tree().paused = false


func fail_run() -> void:
	if state == RunState.DEFEAT:
		return

	state = RunState.DEFEAT
	get_tree().paused = true


func victory_run() -> void:
	if state == RunState.VICTORY:
		return

	state = RunState.VICTORY
	get_tree().paused = true


func restart_run() -> void:
	get_tree().paused = false
	state = RunState.RUNNING
	get_tree().reload_current_scene()


func _on_player_died(_event: ActorDeathEvent) -> void:
	fail_run()


func _on_run_victory() -> void:
	victory_run()


func _on_level_up() -> void:
	if state != RunState.RUNNING:
		return

	state = RunState.LEVEL_UP_SELECT
	get_tree().paused = true
