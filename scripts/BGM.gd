extends AudioStreamPlayer
"""An Autoload that manages background music"""

### VARIABLE ###

var current_music: AudioStream = null setget set_current_music

### FUNCTION ###
# --- Public ---

func set_current_music(resource: AudioStream):
	stream = resource
	current_music = resource
	play()


# --- Private ---

func _ready():
	bus = "BGM"
	pause_mode = Node.PAUSE_MODE_PROCESS


