extends AnimatedSprite

export (float) var speed = 200.0
export (float) var disappear_speed = 1.0

var velocity := Vector2.ZERO

# 初速を設定
func initialize(_pos, _v):
	position = _pos 
	velocity = _v

# processでposition変更
# 速度が閾値以下になったら消滅
func _physics_process(delta):
	position += velocity * speed * delta
	speed = lerp(speed, 0.0, 0.1)
	if speed <= disappear_speed:
		queue_free()