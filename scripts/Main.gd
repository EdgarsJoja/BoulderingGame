extends Node2D

@onready var scene_root: Node = $CurrentScene

func _ready():
	SceneLoader.load_scene.connect(_on_scene_loader_load_scene)

func _on_scene_loader_load_scene(scene: String):
	var scene_resource = load("res://scenes/%s.tscn" % scene)
	for child in scene_root.get_children():
		child.queue_free()
	
	scene_root.add_child(scene_resource.instantiate())
