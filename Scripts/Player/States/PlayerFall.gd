extends State
class_name PlayerFall

@export var player : CharacterBody2D

func physicsUpdate(_delta : float):
	if player:
		if Input.is_action_just_pressed("Player1_Up") and player.jumpCount > 0:
			player.jump()
			Transitioned.emit(self,"PlayerJump")
		var direction = Input.get_axis("Player1_Left", "Player1_right")
		if direction:
			player.move(direction)
		else:
			player.stop()
		print(player.velocity.y)
		if player.velocity.y == 0:
			player.velocity.x = 0
			#player.inputBuffer.clear()
			Transitioned.emit(self, "PlayerIdle")
			
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
