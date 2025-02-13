extends CharacterBody2D
const CommandEnum = preload("res://Global/CommandEnum.gd").Commands

@export var defaultJumpCount = 2
@export var jumpCount = 2
@export var jumpVelocity = -400.0
@export var Speed = 300.0
var defaultDirection = 1.0
var faceDirection = defaultDirection
#enum {DOWNBACK=1,DOWN=2,DOWNFORWARD=3,BACK=4,NEUTRAL=5,FORWARD=6,UPBACK=7,UP=8,UPFORWARD=9}
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func jump():
	if not ($StateMachine.currentState is PlayerRecovery):
		jumpCount -= 1
		velocity.y = jumpVelocity

func crouch():
	if not ($StateMachine.currentState is PlayerRecovery):
		transform = Transform2D(
			transform.get_rotation(),
			Vector2(transform.get_scale().x,
			(transform.get_scale().y)/2), 
			transform.get_skew(),
			Vector2(transform.get_origin().x,(transform.get_origin().y)+transform.get_scale().y/2))
func stand():
	if not ($StateMachine.currentState is PlayerRecovery):
		transform = Transform2D(
			transform.get_rotation(),
			Vector2(transform.get_scale().x,
			(transform.get_scale().y)*2), 
			transform.get_skew(),
			Vector2(transform.get_origin().x,(transform.get_origin().y)-transform.get_scale().y/2))
func move(direction):
	if not ($StateMachine.currentState is PlayerBlock):
		if direction > 0:
			faceDirection = 1.0
		else:
			faceDirection = -1.0
	if not ($StateMachine.currentState is PlayerRecovery):
		velocity.x = direction * Speed
	
func stop():
	velocity.x = move_toward(velocity.x, 0, Speed)

func performQCF():
	if $StateMachine.currentState is PlayerRecovery:
		$StateMachine.currentState.endRecovery("PlayerIdle")

func performDP(destination):
	var previousVelocity = velocity
	var tween = create_tween()
	tween.tween_property(self, "position", destination, 0.25)
	velocity = previousVelocity
	if $StateMachine.currentState is PlayerRecovery:
		$StateMachine.currentState.endRecovery("PlayerFall")

func _physics_process(delta):
	move_and_slide()
	# Add the gravity.
	if not (is_on_floor() and ($StateMachine.currentState is PlayerRecovery)):
		velocity.y += gravity * delta
	if is_on_floor():
		velocity.y = 0
		jumpCount = defaultJumpCount
	
	#print(interpretMovementVector(delta))
	handleMoveInput()
	print(getInputBuffer())
	
#InputBuffer handling

@onready var inputTimer = $InputTimer # The timer for input of combos or moves
var inputBuffer = [] # The list of the latest inputs.
var inputBufferMaxLength = 16 # The max length of the input buffer
var inputPreviousToBuffer = 5 # The last input accepted to the buffer (i.e. the last change from input state)
var inputLatestKey = 5 # The latest input received  
var specialMoveList = []


func handleMoveInput():
	var movementKey = interpretMovementVector()
	# Store the movement key for other use.
	if Input.is_action_just_pressed("Player1_Punch"):
		movementKey = CommandEnum.PUNCH
	elif Input.is_action_just_pressed(("Player1_Kick")):
		movementKey = CommandEnum.KICK
	inputLatestKey = movementKey 
	
	#
	# If the input changed store it in to the buffer.
	#
	if movementKey != inputPreviousToBuffer:
		inputBuffer.push_back(movementKey)
		
		#
		# Store this as the previous input.
		#
		inputPreviousToBuffer = movementKey
		
		#
		# Set that a combo is available and reset 
		# the timeout-timer for combo.
		#
		inputTimer.start()
	#
	# If the input buffer is longer than the max length, pop the front 
	# of the list.
	#
	if inputBuffer.size() > inputBufferMaxLength:
		inputBuffer = inputBuffer.slice(inputBuffer.size()-inputBufferMaxLength, inputBuffer.size() )

func getInputBuffer():
	return inputBuffer
func getLastInput():
	if inputBuffer:
		return inputBuffer[len(inputBuffer)-1]
	return false


func interpretMovementVector():
	#
	# Get the deltax and deltay of the movement vector.
	#
	var dx = 0.0
	var dy = 0.0
	var vMovement = Vector3(dx, 0, dy)

	dx = Input.get_action_strength("Player1_right") - Input.get_action_strength("Player1_Left")
	dy = Input.get_action_strength("Player1_Up") - Input.get_action_strength("Player1_Down")

	vMovement = Vector3(dx, 0, dy)
	if vMovement.length() < 0.2:
		# This is neutral
		return CommandEnum.NEUTRAL
	
	vMovement = Vector3(dx, 0, dy).normalized()
	
	#
	# Get what ever the direction is.
	#
	var vectorForward = Vector3(faceDirection,0,0)
	
	var angleMovement = vectorForward.angle_to(vMovement)
	
	#
	# Check if the input is forward, up, backwards, etc.
	# Denote with numbers on the keyboard, with 6 being forward and 8 up.
	#
	# 7  8  9
	# 4  N  6
	# 1  2  3
	#
	# The direction depends on delta y.
	if dy >= 0:
		if angleMovement < PI/5.0: 
			return CommandEnum.FORWARD
		if angleMovement < 2.0*PI/5.0:
			return CommandEnum.UPFORWARD
		if angleMovement < 3.0*PI/5.0:
			return CommandEnum.UP
		if angleMovement < 4.0*PI/5.0:
			return CommandEnum.UPBACK
		else: 
			return CommandEnum.BACK
	
	if angleMovement < PI/5.0:
		return CommandEnum.FORWARD
	if angleMovement < 2.0*PI/5.0:
		return CommandEnum.DOWNFORWARD
	if angleMovement < 3.0*PI/5.0:
		return CommandEnum.DOWN
	if angleMovement < 4.0*PI/5.0:
		return CommandEnum.DOWNBACK
	if angleMovement < PI:
		return CommandEnum.BACK
	
	# This is forward again.
	return CommandEnum.FORWARD


func _on_input_timer_timeout():	
	inputBuffer.clear()
	if interpretMovementVector() == inputPreviousToBuffer:
		inputBuffer.push_back(inputPreviousToBuffer)


func _ready():
	var qcf = load("res://Scripts/Player/Moves/Hadouken.gd").new()
	qcf.player = self
	specialMoveList.append(qcf)
	
	var dp = load("res://Scripts/Player/Moves/Shoryuken.gd").new()
	dp.player = self
	specialMoveList.append(dp)
