extends Move

class_name Shoryuken
@export var player : CharacterBody2D
var currentScene = null
# Called when the node enters the scene tree for the first time.

func _init():
	super([CommandEnum.FORWARD, CommandEnum.NEUTRAL, CommandEnum.DOWN, CommandEnum.DOWNFORWARD, CommandEnum.PUNCH])

func checkInput(buffer):
	if !input:
		return false
	var length = len(buffer)
	if length >= inputLength:
		var i = 0
		for command in buffer:
			if command == input[0] and ((length - i + 1) > inputLength):
				if buffer[i+1] == input[1]:
					if buffer[i+2] == input[2]:
						if buffer[i+3] == input[3]:
							if buffer[i+4] == input[4]:
								return true
							elif buffer[i+4] == CommandEnum.NEUTRAL:
								if (length - i - 1 - inputLength) > 0:
									if buffer[i+5] == input[4]:
										return true
			i+=1
	return false
func performMove():
	if not currentScene:
		currentScene = player.get_tree().get_current_scene()
	player.global_position = Vector2(0,0)
	print("S H O R Y U K E N !")
