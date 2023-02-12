extends Node

signal sound_toggled(sound)
signal music_toggled(music)
signal fullscreen_toggled(fullscreen)
signal bird_color_changed(bird_color)
signal high_score(score)

const BIRD_COLORS = ["green", "blue", "red", "yellow"]

export var config_path := "user://flying-birdie.options.cfg"
export var config_pass := "V(/2Xc2;|x"
var config := ConfigFile.new()

var sound := Option.new(self, "Options", "sound", true, "_sound_changed")
var music := Option.new(self, "Options", "music", true, "_music_changed")
var fullscreen := Option.new(self, "Options", "fullscreen", false, "_fullscreen_changed")
var bird_color := Option.new(self, "Options", "bird_color", "green", "_bird_color_changed")
var best_score := Option.new(self, "Score", "best_score", 0, "_best_score_changed")


func _ready() -> void:
	# warning-ignore:return_value_discarded
	config.load_encrypted_pass(config_path, config_pass)

	_sound_changed(sound.value)
	_music_changed(music.value)
	_fullscreen_changed(fullscreen.value)


func _sound_changed(val: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Sound"), not val)
	emit_signal("sound_toggled", val)


func _music_changed(val: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), not val)
	emit_signal("music_toggled", val)


func _fullscreen_changed(val: bool) -> void:
	OS.window_fullscreen = val
	emit_signal("fullscreen_toggled", val)


func _bird_color_changed(val: String) -> void:
	emit_signal("bird_color_changed", val)


func _best_score_changed(val: int) -> void:
	emit_signal("high_score", val)


# Interface for an Option in the ConfigFile.
# "value" will get the value from the ConfigFile, and changing it will save the
# new value to the ConfigFile.
class Option:
	var parent: Node          # the outer class
	var section: String       # section that this option is in
	var key: String           # key of this option
	var default_value         # default value of the option
	var on_changed            # function to call when the value is changed, with the new value as argument

	var value setget _set_value, _get_value


	func _init(p_parent: Node, p_section: String, p_key: String, p_default_value, p_on_changed = null) -> void:
		parent = p_parent
		section = p_section
		key = p_key
		default_value = p_default_value
		on_changed = p_on_changed


	func _set_value(val) -> void:
		parent.config.set_value(section, key, val)
		# warning-ignore:return_value_discarded
		parent.config.save_encrypted_pass(parent.config_path, parent.config_pass)
		if on_changed:
			parent.call(on_changed, val)

	func _get_value():
		return parent.config.get_value(section, key, default_value)
