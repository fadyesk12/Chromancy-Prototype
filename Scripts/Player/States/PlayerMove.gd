extends State
class_name PlayerMove

@export var player : CharacterBody2D

func physicsUpdate(_delta : float):
	if player:
		#var direction = Input.get_axis("Player1_Left", "Player1_right")
		#if direction:
		#	player.move(direction)
		#else:
		#	player.stop()
		#	Transitioned.emit(self, "PlayerIdle")
		#if Input.is_action_just_pressed("Player1_Down"):
		#	Transitioned.emit(self,"PlayerCrouch")
		#if Input.is_action_just_pressed("Player1_Up") and player.jumpCount > 0:
		#	player.jump()
		#	Transitioned.emit(self,"PlayerJump")
		if Input.is_action_just_pressed("Player1_Block"):
			Transitioned.emit(self,"PlayerBlock")
		if !checkSpecialMove():
			if !checkBasicMove():
				checkMoveCommand()
func checkSpecialMove():
	var buffer = player.getInputBuffer()
	if buffer:
		for move in player.specialMoveList:
			if move.checkInput(buffer):
				Transitioned.emit(self,"PlayerRecovery")
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
	if command == CommandEnum.DOWN:
		Transitioned.emit(self,"PlayerCrouch")
	elif command == CommandEnum.BACK or command == CommandEnum.FORWARD:
		var direction = Input.get_axis("Player1_Left", "Player1_right")
		if direction:
			player.move(direction)
	elif command == CommandEnum.UPBACK or command == CommandEnum.UP or command == CommandEnum.UPFORWARD:
		player.jump()
		Transitioned.emit(self,"PlayerJump")
	else:
		player.stop()
		Transitioned.emit(self, "PlayerIdle")
