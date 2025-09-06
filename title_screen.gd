extends Control
@onready var ui_node = $SubViewportContainer/SubViewport/Node2D/CanvasLayer
@onready var player = $SubViewportContainer/SubViewport/Node2D/CharacterBody2D
@onready var day_cycle = $SubViewportContainer/SubViewport/Node2D/BackgroundStuff

func _ready() -> void:
	ui_node.visible = false
	player.freeze = true
	day_cycle.dont_tick = true
	day_cycle.color = Color(0, 0, 0, 1)
	day_cycle.fade_to_day()
