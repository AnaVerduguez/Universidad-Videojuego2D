# Script del jugador (Gato) - Juego de Plataformas
extends CharacterBody2D
class_name Player

# Configuración de movimiento de plataforma
@export var velocidad_caminar := 300.0
@export var velocidad_salto := -600.0
@export var gravedad := 2000.0
@export var friccion := 0.85

var color_gato := Color.WHITE
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
	# NO actualizar color para mantener la imagen original
	# actualizar_color_gato()

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
	"""Cargar la imagen real del gato desde cat.jpg"""
	if not sprite_gato:
		print("❌ Error: sprite_gato no está configurado")
		return
	
	# Cargar directamente la imagen cat.jpg
	print("🔍 Intentando cargar: res://Game Assets/cat.jpg")
	var texture = load("res://Game Assets/cat.jpg")
	if texture:
		print("✅ Textura cargada: " + str(texture))
		print("📏 Tamaño de imagen: " + str(texture.get_size()))
		
		sprite_gato.texture = texture
		# Escala apropiada para que se vea bien
		sprite_gato.scale = Vector2(0.2, 0.2)  # Aumentado un poco para mejor visibilidad
		# Sin modulación de color para que se vea natural
		sprite_gato.modulate = Color.WHITE
		
		print("🐾 Imagen cat.jpg aplicada al sprite exitosamente")
		print("📐 Escala aplicada: " + str(sprite_gato.scale))
	else:
		print("❌ Error: No se pudo cargar cat.jpg, usando gato generado...")
		# Fallback: crear gato por código
		crear_gato_con_silueta()

func crear_gato_con_silueta():
	"""Crea un gato grande con silueta realista"""
	if not sprite_gato:
		return
	
	# Crear imagen de 80x60 píxeles para un gato más grande
	var image = Image.create(80, 60, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	# === CUERPO PRINCIPAL DEL GATO ===
	# Cuerpo ovalado más realista
	for y in range(35, 55):
		for x in range(25, 55):
			var dx = float(x - 40)
			var dy = float(y - 45)
			if (dx * dx / 225.0 + dy * dy / 100.0) <= 1:
				image.set_pixel(x, y, Color.BLACK)
	
	# === CABEZA REDONDA GRANDE ===
	for y in range(15, 40):
		for x in range(30, 50):
			var dx = float(x - 40)
			var dy = float(y - 27.5)
			if (dx * dx + dy * dy) <= 156:
				image.set_pixel(x, y, Color.BLACK)
	
	# === OREJAS TRIANGULARES GRANDES ===
	# Oreja izquierda
	for y in range(10, 25):
		for x in range(25, 35):
			var dx = x - 30
			var dy = y - 10
			if dx >= -5 and dy >= 0 and (dx + dy * 1.2) <= 10:
				image.set_pixel(x, y, Color.BLACK)
	
	# Oreja derecha
	for y in range(10, 25):
		for x in range(45, 55):
			var dx = 50 - x
			var dy = y - 10
			if dx >= -5 and dy >= 0 and (dx + dy * 1.2) <= 10:
				image.set_pixel(x, y, Color.BLACK)
	
	# === OJOS BRILLANTES ===
	# Ojo izquierdo
	for y in range(22, 28):
		for x in range(34, 38):
			var dx = x - 36
			var dy = y - 25
			if (dx * dx + dy * dy) <= 4:
				image.set_pixel(x, y, Color.YELLOW)
	
	# Ojo derecho
	for y in range(22, 28):
		for x in range(42, 46):
			var dx = x - 44
			var dy = y - 25
			if (dx * dx + dy * dy) <= 4:
				image.set_pixel(x, y, Color.YELLOW)
	
	# Pupilas
	image.set_pixel(35, 25, Color.BLACK)
	image.set_pixel(36, 25, Color.BLACK)
	image.set_pixel(43, 25, Color.BLACK)
	image.set_pixel(44, 25, Color.BLACK)
	
	# === NARIZ Y BOCA ===
	# Nariz rosada
	image.set_pixel(39, 30, Color.PINK)
	image.set_pixel(40, 30, Color.PINK)
	image.set_pixel(40, 31, Color.PINK)
	
	# Boca
	image.set_pixel(38, 32, Color.BLACK)
	image.set_pixel(41, 32, Color.BLACK)
	image.set_pixel(37, 33, Color.BLACK)
	image.set_pixel(42, 33, Color.BLACK)
	
	# === PATAS VISIBLES ===
	# Patas delanteras
	for y in range(50, 58):
		for x in range(30, 34):
			image.set_pixel(x, y, Color.BLACK)
		for x in range(46, 50):
			image.set_pixel(x, y, Color.BLACK)
	
	# === COLA CURVADA ===
	# Dibujar cola más elegante
	var cola_points = [
		Vector2(55, 40), Vector2(60, 35), Vector2(65, 30),
		Vector2(68, 25), Vector2(70, 20), Vector2(68, 15), Vector2(65, 12)
	]
	
	for i in range(len(cola_points) - 1):
		var start = cola_points[i]
		var end = cola_points[i + 1]
		for t in range(0, 10):
			var pos = start.lerp(end, t / 9.0)
			var px = int(pos.x)
			var py = int(pos.y)
			if px < 80 and py < 60 and px >= 0 and py >= 0:
				image.set_pixel(px, py, Color.BLACK)
				# Hacer cola más gruesa
				if px + 1 < 80: image.set_pixel(px + 1, py, Color.BLACK)
				if py + 1 < 60: image.set_pixel(px, py + 1, Color.BLACK)
	
	# Crear textura final
	var texture = ImageTexture.new()
	texture.set_image(image)
	sprite_gato.texture = texture
	
	# Escala más grande para que se vea bien
	sprite_gato.scale = Vector2(1.2, 1.2)
	print("🐾 Gato con silueta creado exitosamente")

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
