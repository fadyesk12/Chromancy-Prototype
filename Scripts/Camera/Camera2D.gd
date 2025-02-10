extends Camera2D

func _on_test_scene_child_exiting_tree(node):
	if node.name == "RedCollectible":
		$CanvasLayer/ColorRect.material.set_shader_parameter("showRed", Game.showColor["showRed"])
