extends "state.gd"
var dash_direction = Vector2.ZERO
var dash_speed = 400
var dashing = false

@export var dash_duration = 0.2
@onready var DashDuration_Timer = $DashDuration

func update(delta):
	if not dashing:
		return STATES.FALL
	return null
	
func enter_state():
	Player.can_dash = false
	dashing = true
	DashDuration_Timer.start(dash_duration)
	if Player.movement_input != Vector2.ZERO:
		dash_direction = Player.movement_input
		
	else:
		dash_direction = Player.last_direction
	Player.velocity = dash_direction.normalized() * dash_speed
	
	
	
func exit_state():
	dashing = false


func _on_timer_timeout():
	dashing = false
	
