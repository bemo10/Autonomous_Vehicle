extends Node2D


onready var hitTextureAnimation = $HitTextureAnimation
onready var hitTextAnimation = $HitTextAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func hit():
	hitTextureAnimation.play("HitTextureAnimation")
	hitTextAnimation.play("HitTextAnimation")
