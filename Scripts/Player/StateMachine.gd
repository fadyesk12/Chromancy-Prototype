extends Node

@export var initialState : State

var currentState : State 
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(onChildTransitioned)
	if initialState:
		initialState.enterState()
		currentState = initialState

func _process(delta):
	if currentState:
		currentState.Update(delta)

func _physics_process(delta):
	if currentState:
		print(currentState)
		currentState.physicsUpdate(delta)
		#print(currentState)

func onChildTransitioned(state, newStateName):
	if state != currentState:
		return

	var newState = states.get(newStateName.to_lower())
	if !newState:
		return
	
	if currentState:
		currentState.exitState()

	newState.enterState()
	currentState = newState
