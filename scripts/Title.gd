extends Node2D

onready var main_scene := preload("res://scenes/Main.tscn")

# ボタン押されたらメインシーンにチェンジ
func _unhandled_input(event):
	if event.is_pressed():
		var _e = get_tree().change_scene_to(main_scene)
