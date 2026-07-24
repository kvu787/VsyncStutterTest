# Assume position starts at X=0
# Assume vsync=on and game runs at locked vsync

extends MeshInstance3D
var speed: float = 8.0
var travel_distance: float = 3.0

# Get this from "Windows 11 > Settings > Display > Advanced display > Choose a refresh rate"
var fixed_delta_refresh_rate_hz: float = 240.0

var direction: int = 1
var const_delta: float = 1.0 / 315.0

func _init():
	# This should decrease the average input latency.
	# However, it should't change the theoretical upper bound for input latency.
	# The theoretical upper bound for input latency should still be 2 intervals.
	Input.set_use_accumulated_input(false)

	print("Sphere._init()")

func _process(delta: float) -> void:
	self.position.x += self.direction * self.speed * delta

	# Some overshoot is fine
	if abs(self.position.x) > self.travel_distance:
		self.direction *= -1
