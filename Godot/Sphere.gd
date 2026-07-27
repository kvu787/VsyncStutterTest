# Assume position starts at X=0
# Assume vsync=on and game runs at locked vsync

extends MeshInstance3D

var speed: float = 8.0
var travel_distance: float = 3.0
var direction: int = 1

func _init():
	print("BEGIN: Sphere._init()")

	# This should decrease the average input latency.
	# However, it should't change the theoretical upper bound for input latency.
	# The theoretical upper bound for input latency should still be 2 intervals.
	Input.set_use_accumulated_input(false)

	print("END: Sphere._init()")


func _process(delta: float) -> void:
	self.position.x += self.direction * self.speed * delta

	if abs(self.position.x) > self.travel_distance:
		if self.position.x > 0:
			self.direction = -1
		else:
			self.direction = 1
