extends KinematicBody2D

signal hit(node, pos)

export (float) var initial_speed = 30.0
export (float) var accel = 0.5

var speed := 0.0
var velocity := Vector2(1, -1)

# 初速の設定
func _ready():
	speed = initial_speed

# ボールの移動
# 壁などに当たったら反射
# main.gdに当たったよのシグナルを送る
# スピードちょっと上げる
# 音出す
func _physics_process(delta):
	var _col = move_and_collide(velocity * speed * delta)
	if _col != null:
		var _normal = _col.normal
		velocity = velocity.bounce(_normal)
		speed += accel
		emit_signal("hit", _col.collider, position)
		$HitSound.play()

func speed_up():
	pass