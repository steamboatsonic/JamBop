extends Node

# var startTime: int = 0;
# "today" is this frame
# "yesterday" is the previous frame 
# "tomorrow" is the expected next frame
var gem = [0,1, 2, 3];
var inputWaitingLane = [];
var inputWaitingTiming = [];
# var inputRecordedTiming = [];
var nextGem: int = 0;
# stage 0 = get ready, 1 = playing, 2 = finished
var stage: int = 0;

var laneToHit: int = 0;
var gemToHit: int = 0;
var timingOfHit: float = 0;
var somethingToHit: bool = false;

var temp;

const gemParent = preload("res://gem_parent.tscn");
# How many ms in each direction you can be off before being knocked to the next timing window
# 5000, 4500, 4000, 3500, 3000, 2500, 2000
const timingWindow = [25, 40, 65, 100, 175, 225, 250];

# Called when the node enters the scene tree for the first time.
func _ready():
	# each lane has its own array of times your pressed the button for it
	#for i in range(7): 
	#	inputRecordedTiming.append([])
	
	# gravity is how many pixels the gem moves per millisecond
	# using the height of 1080 as standard
	set_meta("gravity", 0.5)
	set_meta("StartTime", Time.get_unix_time_from_system());
	nextGem = 0;
	inputWaitingLane.clear();
	inputWaitingTiming.clear();
	
	makeGem(0, 2000, 2);
	makeGem(1, 2250, 2);
	makeGem(2, 2250, 5);
	makeGem(3, 2500, 5);
	
	stage = 1;
	
	# var gemParent = $GemParent;
	# var gemManager = $GemManager;
	# var gems = [1];
	# gems[0] = $GemParent.Duplicate();
	#Generate the Gems
	
	# gems[0] = gemParent.duplicate();
	# gems[0].position.x = 0;
	
	# $GemManager.add_child(gems[0]);
	# gemManager.add_child(gems[0])
	# add_child(gems[0]);
	# gems[0].Set_owner(gemManager);
	# gems[0].add_child(gemManager);
	# gems[0].set_meta(TimingMSec, 10000.00);
	pass
	
func makeGem(gemNumber:int, timingToApply, laneToApply):
	gem[gemNumber] = gemParent.instantiate();
	# get_parent().add_child(gem);
	gem[gemNumber].position = Vector2(100,100);
	gem[gemNumber].set_meta("TimingMSec", timingToApply);
	# Track identities:
	# 1 2 3 = left side
	# 4 5 6 = right side
	gem[gemNumber].set_meta("Lane", laneToApply);
	self.add_child(gem[gemNumber]);
	
	# writeDebug(str(gem.position));
	# writeDebug(str(gem.get_meta("TimingMSec")));
	
	
	# instance.position = vector2(20,20);
	# add_child(instance);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# var startTime = Get_Ticks_MSec ();
	set_meta("TodaysTime", (Time.get_unix_time_from_system() - get_meta("StartTime")) * 1000);
	
	#qinput
	#Here is where we handle the InputWaiting
	#if inputWaitingTiming.size() == 2:
	#	writeDebug("Pressed two at once")
	
	# for pressed buttons, check for gems on this side
	if stage == 1:
		for x in inputWaitingTiming.size():
			#temp = inputWaitingLane.pop_front();
			#temp = inputWaitingTiming.pop_front();
			# writeDebug("Pressed " + str(inputWaitingLane.pop_front()) + " At " + str(inputWaitingTiming.pop_front()))
			# look for earliest gem in this lane in range
			gemToHit = nextGem;
			somethingToHit = false;
			laneToHit = inputWaitingLane.pop_front();
			timingOfHit = inputWaitingTiming.pop_front();
			
			#skip gems if they are in the wrong lane or have already completed
			while gem[gemToHit].get_meta("Lane") != laneToHit  \
				|| gem[gemToHit].get_meta("TimingMSec") < timingOfHit - timingWindow.back() \
				|| gem[gemToHit].get_meta("Status") == "Missed" \
				|| gem[gemToHit].get_meta("Status") == "Hit" \
				|| gem[gemToHit].get_meta("Status") == "Completed":
					#if the gem we're checking hasn't reached the timing window yet, no gem was hit
					if gem[gemToHit].get_meta("TimingMSec") > timingOfHit + timingWindow.back():
						break;
					gemToHit += 1;
			
			# we either found the next gem in the lane, or found there are no gems in the lane
			# if the gem we cycled to is in the lane and in the timing window
			if gemToHit < gem.size():
				if gem[gemToHit].get_meta("Lane") == laneToHit \
					and gem[gemToHit].get_meta("TimingMSec") > timingOfHit - timingWindow.back() \
					and gem[gemToHit].get_meta("TimingMSec") < timingOfHit + timingWindow.back():
						somethingToHit = true;
						gem[gemToHit].hit(timingOfHit);
			
		# Now look for gems that have left the playfield without being hit
		# Doing it here instead of gem.gd to make sure inputs were considered first
		if nextGem >= gem.size():
			stage = 2
		else:
			while gem[nextGem].get_meta("TimingMSec") < get_meta("TodaysTime") - timingWindow.back():
				gem[gemToHit].miss();
				nextGem += 1;
				if nextGem >= gem.size():
					# writeDebug("All gems accounted for")
					stage = 2;
					break
		
		#while gem[nextGem].get_meta("MSecUntilPerfect") < -timingWindow.back():
			#TODO
		#	gem[nextGem].passedBy();
		#	
		#	nextGem += 1;
		#	if nextGem >= gem.size():
		#		
	
	#if inputWaitingTiming.size() == 0:
	#	writeDebug("All caught up")
	# writeDebug(str(get_meta("todaysTime")));
	
	# when a button is pressed, all gems in range are tested
	# in range = on a lane on the same side and in the timing window
	# the highest-scoring gem is counted
	# gem scores are not finalized until they fully leave the timing window
	# if a second button press scores higher on a gem already claimed
	# the first press is reapplied on any earlier gem if it scores higher
		
func _input(event):
	if event.is_action_pressed("Left"):
		generateInputWaiting(1);
		pass
	elif event.is_action_pressed("Down"):
		generateInputWaiting(2);
		pass
	elif event.is_action_pressed("Up"):
		generateInputWaiting(2);
		pass
	elif event.is_action_pressed("Right"):
		generateInputWaiting(3);
		pass
	elif event.is_action_pressed("YButton"):
		generateInputWaiting(4);
		pass
	elif event.is_action_pressed("BButton"):
		generateInputWaiting(5);
		pass
	elif event.is_action_pressed("XButton"):
		generateInputWaiting(5);
		pass
	elif event.is_action_pressed("AButton"):
		generateInputWaiting(6);
		pass
	
func generateInputWaiting(lane:float):
	inputWaitingTiming.push_back(get_meta("TodaysTime"));
	inputWaitingLane.push_back(lane);
	
func writeDebug(textToWrite:String):
	get_node("../../DebugText").text = textToWrite;
