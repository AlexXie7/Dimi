extends Control

func _on_level_1_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/IntroVideo.tscn")

func _ready():
	MusicController.play_music()
