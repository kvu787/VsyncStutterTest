# Assume sphere position starts at X=0

extends MeshInstance3D

const Speed: float = 8.0
const TravelDistance: float = 7.0

var Direction: int
var FrameCount: int

func _init():
	print("BEGIN: Sphere._init()")

	# This should decrease the average input latency.
	# However, it should't change the theoretical upper bound for input latency.
	# The theoretical upper bound for input latency should still be 2 intervals.
	Input.set_use_accumulated_input(false)

	self.Direction = 1
	self.FrameCount = 0

	print("END: Sphere._init()")

func _process(delta: float) -> void:
	#while (Time.get_ticks_usec() - 1_000_000) < (self.FrameCount * 4_167):
		#pass

	self.position.x += self.Direction * self.Speed * (1.0/240.0)

	if abs(self.position.x) > self.TravelDistance:
		if self.position.x > 0:
			self.Direction = -1
		else:
			self.Direction = 1

	self.FrameCount += 1
