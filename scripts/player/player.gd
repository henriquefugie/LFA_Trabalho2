extends CharacterBase

export var max_jumps := 2
var combostage := 0
var jumps := 0
var sequence = []
var moves = {"especial1" : ["ui_down","direction","ui_attack"]}

func _process(delta: float) -> void:
	match state:
		StateMachine.IDLE: _state_idle(delta)
		StateMachine.WALK: _state_walk(delta)
		StateMachine.JUMP: _state_jump(delta)
		StateMachine.FALL: _state_fall(delta)
		StateMachine.JUMP2: _state_jump2(delta)
		StateMachine.ATK1: _state_atk1(delta)
		StateMachine.ATK2: _state_atk2(delta)
		StateMachine.ATK3: _state_atk3(delta)
		StateMachine.CROUNCH: _state_crounch(delta)
		StateMachine.ESPECIAL: _state_especial(delta)
		
func _state_idle(delta: float) -> void:
	_set_animation("idle")	
	_apply_gravity(delta)
	_stop_movement()
	
	if enter_state:
		combostage = 0
		
	if direction:
		_enter_state(StateMachine.WALK)
	if Input.is_action_just_pressed("ui_up"):
		_enter_state(StateMachine.JUMP)
	if Input.is_action_just_pressed("ui_attack"):
		_enter_state(StateMachine.ATK1)
	if Input.is_action_just_pressed("ui_down"):
		_enter_state(StateMachine.CROUNCH)
	if Input.is_action_just_pressed("ui_especial"):
		_enter_state(StateMachine.ESPECIAL)


func _state_walk(delta: float) -> void:
	_set_animation("walk")
	_apply_gravity(delta)
	_move_and_slide(delta)
	_set_flip()
	
	if not direction:
		_enter_state(StateMachine.IDLE)
	if Input.is_action_just_pressed("ui_up"):
		_enter_state(StateMachine.JUMP2)
	if Input.is_action_just_pressed("ui_attack"):
		_enter_state(StateMachine.ATK1)
	if Input.is_action_just_pressed("ui_down"):
		_enter_state(StateMachine.CROUNCH)
		
func _state_jump(delta: float) -> void:
	_set_animation("jump")
	_apply_gravity(delta)
	_move_and_slide(delta)
	_set_flip()
	
	if enter_state:
		enter_state = false
		motion.y = -jump_force
		jumps += 1
	
	if motion.y > 0:
		_enter_state(StateMachine.FALL)
		
	if Input.is_action_just_pressed("ui_up") and jumps < max_jumps:
		_enter_state(StateMachine.JUMP2)
		
func _state_fall(delta: float) -> void:
	_set_animation("fall")
	_apply_gravity(delta)
	_move_and_slide(delta)
	_set_flip()
	
	if is_on_floor():
		_enter_state(StateMachine.IDLE)
		
	if Input.is_action_just_pressed("ui_up") and jumps < max_jumps:
		_enter_state(StateMachine.JUMP2)
		
func _state_jump2(delta: float) -> void:
	_set_animation("jump_2")
	_apply_gravity(delta)
	_move_and_slide(delta)
	_set_flip()
	
	if enter_state:
		enter_state = false
		motion.y = -jump_force
		jumps += 1
		
	if motion.y > 0:
		_enter_state(StateMachine.FALL)
		
	if Input.is_action_just_pressed("ui_up") and jumps < max_jumps:
		motion.y = -jump_force
		
func _state_atk1(delta: float) -> void:
	_set_animation("atk1")
	_stop_movement()
	 
	if enter_state:
		enter_state = false
		timer_attack.wait_time = 0.6
		timer_attack.start()
	
	if Input.is_action_just_pressed("ui_attack"):
		timer_attack.stop()
		_enter_state(StateMachine.ATK2)
		
func _state_atk2(delta: float) -> void:
	_set_animation("atk2")
	_stop_movement()
	 
	if enter_state:
		enter_state = false
		timer_attack.wait_time = 0.6
		timer_attack.start()
		
	if Input.is_action_just_pressed("ui_attack"):
		timer_attack.stop()
		_enter_state(StateMachine.ATK3)

func _state_atk3(delta: float) -> void:
	_set_animation("atk3")
	_stop_movement()
	 
	if enter_state:
		enter_state = false
		timer_attack.wait_time = 0.6
		timer_attack.start()
	
func _state_crounch(delta: float) -> void:
	_set_animation("crounch")
	_stop_movement()
	
	
	if enter_state:
		enter_state = false
		timer_attack.start()
		combostage += 1
	if direction:
		timer_attack.stop()
		_set_flip()
		timer_attack.start()
		if Input.is_action_just_released("ui_down"):
			timer_attack.stop()
			timer_attack.start()
			if Input.is_action_pressed("ui_attack"):
				timer_attack.stop()
				_enter_state(StateMachine.ESPECIAL)
#	if Input.is_action_just_released("ui_down") and direction:
#		_enter_state(StateMachine.WALK)
#	if Input.is_action_just_released("ui_down") and not direction:
#			_enter_state(StateMachine.IDLE)
	
		
		
func _state_especial(delta: float) -> void:
	_set_animation("especial")
	_stop_movement()
	 
	if enter_state:
		enter_state = false
		yield(get_tree().create_timer(1.0), "timeout")
		_enter_state(StateMachine.IDLE)
		
func _on_TimerAttack_timeout():
	_enter_state(StateMachine.IDLE)
