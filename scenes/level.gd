extends Node2D
	
func _on_button_pressed():
	SceneManager.swap_scenes(
		"res://scenes/level_2.tscn",
		self,
		SceneManager.Transitions.FADE
	)