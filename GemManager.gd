extends Node

# var startTime: int = 0;
var startTime: float = Time.get_unix_time_from_system();
# "today" is this frame
# "yesterday" is the previous frame 
# "tomorrow" is the expected next frame
var todaysTime: float = 0;
var gems = [1];

const gemParent = preload("res://gem_parent.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
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
	var gem = gemParent.instantiate();
	get_parent().add_child(gem);
	gem.position = Vector2(100,100);
	gem.set_meta("TimingMSec", 10.000);
	# writeDebug(str(gem.position));
	writeDebug(str(gem.get_meta("TimingMSec")));
	
	
	# instance.position = vector2(20,20);
	# add_child(instance);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# var startTime = Get_Ticks_MSec ();
	todaysTime = Time.get_unix_time_from_system() - startTime;
	# get_node("../../DebugText").text = str(todaysTime);
	
func writeDebug(textToWrite:String):
	get_node("../../DebugText").text = textToWrite;
