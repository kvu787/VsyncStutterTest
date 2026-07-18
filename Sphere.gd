# Assume position starts at X=0
# Assume vsync=on and game runs at locked vsync

extends MeshInstance3D

@export var speed: float = 8.0
@export var travel_distance: float = 3.0

# Get this from "Windows 11 > Settings > Display > Advanced display > Choose a refresh rate"
@export var fixed_delta_refresh_rate_hz: float = 240.0

var direction: int = 1

func _process(delta: float) -> void:
	if self.fixed_delta_refresh_rate_hz > 0.0:
		delta = 1.0 / self.fixed_delta_refresh_rate_hz

	self.position.x += self.direction * self.speed * delta

	# Some overshoot is fine
	if abs(self.position.x) > self.travel_distance:
		self.direction *= -1
