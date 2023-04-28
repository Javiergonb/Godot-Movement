extends CharacterBody2D




# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

#input
var movement_input = Vector2.ZERO
var jump_input = false
var jump_input_actuation = false
var climb_input = false
var dash_input = false


#Movimiento del player
const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var last_direction = Vector2.RIGHT
#Estados/States
var current_state = null
var previous_state = null
#Mecanicas
var can_dash = true

#Nodos
@onready var STATES = $STATES
@onready var RayCasts = $Raycasts

func _ready():
	for state in STATES.get_children():
		state.STATES = STATES
		state.Player = self
	
	current_state = STATES.IDLE
	previous_state = STATES.IDLE

func _physics_process(delta):
	player_input()
	change_state(current_state.update(delta))
	#default_move(delta)
	$LABEL.text = str(current_state.get_name())
	move_and_slide()
	
func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_value * delta
		print("gravity: " , velocity)

func change_state(input_state):
	if input_state != null:
		previous_state = current_state
		current_state = input_state
		
		previous_state.exit_state()
		current_state.enter_state()
		
func player_input():
	movement_input = Vector2.ZERO
	
	#Movimiento
	if Input.is_action_pressed("MoveRight"):
		movement_input.x += 1
		
	if Input.is_action_pressed("MoveLeft"):
		movement_input.x -= 1
		
	if Input.is_action_pressed("MoveUp"):
		movement_input.y -= 1
		
	if Input.is_action_pressed("MoveDown"):
		movement_input.y += 1
		
		
	#Salto	
	if Input.is_action_pressed("Jump"):
		jump_input = true
	else:
		jump_input = false
		
	if Input.is_action_just_pressed("Jump"):
		jump_input_actuation = true
	else:
		jump_input_actuation = false
		
	#Trepar
	if Input.is_action_pressed("Climb"):
		climb_input = true
	else:
		climb_input = false
		
	#Dash
	if Input.is_action_just_pressed("Dash"):
		dash_input = true
	else:
		dash_input = false
	


func get_next_to_wall():
	for raycast in RayCasts.get_children():
		raycast.force_raycast_update()
		if raycast.is_colliding():
			if raycast.target_position.x > 0:
				return Vector2.RIGHT
			else:
				return Vector2.LEFT
	return null
	
	
