extends State
class_name PlayerIdle

@export var player = CharacterBody2D
@export var jumpVelocity = -400.0
func physicsUpdate(_delta : float):
	#var direction = Input.get_axis("Player1_Left", "Player1_right")
	#if direction:
	#	Transitioned.emit(self, "PlayerMove")
	#if Input.is_action_just_pressed("Player1_Down"):
	#	Transitioned.emit(self,"PlayerCrouch")
	#if Input.is_action_just_pressed("Player1_Up") and player.jumpCount > 0:
	#	player.jump()
	#	Transitioned.emit(self,"PlayerJump")
	if !checkSpecialMove():
		if !checkBasicMove():
			checkMoveCommand()
	if Input.is_action_just_pressed("Player1_Block"):
		Transitioned.emit(self,"PlayerBlock")
	
func checkSpecialMove():
	var buffer = player.getInputBuffer()
	if buffer:
		for move in player.specialMoveList:
			if move.checkInput(buffer):
				move.performMove()
				player.inputBuffer.clear()
				player.inputBuffer.push_back(CommandEnum.NEUTRAL)
	return false
func checkBasicMove():
	var command = player.getLastInput()
	if !command:
		pass
	else:
		pass
	return false
func checkMoveCommand():
	var command = player.getLastInput()
	if !command:
		pass
	else:
		if command == CommandEnum.DOWN:
			Transitioned.emit(self,"PlayerCrouch")
			return true
		elif command == CommandEnum.BACK or command == CommandEnum.FORWARD:
			Transitioned.emit(self, "PlayerMove")
			return true
		elif command == CommandEnum.UPBACK or command == CommandEnum.UP or command == CommandEnum.UPFORWARD:
			player.jump()
			Transitioned.emit(self,"PlayerJump")
			return true
	return false
		
