@tool
extends EditorPlugin

const AUTOLOAD: Dictionary = {
	"NAME": "SceneManager",
	"PATH": "res://addons/awesome_scene_manager/autoloads/SceneManager.tscn"
}

func _enter_tree():
	add_autoload_singleton(AUTOLOAD.NAME, AUTOLOAD.PATH)
	pass

func _exit_tree():
	remove_autoload_singleton(AUTOLOAD.NAME)
