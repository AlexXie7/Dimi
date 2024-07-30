class_name interactable extends Area2D


@export var interact_label = "none"
@export var interact_type = "none"
@export var interact_value = "none"
@export var interactable = true

func hideSparkle():
	$Sparkle.hide()

# signal lampLit

func lightLamp():
	# lampLit.emit()
	get_parent().play("default")

