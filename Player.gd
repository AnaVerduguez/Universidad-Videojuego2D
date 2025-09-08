# Script del jugador (Gato)
extends CharacterBody2D
class_name Player

@export var velocidad_caminar := 200.0
@export var friccion := 0.8

var color_gato := Color.ORANGE
var siendo_observado := false
var puede_moverse := true

# Referencias se configurarán cuando se cree la escena
var sprite_gato: Sprite2D
var area_interaccion: Area2D

signal intentar_tirar_objeto(posicion: Vector2)
signal gato_se_movio(velocidad: Vector2)

func _ready():
	actualizar_color_gato()
	print("Player listo - configurar nodos en escena para funcionalidad completa")

func _physics_process(delta):
	if not puede_moverse:
		return
	
	var direccion_movimiento = obtener_direccion_entrada()
	
	if direccion_movimiento != Vector2.ZERO:
		velocity = direccion_movimiento * velocidad_caminar
		gato_se_movio.emit(velocity)
	else:
		velocity = velocity * friccion
	
	move_and_slide()
	actualizar_orientacion_sprite(direccion_movimiento)

func obtener_direccion_entrada() -> Vector2:
	var direccion = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		direccion.x -= 1
	if Input.is_action_pressed("move_right"):
		direccion.x += 1
	if Input.is_action_pressed("move_up"):
		direccion.y -= 1
	if Input.is_action_pressed("move_down"):
		direccion.y += 1
	
	return direccion.normalized()

func actualizar_orientacion_sprite(direccion: Vector2):
	if not sprite_gato:
		return
	
	if direccion.x > 0:
		sprite_gato.flip_h = false
	elif direccion.x < 0:
		sprite_gato.flip_h = true

func _input(event):
	if event.is_action_pressed("throw_item") and puede_moverse:
		var posicion_tirar = obtener_posicion_objetivo()
		intentar_tirar_objeto.emit(posicion_tirar)

func obtener_posicion_objetivo() -> Vector2:
	return get_global_mouse_position()

func set_cat_color(nuevo_color: Color):
	color_gato = nuevo_color
	actualizar_color_gato()

func actualizar_color_gato():
	if sprite_gato:
		sprite_gato.modulate = color_gato

func detener_movimiento():
	puede_moverse = false
	velocity = Vector2.ZERO

func reanudar_movimiento():
	puede_moverse = true

func marcar_como_observado(observado: bool):
	siendo_observado = observado
	if sprite_gato:
		if siendo_observado:
			sprite_gato.modulate = Color(color_gato.r, color_gato.g, color_gato.b, 0.7)
		else:
			sprite_gato.modulate = color_gato

func obtener_velocidad_actual() -> float:
	return velocity.length()

func esta_moviendose() -> bool:
	return velocity.length() > 10.0

func _on_objeto_cerca(objeto):
	if objeto.has_method("resaltar"):
		objeto.resaltar(true)

func _on_objeto_lejos(objeto):
	if objeto.has_method("resaltar"):
		objeto.resaltar(false)
