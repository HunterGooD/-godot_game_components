class_name StatusEffectResource
extends Resource

enum EffectType {
	SPEED,
	DOT,
	MAX_HP,
}

enum DOTType {
	POTION,
	FIRE,
	CURSED,
	MADNES,
}

enum SpeedType {
	NEGATIVE,  # slow
	POSITIVE,  # fast
}

@export var id: StringName
@export var effect_type: EffectType

@export var duration := 1.0

# SPEED:
@export var speed_percent := 0.0
@export var speed_max_total_percent := 0.0
@export var speed_type: SpeedType = SpeedType.NEGATIVE

# DOT
@export var damage_per_stack := 0.0
@export var tick_interval := 1.0
@export var max_stack: int = -1  # -1 infinity stack
@export var dot_type: DOTType = DOTType.POTION

# MAX_HP
@export var max_hp_down: float = 0
