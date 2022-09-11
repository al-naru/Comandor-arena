extends ClippedCamera

export var cam_speed = 1
export var cam_up_height = 10
var cam_up = Vector3()
var cam_down = Vector3()
var cam_rotate_up = Vector3()
var cam_rotate_down = Vector3()
var camera_is_down = true
var camera_is_up = false
onready var tween = get_node("Tween")
onready var camera = self

func _ready():
	cam_init()

func cam_init():
	cam_up = camera.translation
	cam_up.y = cam_up_height
	cam_down = camera.translation
	camera.rotation_degrees.x = -angle_for_this_point(cam_down, Vector3(0, 0, 0))
	cam_rotate_down.x = camera.rotation_degrees.x
	cam_rotate_up.x = -angle_for_this_point(cam_up, Vector3(0, 0, 0))

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			camera_move()

func camera_move():
	if !tween.is_active() and camera_is_down:
		tween.interpolate_property(
			camera, "translation", cam_down, cam_up, cam_speed)
		tween.interpolate_property(
			camera, "rotation_degrees", cam_rotate_down, cam_rotate_up, cam_speed)
		tween.start()
		camera_is_up = true
		camera_is_down = false
	if !tween.is_active() and camera_is_up:
		tween.interpolate_property(
			camera, "translation", cam_up, cam_down, cam_speed)
		tween.interpolate_property(
			camera, "rotation_degrees", cam_rotate_up, cam_rotate_down, cam_speed)
		tween.start()
		camera_is_down = true
		camera_is_up = false
		
func angle_for_this_point(camera_pos:Vector3, object_pos:Vector3):
	var angle = acos(camera_pos.z / camera_pos.distance_to(object_pos))*180/PI
	return(angle)
		
func _log() -> void:
	print("высота камеры ", cam_up_height)
	print("растояние до объекта ", cam_down.distance_to(Vector3(0, 0, 0)))
	print("растояние до объекта 2", cam_up.distance_to(Vector3(0, 0, 0)))
	print("позиция камеры", cam_up)
	print("угол ", -angle_for_this_point(cam_up, Vector3(0, 0, 0)))
	print("первый поворот камеры ", cam_rotate_down)
	print("второй поворот камеры ", cam_rotate_up)



