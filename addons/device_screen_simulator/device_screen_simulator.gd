tool
extends EditorPlugin

const AUTOLOAD_NAME = "DeviceScreenSimulator"

func _enter_tree():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/device_screen_simulator/autoload.gd")


func _exit_tree():
	remove_autoload_singleton(AUTOLOAD_NAME)
