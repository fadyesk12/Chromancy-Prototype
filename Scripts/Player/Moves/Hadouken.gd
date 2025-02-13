extends Move

class_name Hadouken
@export var player : CharacterBody2D
@export var projectileNode = preload("res://Assets/Characters/Player/player_projectile.tscn")
var currentScene = null
# Called when the node enters the scene tree for the first time.

func _init():
	super([CommandEnum.DOWN, CommandEnum.DOWNFORWARD, CommandEnum.FORWARD, CommandEnum.PUNCH])

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
							return true
						elif buffer[i+3] == CommandEnum.NEUTRAL:
							if (length - i - 1 - inputLength) > 0:
								if buffer[i+4] == input[3]:
									return true
			i+=1
	return false
func performMove():
	if projectileNode:
		var projectile = projectileNode.instantiate()
		if not currentScene:
			currentScene = player.get_tree().get_current_scene()
		currentScene.add_child(projectile)
		projectile.global_position = player.global_position
		projectile.initial_position = player.global_position
		projectile.direction = player.faceDirection
		player.performQCF()
		print("H A D O U K E N !")
