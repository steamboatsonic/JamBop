extends Sprite2D

@onready
var gemManager = $"..";
var xPosition:float = 0;
var judgment;

const judgmentParent = preload("res://judgmentParent.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	# Gem will be active until it has left the target zone
	set_meta("OnScreen", false);
	set_meta("Active", true); # Hasn't been hit or missed yet
	set_meta("InRange", false); # Is inside the timing window
	#OffScreen, OnScreen, InRange, Missed, Hit, Completed
	set_meta("Status", "OffScreen");
	
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
			
	if get_meta("Status") == "OnScreen" \
		|| get_meta("Status") == "InRange" \
		|| get_meta("Status") == "Missed":
			position = Vector2(
				xPosition, 
				900 - (get_meta("MSecUntilPerfect") * gemManager.get_meta("gravity")));
			#check if it's past the last timing window
	
	if get_meta("Status") == "Hit":
		if get_meta("Road") == 1:
			position = Vector2(
			position.x - 10,
			position.y);
			if position.x < 400:
				position = Vector2(
				400,
				position.y);
				set_meta("Status", "Completed")
				visible = false;
		elif get_meta("Road") == 2:
			position = Vector2(
			position.x + 10,
			position.y);
			if position.x > 1520:
				position = Vector2(
				1520,
				position.y);
				set_meta("Status", "Completed")
				visible = false;
			
	if get_meta("Status") == "Missed":
		if get_meta("MSecUntilPerfect") < -750.00 / gemManager.get_meta("gravity"):
			set_meta("Status", "Completed");
			visible = false;

func hit(timingOfHit:float):
	# HitAccuracy is like MSecUntilPerfect except it is accurate to exact input timing
	# between frames
	# early = positive, late = negative
	set_meta("HitAccuracy", (get_meta("TimingMSec") - timingOfHit));
	# writeDebug (str(get_meta("HitAccuracy")) + "From Perfect");
	var absAccuracy = abs(get_meta("HitAccuracy"));
	if absAccuracy > gemManager.timingWindow[6]:
		set_meta("Score", 2000);
		writeDebug ("X( Scored while out of range!")
	elif absAccuracy > gemManager.timingWindow[5]:
		set_meta("Score", 2000);
	elif absAccuracy > gemManager.timingWindow[4]:
		set_meta("Score", 2500);
	elif absAccuracy > gemManager.timingWindow[3]:
		set_meta("Score", 3000);
	elif absAccuracy > gemManager.timingWindow[2]:
		set_meta("Score", 3500);
	elif absAccuracy > gemManager.timingWindow[1]:
		set_meta("Score", 4000);
	elif absAccuracy > gemManager.timingWindow[0]:
		set_meta("Score", 4500);
	else:
		set_meta("Score", 5000);
	
	if get_meta("HitAccuracy") > 0:
		set_meta("EarlyHit", true);
		writeDebug(str(get_meta("Score")) + ", Early");
	else:
		set_meta("EarlyHit", false);
		writeDebug(str(get_meta("Score")) + ", Late");
	
	# During Hit slide animation, yPosition will be locked based on exact timing of input
	position = Vector2(
		position.x,
		900 - (get_meta("HitAccuracy") * gemManager.get_meta("gravity")));
	set_meta("Status", "Hit");
	makeJudgment(get_meta("HitAccuracy"));
	
func miss():
	if get_meta("Status") != "Hit":
		writeDebug (str("Missed Gem..."));
		set_meta("Status", "Missed");
		modulate = Color.GRAY;
		
func makeJudgment(timing:float):
	judgment = judgmentParent.instantiate();
	judgment.position = Vector2(960 - timing, 300);
	judgment.set_meta("Timing", timing);
	if timing < -25:
		judgment.modulate = Color.GREEN;
	elif timing > 25:
		judgment.modulate = Color.ORANGE_RED;
	else:
		judgment.modulate = Color.WHITE;
	$"../".add_child(judgment);

func writeDebug(textToWrite:String):
	get_node("../../../DebugText").text = textToWrite;
