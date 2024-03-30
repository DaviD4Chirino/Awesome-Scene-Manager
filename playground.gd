extends Node2D

func _on_button_pressed():
	SceneManager.change_scene(
		"res://scenes/scene2.tscn",
		SceneManager.Transitions.FADE,
	)
	pass # Replace with function body.
