extends Sprite2D

@onready
var gemManager = $"..";

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# writeDebug(str(gemManager.get_meta("todaysTime")))
	if gemManager.get_meta("todaysTime") > (get_meta("TimingMSec") - 8000):
		writeDebug(str((get_meta("TimingMSec") - 8000)));
		position = Vector2(
			810, 
			7500 + (gemManager.get_meta("todaysTime") - get_meta("TimingMSec")))
	else:
		writeDebug("Out of Rnnge");

func writeDebug(textToWrite:String):
	get_node("../../../DebugText").text = textToWrite;
