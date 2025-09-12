# Script del jugador (Gato) - Juego de Plataformas
extends CharacterBody2D
class_name Player

# Configuración de movimiento de plataforma
@export var velocidad_caminar := 300.0
@export var velocidad_salto := -600.0
@export var gravedad := 2000.0
@export var friccion := 0.85

var color_gato := Color.BLACK
var siendo_observado := false
var puede_moverse := true
var en_suelo := false

# Referencias se configurarán cuando se cree la escena
var sprite_gato: Sprite2D
var area_interaccion: Area2D

signal gato_se_movio(velocidad: Vector2)
signal gato_salto()
signal item_recolectado(tipo: String)
signal gato_colisiono_obstaculo()

func _ready():
	cargar_textura_gato_real()
	actualizar_color_gato()
	print("Player listo con textura del gato")

func _physics_process(delta):
	if not puede_moverse:
		return
	
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravedad * delta
		en_suelo = false
	else:
		en_suelo = true
	
	# Manejar salto con barra espaciadora
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = velocidad_salto
		gato_salto.emit()
	
	# Movimiento horizontal
	var direccion_horizontal = obtener_direccion_horizontal()
	
	if direccion_horizontal != 0:
		velocity.x = direccion_horizontal * velocidad_caminar
	else:
		velocity.x = velocity.x * friccion
	
	var velocidad_anterior = velocity
	move_and_slide()
	
	# Emitir señales si hay movimiento
	if velocity != Vector2.ZERO:
		gato_se_movio.emit(velocity)
	
	actualizar_orientacion_sprite(direccion_horizontal)

func obtener_direccion_horizontal() -> int:
	var direccion = 0
	
	if Input.is_action_pressed("move_left"):
		direccion -= 1
	if Input.is_action_pressed("move_right"):
		direccion += 1
	
	return direccion

func actualizar_orientacion_sprite(direccion_x: int):
	if not sprite_gato:
		return
	
	if direccion_x > 0:
		sprite_gato.flip_h = false
	elif direccion_x < 0:
		sprite_gato.flip_h = true

func _input(event):
	# El manejo de salto se hace en _physics_process para mejor control
	pass

func set_cat_color(nuevo_color: Color):
	color_gato = nuevo_color
	cargar_textura_gato_real()  # Recarga la textura del gato
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

func cargar_textura_gato_real():
	"""Carga la textura real del gato desde los Game Assets"""
	if not sprite_gato:
		return
	
	# Cargar la nueva imagen del gato en formato JPG
	var texture = load("res://Game Assets/cat.jpg")
	if texture:
		sprite_gato.texture = texture
		# Escalar adecuadamente para el juego - JPG puede necesitar diferente escala
		sprite_gato.scale = Vector2(0.2, 0.2)  # Ajustado para la nueva imagen
		print("Textura del gato JPG cargada exitosamente")
	else:
		print("Error: No se pudo cargar la textura del gato JPG")
		# Fallback: crear un sprite simple
		crear_sprite_simple_fallback()

func crear_sprite_simple_fallback():
	"""Crea un sprite simple si no se puede cargar la textura"""
	if not sprite_gato:
		return
	
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(color_gato)
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	sprite_gato.texture = texture
	sprite_gato.scale = Vector2(1, 1)

func recoger_item(tipo_item: String, puntos: int = 10):
	"""Función llamada cuando el gato recoge un item coleccionable"""
	item_recolectado.emit(tipo_item)
	print("¡Gato recogió: " + tipo_item + "! +" + str(puntos) + " puntos")

func colisionar_con_obstaculo(tipo_obstaculo: String):
	"""Función llamada cuando el gato colisiona con un obstáculo"""
	gato_colisiono_obstaculo.emit()
	print("¡Gato colisionó con: " + tipo_obstaculo + "!")

func obtener_estado_salto() -> String:
	"""Devuelve el estado actual del gato para animaciones"""
	if not en_suelo:
		if velocity.y < 0:
			return "saltando"
		else:
			return "cayendo"
	elif esta_moviendose():
		return "caminando"
	else:
		return "parado"
