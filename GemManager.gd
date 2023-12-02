extends Node

# var startTime: int = 0;
var startTime: float = Time.get_unix_time_from_system();
# "today" is this frame
# "yesterday" is the previous frame 
# "tomorrow" is the expected next frame
var todaysTime: float = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	var gems = [1];
	# gems[0] = $GemParent.Duplicate();
	#Generate the Gems
	gems[0] = $GemParent.duplicate();
	# gems[0].set_meta(TimingMSec, 10000.00);
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# var startTime = Get_Ticks_MSec ();
	todaysTime = Time.get_unix_time_from_system() - startTime;
	get_node("../../DebugText").text = str(todaysTime);
	
