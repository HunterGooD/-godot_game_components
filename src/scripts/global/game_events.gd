extends Node

# Глобальная шина событий

# IN GAME
signal enemy_died(event: ActorDeathEvent)
signal player_died(event: ActorDeathEvent)
signal level_up

# GLOBAL states
signal run_started
signal run_paused
signal run_resumed
signal run_failed
signal run_victory
