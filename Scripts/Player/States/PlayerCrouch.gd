extends State
class_name PlayerCrouch

@export var player : CharacterBody2D

func enterState():
	player.velocity.x = 0
	player.crouch()
		

func exitState():
	player.stand()

func physicsUpdate(_delta : float):
	if Input.is_action_just_released("Player1_Down"):
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
				Transitioned.emit(self,"PlayerRecovery")
				move.performMove()
				player.inputBuffer.clear()
				player.inputBuffer.push_back(CommandEnum.NEUTRAL)
	return false
func checkBasicMove():
	return false
func checkMoveCommand():
	return false
