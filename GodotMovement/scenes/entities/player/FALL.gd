extends "state.gd"

@onready var CoyoteTimer = $CoyoteTimer
@export var coyote_duration = 0.2
var can_jump = true

func update(delta):
	Player.gravity(delta)
	player_movement()
	if Player.is_on_floor():
		return STATES.IDLE
		
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
		
	if Player.get_next_to_wall() != null:
		return STATES.SLIDE
		
	if Player.jump_input_actuation == true and can_jump:
		return STATES.JUMP
		
	return null
	
func enter_state():
	if Player.previous_state == STATES.IDLE or Player.previous_state == STATES.MOVE or Player.previous_state == STATES.SLIDE:
		can_jump = true
		
	else:
		can_jump = false
	CoyoteTimer.start(coyote_duration)
	
	pass
	


func _on_coyote_timer_timeout():
	can_jump = false
