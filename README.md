# Awesome-Scene-Manager

![the plugin icon](addons/awesome_scene_manager/plugin_icon.png)
<br>
An **addon for Godot 4.2** that handles the transition between two scenes.

## Features

* Background loading for the scene you want to change.
* Easy tracking of the currently loading resource.
* Easy to customize and add animations for transitioning in and out of the scenes, see [animated transitions](#using-animations).
* Adding a scene nested inside a tree? Want to keep your hud in place? I got you covered with[swap_scenes](#swapping-the-scene).

## Installation

Go to asset tab in your project and search for `Awesome Scene Manager` and install from there.

You can also get the same files from ![insert the godot assets store link here](insert the godot assets store link here).

### Or

Go to the release page and grab the latest version, decompress the files in your `addons folder` (create one if theres none).

## Usage

When you first activate the addon, a Singleton will automatically add to your `Autoloads` called `SceneManager` . To call any function you use `SceneManager.function_to_call`.

There are two ways to change a scene, both are similar.

### Changing the scene

| Arguments  | Type | Default Value|
| -----------|------|--------------|
| scene_path  | String ||
| trans_in  | [Transitions](#transition-enumerator)|[Transitions.NONE](#transition-enumerator)|
| trans_out  | int| -1 |

``` GDScript
SceneManager.change_scene(
 "res://scenes/new_scene.tscn",
 SceneManager.Transitions.FADE
 )
```

`change_scene` ask for a single parameter, the path to the scene, once called it will kickstart the transition process, starting by starting the transition animation and start loading the scene in the background.

Once the scene is completely loaded, changes the current scene to a new instance of the new scene.

 Then it plays the second part of the selected animation and once its done is available to be called again.

 The other two parameters `trans_in` and `trans_out` dictate the animation to be played when starting the transition and ending it respectively.

 If left empty it will play the default animation (fade in and out), if `trans_out` is left empty _(or at a negative number)_, it will play automatically the ending part of the `trans_in`.

### Swapping the scene

| Arguments  | Type | Default Value|
| -----------|------|--------------|
| scene_path  | String |   |
|scene_to_swap|Node|    |
| trans_in  | [Transitions](#transition-enumerator)|[Transitions.NONE](#transition-enumerator)|
| trans_out  | int | -1 |

 Let´s say, you only want to change a specific node (and for good measure to left it in the same place), then use

 ```GDScript
 SceneManager.swap_scenes(
  "res://scenes/new_scene.tscn",
  Node,
  SceneManager.Transitions.FADE
 )
 ```

 Identical to `change_scene`, by passing a obligatory `scene_to_swap`, it will instead of change the current scene, freed the old scene and add the new one in the same place where the other was.

## Using Animations

The Singleton is essentially a `CanvasItem` and a `AnimationPlayer`. Then `SceneManager` plays the animations and waits for them to be completed. So by adding animations to the `AnimationPlayer` and adding their names in the enum `Transitions` you extend the functionality of this addon.

### Guide

Lets add a swipe animation, it would swipe from **left to right** when it starts, then **from right to left** when it ends.

Theres a `ControlNode` with an `ColorRect` already, lets use that.

Make two animations, one called `swipe_in` and other called `swipe_out`, then go to the script of the `SceneManager` in `res://addons/awesome_scene_manager/autoloads/SceneManager.gd` and add a new value to the `Transitions` **enum**erator called **swipe**;
> the animations name _**must be lowercase**_

The addon will add the "_in" and "_out" automatically when needed so the value should be **the name without the _in or _out**.

After that, then calling either function with the value of `Transitions.SWIPE` in either `trans_in` or `trans_out` like so:

``` GDScript
SceneManager.change_scene(
 "res://scenes/new_scene.tscn",
 SceneManager.Transitions.SWIPE)
```

It should swipe from left to right and then from right to left

### Transition Enumerator

| Values |
| -------|
| NONE  |
| FADE  |

This is a enum of the `Singleton`, it contains information about the animations available, the addon grabs their values, lower case them and add the suffix `_in` and `_out` when need them. These formatted values must match an animation with the same name, example:

`Transition.FADE` turns into the animations names of `"fade_in"` and `"fade_out"`.

If theres no animation called like that, the exported variable `default_transition_type` will replace them, set as `FADE` by default.

Theres a single value that cannot be removed, that is the `NONE` value, used in case you don´t want any animation happenings

## Credits

* The self update functionality code is essentially the same from [BenjaTK addon Gaea](https://github.com/BenjaTK/Gaea), which in turn is based on [Nathan Hoad](https://github.com/nathanhoad)
