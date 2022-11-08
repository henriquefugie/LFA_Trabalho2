class_name CharacterBase extends KinematicBody2D

enum StateMachine { IDLE, WALK, JUMP, FALL, JUMP2, ATK1, ATK2, ATK3, CROUNCH, ESPECIAL}

export var speed := 100
export var jump_force := 100
export var gravity := 98

var state = StateMachine.WALK
var motion := Vector2()
var animation := ""
var direction = 0
var enter_state := true

onready	var sprite: Sprite = get_node("Sprite")
onready	var animator: AnimationPlayer = get_node("AnimationPlayer")
onready var timer_attack: Timer = get_node("TimerAttack")

func _process(delta: float) -> void:
	direction = Input.get_axis("ui_left", "ui_right")
	
func _physics_process(delta: float) -> void:
	motion = move_and_slide(motion, Vector2.UP)

func _move_and_slide(delta: float) -> void:
	motion.x = direction * speed
	
func _apply_gravity(delta: float) -> void:
	motion.y += gravity * delta
	
func _set_animation(anim: String) -> void:
	if animation != anim:
		animation = anim
		animator.play(animation)
	
func _stop_movement() -> void:
	motion.x = 0

func _set_flip() -> void:
	if direction:
		sprite.flip_h = false if direction > 0 else true
		
func _enter_state(new_state) -> void:
	if state != new_state:
		state = new_state
		enter_state = true
