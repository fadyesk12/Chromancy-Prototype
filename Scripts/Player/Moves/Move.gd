extends Node

class_name Move
const CommandEnum = preload("res://Global/CommandEnum.gd").Commands
var input = []
var inputLength = 0

func _init(input):
	self.input = input
	self.inputLength = len(input)

func checkInput(buffer):
	pass
func performMove():
	pass
