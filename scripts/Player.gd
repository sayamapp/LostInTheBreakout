extends KinematicBody2D

signal get_coin

export (float) var default_speed := 100.0
export (float) var dash_power := 2.0
var direction := Vector2.ZERO
var speed := 0.0

# コインを取れる範囲の設定
func _ready():
	var _e = $Area2D.connect("area_entered", self, "_on_area_entered")

# Inputを見て方向を設定, dashボタンなら速度をかえる
func _process(_delta):
	direction = Vector2.ZERO
	if Input.is_action_pressed("up"):
		direction += Vector2.UP
	if Input.is_action_pressed("down"):
		direction += Vector2.DOWN
	if Input.is_action_pressed("left"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("right"):
		direction += Vector2.RIGHT
	if Input.is_action_pressed("dash"):
		speed = default_speed * dash_power
	else:
		speed = default_speed

# プレイヤの移動
func _physics_process(delta):
	var _col = move_and_collide(direction * speed * delta)
	
# コインを取ったら音出す
# main.gdにシグナルを送る。
# コインは消す。
func _on_area_entered(area):
	$AudioStreamPlayer.play()
	emit_signal("get_coin")
	area.get_parent().queue_free()