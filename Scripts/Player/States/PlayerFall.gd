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
		if player.velocity.y == 0:
			player.velocity.x = 0
			#player.inputBuffer.clear()
			Transitioned.emit(self, "PlayerIdle")
func checkSpecialMove():
	return false
func checkBasicMove():
	return false
func checkMoveCommand():
	return false
