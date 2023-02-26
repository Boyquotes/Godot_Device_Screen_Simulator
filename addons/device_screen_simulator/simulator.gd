extends Node

onready var resolution_label = $VBoxContainer/Resolution_label
onready var phone_model_optionbutton = $VBoxContainer/Phone_Model_optionbutton
onready var stretch_mode_vboxcontainer = $VBoxContainer/Stretch_Modes_vboxcontainer
onready var stretch_mode_optionbutton = $VBoxContainer/Stretch_Modes_vboxcontainer/Stretch_Mode_optionbutton
onready var stretch_aspect_optionbutton = $VBoxContainer/Stretch_Modes_vboxcontainer/Stretch_Aspect_optionbutton
onready var stretch_shrink_hscrollbar = $VBoxContainer/Stretch_Modes_vboxcontainer/Stretch_Shrink_hboxcontainer/Stretch_Shrink_hscrollbar
onready var stretch_shrink_value_label = $VBoxContainer/Stretch_Modes_vboxcontainer/Stretch_Shrink_hboxcontainer/StretchShrink_Value_label

var chosen_stretch_mode = DeviceScreenSimulator.default_stretch_mode
var chosen_stretch_aspect = DeviceScreenSimulator.default_stretch_aspect
var chosen_stretch_shrink = DeviceScreenSimulator.default_stretch_shrink

var current_resolution : Vector2 = OS.window_size
var chosen_phone_model
var chosen_screen_orientation = 0
var chosen_resolution = current_resolution

var stretch_mode = ["disabled", "2d", "viewport"]
var stretch_aspect = ["ignore", "keep", "keep_width", "keep_height", "expand"]
var stretch_shrink = 1

var final_resolution
var final_stretch_mode
var final_stretch_aspect
var final_stretch_shrink


func _ready():
#	self.visible = false
	update_current_resolution()
	create_input_actions()
	load_list_of_phones()
	load_stretch_modes()
	set_new_values()
	
func _process(delta):
	if Input.is_action_just_pressed("show_hide_simulator") and self.visible == false:
		self.visible = true
	elif Input.is_action_just_pressed("show_hide_simulator") and self.visible == true:
		self.visible = false

	if Input.is_action_just_pressed("reset_screen"):
		reset_to_default()

func create_input_actions():
	var reset_key = InputEventKey.new()
	reset_key.set_scancode(DeviceScreenSimulator.reset_key)
	InputMap.add_action("reset_screen")
	InputMap.action_add_event("reset_screen", reset_key)
	
	var show_hide_key = InputEventKey.new()
	show_hide_key.set_scancode(DeviceScreenSimulator.show_key)
	InputMap.add_action("show_hide_simulator")
	InputMap.action_add_event("show_hide_simulator", show_hide_key)

func update_current_resolution():
	resolution_label.text = "Current resolution: " + str(current_resolution.x) + " x " + str(current_resolution.y)

func reset_phone_model_optionbutton():
	phone_model_optionbutton.selected = -1
	phone_model_optionbutton.text = "Phone model..."

func load_list_of_phones():
	reset_phone_model_optionbutton()
	for phone_model in DeviceScreenSimulator.phone_models:
		phone_model_optionbutton.get_popup().add_item(phone_model)

func load_stretch_modes():
	update_stretch_modes(
		DeviceScreenSimulator.default_stretch_mode, 
		DeviceScreenSimulator.default_stretch_aspect, 
		DeviceScreenSimulator.default_stretch_shrink)
	for mode in stretch_mode:
		stretch_mode_optionbutton.get_popup().add_item(mode)
	
	for aspect in stretch_aspect:
		stretch_aspect_optionbutton.get_popup().add_item(aspect)
	
func update_stretch_modes(stretch_mode_value, stretch_aspect_value, stretch_shrink_value):
	stretch_mode_optionbutton.selected = stretch_mode_value
	stretch_mode_optionbutton.text = stretch_mode[stretch_mode_value]
	stretch_aspect_optionbutton.selected = stretch_aspect_value
	stretch_aspect_optionbutton.text = stretch_aspect[stretch_aspect_value]
	stretch_shrink_hscrollbar.value = stretch_shrink_value
	stretch_shrink_value_label.text = str(stretch_shrink_value)

func set_final_resolution_value(screen_orientation_value, resolution_value):
	if screen_orientation_value == 0:
		final_resolution = Vector2(resolution_value.x, resolution_value.y)
	else:
		final_resolution = Vector2(resolution_value.y, resolution_value.x)
	
	current_resolution = final_resolution
	update_current_resolution()

