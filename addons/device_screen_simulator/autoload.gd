extends Node

# Show Key
var show_key = KEY_H

# Reset Key
var reset_key = KEY_R

# Stretch Aspect
# 0 - disabled, 1 - 2d, 2 - viewport
var default_stretch_aspect = 0

# Stretch Mode
# 0 - ignore, 1 - keep, 2 - keep_width, 3 - keep_height, 4 - expand
var default_stretch_mode = 0

# Stretch Shrink
# set number from 0.01 to 8, precision to 2 decimals
var default_stretch_shrink = 1

# Screen Orientation
# 0 - portrait, 1 - landscape
var default_screen_orientation = 0

var phone_models = {
	"iPhone 14 Pro Max" : {
		"resolution" : Vector2(1290, 2796)
	},
	"iPhone 14 Pro" : {
		"resolution" : Vector2(1179, 2556)
	},
	"iPhone 14 Plus" : {
		"resolution" : Vector2(1284, 2778)
	},
	"iPhone 14" : {
		"resolution" : Vector2(1170, 2532)
	},
	"iPhone 13" : {
		"resolution" : Vector2(1170, 2532)
	},
	"iPhone 13 mini" : {
		"resolution" : Vector2(1080, 2340)
	},
	"iPhone SE" : {
		"resolution" : Vector2(750, 1334)
	},
	"iPhone 12" : {
		"resolution" : Vector2(1170, 2532)
	},
}

# ---------- DO NOT EDIT LINES BELOW ----------

var simulator_scene = preload("res://addons/device_screen_simulator/simulator.tscn")
var current_scene = null

var default_resolution = OS.window_size

func _ready():
	var simulator = simulator_scene.instance()
	add_child(simulator)
	
