extends Control

@onready var level_v0: Button = $List/V0
@onready var exit: Button = $List/Exit

func _ready():
	level_v0.connect("button_up", load_level("V0"))
	exit.connect("button_up", func(): get_tree().quit())

func load_level(level: String):
	return func():
		SceneLoader.load("levels/%s" % level)

