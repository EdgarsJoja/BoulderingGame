extends Node

signal load_scene(scene: String)

func load(scene: String):
	load_scene.emit(scene)
