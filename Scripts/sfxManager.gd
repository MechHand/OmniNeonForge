extends Node

func playSfx(sound: AudioStream, parent: Node, pitchRandom: float, volume: float):
	if sound != null and parent != null:
		var stream = AudioStreamPlayer.new()
		
		stream.stream = sound
		
		parent.add_child(stream)
		stream.play()
		
		stream.volume_db = volume
		
		randomize()
		stream.pitch_scale = randf_range(1-pitchRandom, 1+pitchRandom)
