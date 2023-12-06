extends Sprite2D

@onready
var gemManager = $"..";
var MSecUntilPerfect:float = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# writeDebug(str(gemManager.get_meta("todaysTime")))
	MSecUntilPerfect = get_meta("TimingMSec") - gemManager.get_meta("todaysTime");
	writeDebug(str(MSecUntilPerfect));
	
	if MSecUntilPerfect < 900 / gemManager.get_meta("gravity"):
		# writeDebug(str((get_meta("TimingMSec") - 8000)));
		position = Vector2(
			810, 
			900 - (MSecUntilPerfect * gemManager.get_meta("gravity")));
	else:
		# writeDebug("Out of Rnnge");
		pass

func writeDebug(textToWrite:String):
	get_node("../../../DebugText").text = textToWrite;
