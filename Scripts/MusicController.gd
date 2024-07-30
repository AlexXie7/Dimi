extends Node

var level_one_music = load("res://Music/Symmetry.mp3")
var credits_music = load("res://Music/Canon In D For 8 Bit Synths.mp3")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func play_music():
	$Music.stream = level_one_music
	$Music.play()

func play_credits():
	$Music.stream = credits_music
	$Music.play()
