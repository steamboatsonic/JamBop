extends Node

# var startTime: int = 0;
# "today" is this frame
# "yesterday" is the previous frame 
# "tomorrow" is the expected next frame
var todaysTime: float = 0;
var gem = [0,1];
var inputWaitingLane = [];
var inputWaitingTiming = [];
var temp;

const gemParent = preload("res://gem_parent.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	# gravity is how many pixels the gem moves per millisecond
	# using the height of 1080 as standard
	set_meta("gravity", 0.5)
	set_meta("startTime", Time.get_unix_time_from_system());
	makeGem();
	
	
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
	
func makeGem():
	gem[0] = gemParent.instantiate();
	# get_parent().add_child(gem);
	gem[0].position = Vector2(100,100);
	gem[0].set_meta("TimingMSec", 5000);
	# Track identities:
	# 1 2 3 = left side
	# 4 5 6 = right side
	gem[0].set_meta("Lane", 2);
	self.add_child(gem[0]);
	
	gem[1] = gemParent.instantiate();
	gem[1].position = Vector2(100,200);
	gem[1].set_meta("TimingMSec", 6000);
	gem[1].set_meta("Lane", 5);
	self.add_child(gem[1]);
	# writeDebug(str(gem.position));
	# writeDebug(str(gem.get_meta("TimingMSec")));
	
	
	# instance.position = vector2(20,20);
	# add_child(instance);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# var startTime = Get_Ticks_MSec ();
	set_meta("todaysTime", (Time.get_unix_time_from_system() - get_meta("startTime")) * 1000);
	
	#qinput
	#Here is where we handle the InputWaiting
	#if inputWaitingTiming.size() == 2:
	#	writeDebug("Pressed two at once")
	
	for x in inputWaitingTiming.size():
		#temp = inputWaitingLane.pop_front();
		#temp = inputWaitingTiming.pop_front();
		writeDebug("Pressed " + str(inputWaitingLane.pop_front()) + " At " + str(inputWaitingTiming.pop_front()))
		
	#if inputWaitingTiming.size() == 0:
	#	writeDebug("All caught up")
	# writeDebug(str(get_meta("todaysTime")));
		
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
	elif event.is_action_pressed("Xbutton"):
		generateInputWaiting(5);
		pass
	elif event.is_action_pressed("AButton"):
		generateInputWaiting(6);
		pass
	
func generateInputWaiting(lane:float):
	inputWaitingTiming.push_back(get_meta("todaysTime"));
	inputWaitingLane.push_back(lane);
	
func writeDebug(textToWrite:String):
	get_node("../../DebugText").text = textToWrite;
