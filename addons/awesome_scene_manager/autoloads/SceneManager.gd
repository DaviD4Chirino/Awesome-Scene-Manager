extends CanvasLayer
# The general order of events is:
#	* start_transition is called
#	* resource begins and finish to load
#	* scene is changed (only when start_transition ends)
#	* end_transition is called
#	* SceneManager hides

## You need to have 2 animations, starting and ending. 
## They are separated by adding "_in" or "_out" as their suffix
## The transitions are your animations names so FADE becomes "fade_in" and or "fade_out"
enum Transitions {
	NONE,
	FADE
}
@export var default_transition_type: Transitions = Transitions.FADE
@export_group("Nodes")

@export var anim: AnimationPlayer
@export var progress_bar_timer: Timer
## Progress Bar will only show if the progress_bar_timer has stopped and the scene is no loaded yet
@export var progress_bar: ProgressBar

## The resource path
var scene_to_load: String = ""
var loading_resource: bool = false
var progress: Array = []
#Signals

## Emitted when the animation_in just started playing
signal changing_scenes
## Emitted when the animation_out ended
signal scene_changed
## Emitted when the loading process has just begun
signal loading_scene
## Emitted when the loading has ended
signal scene_loaded

func _ready():
	hide()
	progress_bar.hide()

func _process(delta: float):
	if not loading_resource:
		return
	# print(ResourceLoader.load_threaded_get_status(scene_to_load, progress))
	match ResourceLoader.load_threaded_get_status(scene_to_load, progress):
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			if progress_bar.visible:
				progress_bar.value = progress[0] * 100

		ResourceLoader.THREAD_LOAD_LOADED:
			scene_loaded.emit()
			loading_resource = false

		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			push_error("Resource %s invalid" % scene_to_load)
			loading_resource = false

		ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Failed to load the resource %s" % scene_to_load)
			loading_resource = false

func change_scene(
	## The path to the scene you want to transition into
	scene_path: String,
	## The initial transition type
	trans_in: Transitions=Transitions.FADE,
	## The ending transition type, if set to -1 will be the the ending of the fade_in transition, else use the Transitions 
	trans_out: int=- 1,
	) -> void:

	if anim.is_playing():
		push_warning("Animation is already playing")
		return

	show()

	var out_transition: Transitions = trans_in if (
		trans_out <= 0) else (
			Transitions.keys()[trans_out]
		)
	scene_to_load = scene_path

	await start_transition(trans_in)

	ResourceLoader.load_threaded_request(scene_to_load)
	loading_resource = true

	await scene_loaded
	get_tree().change_scene_to_packed(
		ResourceLoader.load_threaded_get(
			scene_to_load
		)
	)

	await end_transition(out_transition)

	hide()

func start_transition(transition: Transitions) -> void:

	var anim_name: String = _get_anim_name(transition) + "_in"

	if not anim.has_animation(anim_name):
		push_warning("Theres no animation: %s" % anim_name)
		anim_name = _parse_transition_name(default_transition_type) + "_in"

	anim.play(anim_name)
	changing_scenes.emit()

	await anim.animation_finished

	progress_bar_timer.start()

func end_transition(transition: Transitions) -> void:
	var anim_name: String = _get_anim_name(transition) + "_out"

	if not anim.has_animation(anim_name):
		push_warning("Theres no animation: %s" % anim_name)
		anim_name = _parse_transition_name(default_transition_type) + "_out"

	progress_bar_timer.stop()
	progress_bar.hide()

	anim.play(anim_name)
	scene_changed.emit()
	await anim.animation_finished

## returns the transition anim name if it exist, else the first element of the enum (fade)
func _get_anim_name(transition: Transitions) -> String:
	if Transitions.keys().find(transition) == - 1:
		push_warning(
			"Transition type of %s does not exist" % transition
			)
		return _parse_transition_name(default_transition_type)

	return _parse_transition_name(transition)

# Private functions

func _parse_transition_name(transition: int) -> String:
	return Transitions.keys()[transition].to_lower()

# Connected Signals

func _on_progress_bar_timer_timeout() -> void:
	progress_bar.show()
	pass # Replace with function body.
