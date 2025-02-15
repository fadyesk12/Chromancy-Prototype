extends State
class_name PlayerJump

@export var player = CharacterBody2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func physicsUpdate(_delta : float):
	
	if player:
		if Input.is_action_just_pressed("Player1_Up") and player.jumpCount > 0:
			player.jump()
		var direction = Input.get_axis("Player1_Left", "Player1_right")
		if direction:
			player.move(direction)
		else:
			player.stop()
		if player.velocity.y > 0:
			Transitioned.emit(self, "PlayerFall")
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
func checkBasicMove():
	return false
func checkMoveCommand():
	return false


