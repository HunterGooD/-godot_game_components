class_name ActorState
extends RefCounted

enum BaseState {
	IDLE,
	RUN,
	ATTACK,
}


static func can_transition(from_state: BaseState, to_state: BaseState) -> bool:
	if from_state == to_state:
		return false

	match from_state:
		BaseState.IDLE:
			return (
				to_state
				in [
					BaseState.RUN,
					BaseState.ATTACK,
				]
			)

		BaseState.RUN:
			return (
				to_state
				in [
					BaseState.IDLE,
					BaseState.ATTACK,
				]
			)

		BaseState.ATTACK:
			return (
				to_state
				in [
					BaseState.IDLE,
					BaseState.RUN,
				]
			)

	return false
