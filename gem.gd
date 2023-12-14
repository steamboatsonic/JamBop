extends Sprite2D

@onready
var gemManager = $"..";
var xPosition:float = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	# Gem will be active until it has left the target zone
	set_meta("OnScreen", false);
	set_meta("Active", true); # Hasn't been hit or missed yet
	set_meta("InRange", false); # Is inside the timing window
	#OffScreen, OnScreen, InRange, Missed, Completed
	set_meta("Status", "Offscreen");
	
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
	
	#If NOT completed, set MSecUntilPerfect
	if get_meta("Status") != "Completed":
		set_meta("MSecUntilPerfect", get_meta("TimingMSec") - gemManager.get_meta("TodaysTime"));
	
	#if offSCreen, check if it's ready to be onScreen
	if get_meta("Status") == "OffScreen":
		if get_meta("MSecUntilPerfect") < 900 / gemManager.get_meta("gravity"):
			set_meta("Status", "OnScreen")
	
	#if earlier stage than InRange, check if it's InRange
	if get_meta("Status") == "OnScreen":
		if get_meta("MSecUntilPerfect") < 250.00:
			set_meta("Status", "InRange");
			
	if get_meta("Status") == "OnScreen" || "InRange" || "Missed":
		position = Vector2(
			xPosition, 
			900 - (get_meta("MSecUntilPerfect") * gemManager.get_meta("gravity")));
		#check if it's past the last timing window
			
	if get_meta("Status") == "Missed":
		if get_meta("MSecUntilPerfect") < -750.00 / gemManager.get_meta("gravity"):
			set_meta("Status", "Completed");

func hit(timingOfHit:float):
	writeDebug (str(get_meta("TimingMSec") - timingOfHit) + "From Perfect");
	set_meta("HitAccuracy", (get_meta("TimingMSec") - timingOfHit));
	set_meta("Active", false);
	set_meta("Status", "Completed");
	visible = false;
	
func miss():
	writeDebug (str("Missed Gem..."));
	set_meta("Status", "Missed");
	modulate = Color.GRAY;

func writeDebug(textToWrite:String):
	get_node("../../../DebugText").text = textToWrite;
