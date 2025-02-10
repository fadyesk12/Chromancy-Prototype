extends Node

class_name State
const CommandEnum = preload("res://Global/CommandEnum.gd").Commands
signal Transitioned

func enterState():
	pass

func exitState():
	pass

func Update(_delta : float):
	pass
	
func physicsUpdate(_delta : float):
	pass

func checkSpecialMove():
	return false
func checkBasicMove():
	return false
func checkMoveCommand():
	return false
