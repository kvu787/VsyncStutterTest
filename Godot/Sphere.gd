# Assume position starts at X=0
# Assume vsync=on and game runs at locked vsync

extends MeshInstance3D

const Speed: float = 8.0
const TravelDistance: float = 3.0

var Direction: int = 1

func _init():
	print("BEGIN: Sphere._init()")

	# This should decrease the average input latency.
	# However, it should't change the theoretical upper bound for input latency.
	# The theoretical upper bound for input latency should still be 2 intervals.
	Input.set_use_accumulated_input(false)

	print("END: Sphere._init()")


func _process(delta: float) -> void:
	self.position.x += self.Direction * self.Speed * delta

	if abs(self.position.x) > self.TravelDistance:
		if self.position.x > 0:
			self.Direction = -1
		else:
			self.Direction = 1
