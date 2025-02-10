extends State
class_name PlayerBlock

@export var player : CharacterBody2D

func enterState():
	player.velocity.x = 0

func physicsUpdate(delta):
	if Input.is_action_just_released("Player1_Block"):
		Transitioned.emit(self, "PlayerIdle")
	if Input.is_action_just_pressed("Player1_Up") and player.jumpCount > 0:
		player.jump()
		Transitioned.emit(self,"PlayerJump")
	if !checkSpecialMove():
		if !checkBasicMove():
			checkMoveCommand()
func checkSpecialMove():
	var buffer = player.getInputBuffer()
	if buffer:
		for move in player.specialMoveList:
			if move.checkInput(buffer):
				move.performMove()
				player.inputBuffer.clear()
				player.inputBuffer.push_back(CommandEnum.NEUTRAL)
		#var i = 0
		#for input in buffer:
		#	if input == CommandEnum.DOWN && len(buffer) > 3:
		#		if buffer[i+1] == CommandEnum.DOWNFORWARD:
		#			if buffer[i+2] == CommandEnum.FORWARD:
		#				if buffer[i+3] == CommandEnum.BLOCK:
		#					player.inputBuffer.clear()
		#					print("H A D O U K E N !")
		#					return true
		#				elif buffer[i+3] == CommandEnum.NEUTRAL:
		#					if buffer[i+4] == CommandEnum.BLOCK:
		#						print("H A D O U K E N !")
		#						player.inputBuffer.clear()
			#					player.inputBuffer.push_back(CommandEnum.NEUTRAL)
			#					return true
			#i+=1
	return false
func checkBasicMove():
	return false
func checkMoveCommand():
	return false