func set_final_stretch_mode_value(stretch_mode_value):
	if stretch_mode_value == 0:
		final_stretch_mode = SceneTree.STRETCH_MODE_DISABLED
	elif stretch_mode_value == 1:
		final_stretch_mode = SceneTree.STRETCH_MODE_2D
	else:
		final_stretch_mode = SceneTree.STRETCH_MODE_VIEWPORT

func set_final_stretch_aspect_value(stretch_aspect_value):
	if stretch_aspect_value == 0:
		final_stretch_aspect = SceneTree.STRETCH_ASPECT_IGNORE
	elif stretch_aspect_value == 1:
		final_stretch_aspect = SceneTree.STRETCH_ASPECT_KEEP
	elif stretch_aspect_value == 2:
		final_stretch_aspect = SceneTree.STRETCH_ASPECT_KEEP_WIDTH
	elif stretch_aspect_value == 3:
		final_stretch_aspect = SceneTree.STRETCH_ASPECT_KEEP_HEIGHT
	else:
		final_stretch_aspect = SceneTree.STRETCH_ASPECT_EXPAND

func set_final_stretch_shrink_value(stretch_shrink_value):
	final_stretch_shrink = stretch_shrink_value

func reset_to_default():
	set_final_resolution_value(
		DeviceScreenSimulator.default_screen_orientation, 
		DeviceScreenSimulator.default_resolution)
	set_final_stretch_mode_value(DeviceScreenSimulator.default_stretch_mode)
	set_final_stretch_aspect_value(DeviceScreenSimulator.default_stretch_aspect)
	set_final_stretch_shrink_value(DeviceScreenSimulator.default_stretch_shrink)
	get_tree().set_screen_stretch(
			final_stretch_mode, final_stretch_aspect, final_resolution, final_stretch_shrink)
	OS.window_size = final_resolution
	update_current_resolution()
	update_stretch_modes(
		DeviceScreenSimulator.default_stretch_mode, 
		DeviceScreenSimulator.default_stretch_aspect, 
		DeviceScreenSimulator.default_stretch_shrink)
	reset_phone_model_optionbutton()

func set_new_values():
	set_final_resolution_value(
		chosen_screen_orientation, 
		chosen_resolution)
	set_final_stretch_mode_value(chosen_stretch_mode)
	set_final_stretch_aspect_value(chosen_stretch_aspect)
	set_final_stretch_shrink_value(chosen_stretch_shrink)
	get_tree().set_screen_stretch(
			final_stretch_mode, final_stretch_aspect, final_resolution, final_stretch_shrink)
	OS.window_size = final_resolution
	update_current_resolution()

func _on_Phone_Model_optionbutton_item_selected(index):
	var selected_index = phone_model_optionbutton.selected
	chosen_phone_model = phone_model_optionbutton.get_item_text(selected_index)
	chosen_resolution = DeviceScreenSimulator.phone_models[chosen_phone_model]["resolution"]
	

func _on_Portrait_checkbox_pressed():
	chosen_screen_orientation = 0
	chosen_stretch_aspect = 3
	update_stretch_modes(
			chosen_stretch_mode, 
			chosen_stretch_aspect, 
			chosen_stretch_shrink)

func _on_Landscape_checkbox_pressed():
	chosen_screen_orientation = 1
	chosen_stretch_aspect = 2
	update_stretch_modes(
			chosen_stretch_mode, 
			chosen_stretch_aspect, 
			chosen_stretch_shrink)

func _on_Window_Settings_checkbutton_toggled(button_pressed):
	if button_pressed == true:
		stretch_mode_vboxcontainer.visible = true
	else:
		stretch_mode_vboxcontainer.visible = false
		update_stretch_modes(
			DeviceScreenSimulator.default_stretch_mode, 
			DeviceScreenSimulator.default_stretch_aspect, 
			DeviceScreenSimulator.default_stretch_shrink)

func _on_Stretch_Mode_optionbutton_item_selected(index):
	chosen_stretch_mode = index

func _on_Stretch_Aspect_optionbutton_item_selected(index):
	chosen_stretch_mode = index

func _on_Stretch_Shrink_hscrollbar_scrolling():
	stretch_shrink_value_label.text = str(stretch_shrink_hscrollbar.value)
	chosen_stretch_shrink = stretch_shrink_hscrollbar.value


func _on_Reset_button_pressed():
	reset_to_default()


func _on_Confirm_button_pressed():
	set_new_values()
