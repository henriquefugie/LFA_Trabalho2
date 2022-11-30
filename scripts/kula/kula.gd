extends CharacterBase2

func _process(delta: float) -> void:
	match state:
		StateMachine.IDLE: _state_idle(delta)
		StateMachine.WALK: _state_walk(delta)
		StateMachine.JUMP: _state_jump(delta)
		StateMachine.FALL: _state_fall(delta)
		
func _state_idle(delta: float) -> void:
	_set_animation("idle")	
	_apply_gravity(delta)
	_stop_movement()
	
	if direction:
		_enter_state(StateMachine.WALK)
	if Input.is_action_just_pressed("ui_up"):
		_enter_state(StateMachine.JUMP)
		
func _state_walk(delta: float) -> void:
	_set_animation("walk")
	_apply_gravity(delta)
	_move_and_slide(delta)
	_set_flip()
	
	if not direction:
		_enter_state(StateMachine.IDLE)
	if Input.is_action_just_pressed("ui_up"):
		_enter_state(StateMachine.JUMP)

func _state_jump(delta: float) -> void:
	_set_animation("jump")
	_apply_gravity(delta)
	_move_and_slide(delta)
	_set_flip()
	
	if enter_state:
		enter_state = false
		motion.y = -jump_force
	
	if motion.y > 0:
		_enter_state(StateMachine.FALL)
		
func _state_fall(delta: float) -> void:
	_set_animation("fall")
	_apply_gravity(delta)
	_move_and_slide(delta)
	_set_flip()
	
	if is_on_floor():
		_enter_state(StateMachine.IDLE)

