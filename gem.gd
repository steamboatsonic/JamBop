extends Sprite2D

@onready
var gemManager = $"..";
var MSecUntilPerfect:float = 0;
var xPosition:float = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	# Gem will be active until it has left the target zone
	set_meta("OnScreen", false);
	set_meta("Active", true);
	
	xPosition = 100.00;
	
	if get_meta("Lane") < 4:
		xPosition = 750.00 + (float(get_meta("Lane")) * 30.00)
		set_meta("Road", 1)
	elif get_meta("Lane") >= 4:
		xPosition = 960.00 + (float(get_meta("Lane")) * 30.00)
		set_meta("Road", 2)
	
	# writeDebug(str(xPosition));

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# writeDebug(str(gemManager.get_meta("todaysTime")))
	MSecUntilPerfect = get_meta("TimingMSec") - gemManager.get_meta("todaysTime");
	# writeDebug(str(MSecUntilPerfect));
	if (get_meta("OnScreen") == false):
		if MSecUntilPerfect < 900 / gemManager.get_meta("gravity"):
			set_meta("OnScreen", true)
	else:
		# writeDebug(str((get_meta("TimingMSec") - 8000)));
		position = Vector2(
			xPosition, 
			900 - (MSecUntilPerfect * gemManager.get_meta("gravity")));

func writeDebug(textToWrite:String):
	get_node("../../../DebugText").text = textToWrite;
