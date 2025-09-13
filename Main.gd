# Script principal del juego "Gato Travieso"

extends Node2D
class_name Main

signal game_over
signal score_changed(new_score)
signal item_collected(item_type: String, points: int)

var score := 0
var total_score := 0 # Puntos persistentes
var game_active := false
var items_collected := 0
var obstacles_avoided := 0
var game_time := 0.0

# Configuración de dificultad y objetivo
var obstacle_spawn_rate := 2.0 # Segundos entre obstáculos
var collectible_spawn_rate := 1.5 # Segundos entre coleccionables
var game_speed := 1.0
var target_score := 1000 # ¡Objetivo: llegar a 1000 puntos!

# Referencias se configurarán cuando se creen las escenas
var player: Player
var ui
var obstacles_container: Node2D
var collectibles_container: Node2D
var platforms_container: Node2D
var game_background: ParallaxBackground

# Temporizadores para spawn
var obstacle_timer := 0.0
var collectible_timer := 0.0

func _ready():
	# Crear y configurar el fondo primero
	crear_fondo()
	
	# Conectar nodos de la escena
	player = $Player
	ui = $UI
	
	# Crear containers para obstáculos y coleccionables
	obstacles_container = $ThrowableItems  # Reutilizamos este nodo
	obstacles_container.name = "ObstaclesContainer"
	
	collectibles_container = Node2D.new()
	collectibles_container.name = "CollectiblesContainer"
	add_child(collectibles_container)
	
	platforms_container = Node2D.new()
	platforms_container.name = "PlatformsContainer" 
	add_child(platforms_container)
	
	# Conectar referencias en el jugador
	if player:
		player.sprite_gato = player.get_node("Sprite2D")
		player.area_interaccion = player.get_node("AreaInteraccion")
		
		# Conectar señales del gato
		player.item_recolectado.connect(_on_item_collected)
		player.gato_colisiono_obstaculo.connect(_on_obstacle_collision)
	
	# Conectar señales
	game_over.connect(_on_game_over)
	score_changed.connect(_on_score_changed)
	item_collected.connect(_on_item_collected_signal)
	
	setup_game()
	show_game_intro()
	print("¡Gato Travieso iniciado correctamente!")

func setup_game():
	score = 0
	items_collected = 0
	obstacles_avoided = 0
	game_time = 0.0
	game_active = true
	obstacle_timer = 0.0
	collectible_timer = 0.0
	
	# Limpiar containers existentes
	for child in obstacles_container.get_children():
		child.queue_free()
	for child in collectibles_container.get_children():
		child.queue_free()
	
	# Crear plataformas básicas
	crear_plataformas_iniciales()
	
	print("¡Gato Travieso listo! Usa A/D para moverte y ESPACIO para saltar!")
	print("Evita los obstáculos y recoge comida para ganar puntos!")

func show_game_intro():
	print("🐱 ¡BIENVENIDO A GATO TRAVIESO! 🐱")
	print("Puntos totales: " + str(total_score))
	print("")
	print("🎯 OBJETIVO: ¡LLEGAR A " + str(target_score) + " PUNTOS!")
	print("- Muévete con A/D y salta con ESPACIO")
	print("- Evita: ratones, charcos, cajas y escobas")
	print("- Recoge: pollo, pescado, leche y pelotas")
	print("- ¡Sobrevive hasta conseguir " + str(target_score) + " puntos para GANAR!")
	print("")
	print("🐾 Tu gato negro está listo para la aventura")
	
	set_cat_color_natural()

func crear_fondo():
	"""Crea y configura el fondo de bosque pixel art con múltiples capas parallax"""
	# Crear el fondo manualmente usando ParallaxBackground
	game_background = ParallaxBackground.new()
	add_child(game_background)
	# Mover el fondo al fondo de la jerarquía
	move_child(game_background, 0)
	
	# Configurar el parallax background
	game_background.scroll_ignore_camera_zoom = false
	
	print("🌲 Creando fondo de bosque pixel art con parallax multicapa...")
	
	# TEST: Solo una capa para debuggear
	print("🔧 MODO DEBUG: Solo cargando una capa para probar")
	crear_capa_bosque("Layer_0011_0.png", Vector2(0.1, 0.0), "Cielo")
	
	# CÓDIGO COMPLETO COMENTADO TEMPORALMENTE
	# # Definir las capas del bosque con sus velocidades de parallax (SIMPLIFICADO para debug)
	# # Empezamos con menos capas para debuggear
	# var forest_layers = [
	# 	{"file": "Layer_0011_0.png", "speed": Vector2(0.1, 0.0), "name": "Cielo"},
	# 	{"file": "Layer_0010_1.png", "speed": Vector2(0.2, 0.0), "name": "Montañas lejanas"},
	# 	{"file": "Layer_0009_2.png", "speed": Vector2(0.3, 0.0), "name": "Árboles fondo"},
	# 	{"file": "Layer_0008_3.png", "speed": Vector2(0.4, 0.0), "name": "Bosque medio"},
	# 	{"file": "Layer_0006_4.png", "speed": Vector2(0.5, 0.0), "name": "Árboles medios"},
	# 	{"file": "Layer_0003_6.png", "speed": Vector2(0.7, 0.0), "name": "Árboles cercanos"},
	# 	{"file": "Layer_0000_9.png", "speed": Vector2(1.0, 0.0), "name": "Primer plano"}
	# ]
	
	# # Crear cada capa de parallax
	# for layer_data in forest_layers:
	# 	crear_capa_bosque(layer_data.file, layer_data.speed, layer_data.name)


func crear_capa_bosque(archivo: String, velocidad_parallax: Vector2, nombre_capa: String):
	"""Crea una capa individual del fondo de bosque"""
	print("🌿 Creando capa: " + nombre_capa + " (" + archivo + ")")
	
	# Crear la capa de parallax
	var parallax_layer = ParallaxLayer.new()
	parallax_layer.motion_scale = velocidad_parallax
	game_background.add_child(parallax_layer)
	
	# Crear el sprite para esta capa
	var layer_sprite = Sprite2D.new()
	parallax_layer.add_child(layer_sprite)
	
	# Cargar la imagen de la capa
	var ruta_imagen = "res://Game Assets/Background layers/" + archivo
	print("📁 Cargando: " + ruta_imagen)
	
	var texture = load(ruta_imagen)
	if texture:
		layer_sprite.texture = texture
		print("✅ Textura cargada: " + str(texture.get_size()))
		
		# Configurar posición y escala
		configurar_capa_bosque(layer_sprite, parallax_layer)
	else:
		print("❌ Error: No se pudo cargar " + archivo)
		# Crear un color de debug para identificar la capa
		crear_capa_debug(layer_sprite, parallax_layer, nombre_capa)

func configurar_capa_bosque(sprite: Sprite2D, layer: ParallaxLayer):
	"""Configura la escala y posición de una capa del bosque"""
	var screen_size = get_viewport().get_visible_rect().size
	var texture_size = sprite.texture.get_size()
	
	# Calcular escala para cubrir toda la pantalla sin deformar
	var scale_x = screen_size.x / texture_size.x
	var scale_y = screen_size.y / texture_size.y
	var scale_factor = max(scale_x, scale_y)  # Usar la escala mayor para cubrir toda la pantalla
	
	# Aplicar escala
	sprite.scale = Vector2(scale_factor, scale_factor)
	
	# Posicionar el sprite correctamente
	sprite.position = Vector2(screen_size.x / 2, screen_size.y / 2)
	
	# Configurar repetición horizontal para parallax infinito
	var repeat_width = texture_size.x * scale_factor
	layer.motion_mirroring = Vector2(repeat_width, 0)
	
	print("🎨 Capa configurada - Tamaño: " + str(texture_size) + " | Escala: " + str(scale_factor) + " | Repetición: " + str(repeat_width))

func crear_capa_debug(sprite: Sprite2D, layer: ParallaxLayer, nombre: String):
	"""Crear una capa de color sólido para debug si no se carga la textura"""
	var screen_size = get_viewport().get_visible_rect().size
	
	# Crear imagen de debug
	var debug_image = Image.create(screen_size.x, screen_size.y, false, Image.FORMAT_RGBA8)
	
	# Colores de debug según la capa
	var color_debug = Color.TRANSPARENT
	if "Cielo" in nombre:
		color_debug = Color(0.5, 0.7, 1.0, 0.3)  # Azul claro
	elif "Montañas" in nombre:
		color_debug = Color(0.6, 0.6, 0.7, 0.4)  # Gris azulado
	elif "Árboles" in nombre:
		color_debug = Color(0.2, 0.4, 0.1, 0.5)  # Verde
	else:
		color_debug = Color(0.5, 0.3, 0.2, 0.3)  # Marrón
	
	# Rellenar con color
	debug_image.fill(color_debug)
	
	# Crear textura y aplicar
	var debug_texture = ImageTexture.new()
	debug_texture.set_image(debug_image)
	sprite.texture = debug_texture
	sprite.position = Vector2(screen_size.x / 2, screen_size.y / 2)
	
	print("🔧 Capa DEBUG creada: " + nombre)

func set_cat_color_natural():
	"""Establece el gato con color natural para mostrar la imagen real"""
	if player:
		player.set_cat_color(Color.WHITE)  # Blanco para mostrar colores naturales
		print("🐾 ¡Gato con imagen real listo para saltar!")

func crear_plataformas_iniciales():
	"""Crea las plataformas básicas que combinan con el fondo de bosque"""
	if not platforms_container:
		return
	
	# TEMPORALMENTE DESHABILITADO - Crear suelo principal más arriba para que el gato sea visible
	# var suelo = crear_plataforma(Vector2(512, 600), Vector2(1024, 100), Color(0.3, 0.2, 0.1, 1.0))
	# platforms_container.add_child(suelo)
	
	# Crear suelo invisible para physics pero que no interfiera visualmente
	var suelo = crear_plataforma(Vector2(512, 600), Vector2(1024, 50), Color(1.0, 1.0, 1.0, 0.0))  # Transparente
	platforms_container.add_child(suelo)
	
	# TEMPORALMENTE DESHABILITADAS - plataformas flotantes
	# var plat1 = crear_plataforma(Vector2(200, 500), Vector2(150, 20), Color(0.2, 0.4, 0.1, 1.0))  # Verde musgo
	# platforms_container.add_child(plat1)
	
	# var plat2 = crear_plataforma(Vector2(500, 400), Vector2(150, 20), Color(0.4, 0.3, 0.2, 1.0))  # Marrón tronco
	# platforms_container.add_child(plat2)
	
	# var plat3 = crear_plataforma(Vector2(800, 300), Vector2(150, 20), Color(0.15, 0.3, 0.08, 1.0))  # Verde hoja oscuro
	# platforms_container.add_child(plat3)

func crear_plataforma(posicion: Vector2, tamaño: Vector2, color: Color) -> StaticBody2D:
	"""Crea una plataforma física con estilo pixel art"""
	var plataforma = StaticBody2D.new()
	plataforma.position = posicion
	
	# Crear sprite visual con borde pixel art
	var sprite = ColorRect.new()
	sprite.size = tamaño
	sprite.color = color
	sprite.position = -tamaño / 2
	
	# Añadir borde para estilo pixel art
	var border = ColorRect.new()
	border.size = tamaño + Vector2(4, 4)  # Borde de 2 píxeles
	border.color = Color(0.2, 0.2, 0.2, 1.0)  # Borde oscuro
	border.position = -tamaño / 2 - Vector2(2, 2)
	plataforma.add_child(border)
	plataforma.add_child(sprite)  # Sprite encima del borde
	
	# Crear colisión
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = tamaño
	collision.shape = shape
	plataforma.add_child(collision)
	
	return plataforma

func start_game():
	"""Arranca el juego de plataformas"""
	game_active = true
	print("¡El juego arrancó! ¡Salta y recoge comida mientras evitas obstáculos!")

func _process(delta):
	if not game_active:
		return
	
	game_time += delta
	
	# Actualizar parallax scrolling basado en el movimiento del jugador
	if game_background and player:
		# El fondo se mueve sutilmente con el jugador para efecto de profundidad
		var parallax_offset = -player.velocity * delta * 0.5  # Más controlado
		game_background.scroll_offset += parallax_offset
	
	# TEMPORALMENTE DESHABILITADO - Spawns de obstáculos
	# obstacle_timer += delta
	# if obstacle_timer >= obstacle_spawn_rate:
	#	spawn_random_obstacle()
	#	obstacle_timer = 0.0
	
	# TEMPORALMENTE DESHABILITADO - Spawns de coleccionables
	# collectible_timer += delta  
	# if collectible_timer >= collectible_spawn_rate:
	#	spawn_random_collectible()
	#	collectible_timer = 0.0

func spawn_random_obstacle():
	"""Genera un obstáculo aleatorio"""
	if not obstacles_container:
		return
	
	var obstacle_types = ["raton", "charco", "caja", "escoba"]
	var type = obstacle_types[randi() % obstacle_types.size()]
	
	var obstacle = crear_obstaculo(type)
	obstacles_container.add_child(obstacle)

func spawn_random_collectible():
	"""Genera un coleccionable aleatorio"""
	if not collectibles_container:
		return
	
	var food_types = ["pollo", "pescado", "leche", "pelotita"]
	var type = food_types[randi() % food_types.size()]
	
	var collectible = crear_coleccionable(type)
	collectibles_container.add_child(collectible)

func crear_obstaculo(tipo: String) -> RigidBody2D:
	"""Crea un obstáculo hermoso que se mueve de derecha a izquierda"""
	var obstacle = RigidBody2D.new()
	obstacle.position = Vector2(1100, randf_range(500, 650))
	obstacle.gravity_scale = 0
	obstacle.set_meta("type", tipo)
	obstacle.set_meta("is_obstacle", true)
	
	# Crear sprite con forma específica
	var sprite = Sprite2D.new()
	var image = crear_imagen_obstaculo(tipo)
	var texture = ImageTexture.new()
	texture.set_image(image)
	sprite.texture = texture
	obstacle.add_child(sprite)
	
	# Crear colisión apropiada
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(40, 40)
	collision.shape = shape
	obstacle.add_child(collision)
	
	# Añadir área para detectar colisión
	var area = Area2D.new()
	var area_collision = CollisionShape2D.new()
	var area_shape = RectangleShape2D.new()
	area_shape.size = Vector2(40, 40)
	area_collision.shape = area_shape
	area.add_child(area_collision)
	obstacle.add_child(area)
	
	area.body_entered.connect(_on_obstacle_body_entered.bind(obstacle))
	obstacle.linear_velocity = Vector2(-200 * game_speed, 0)
	
	return obstacle

func crear_imagen_obstaculo(tipo: String) -> Image:
	"""Crea imágenes específicas para cada tipo de obstáculo"""
	var image = Image.create(40, 40, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	match tipo:
		"raton":
			# Dibujar un ratón gris
			# Cuerpo ovalado
			for y in range(15, 30):
				for x in range(5, 25):
					var dx = float(x - 15)
					var dy = float(y - 22)
					if (dx * dx / 100.0 + dy * dy / 49.0) <= 1:
						image.set_pixel(x, y, Color.GRAY)
			
			# Cabeza redonda
			for y in range(12, 22):
				for x in range(8, 18):
					var dx = float(x - 13)
					var dy = float(y - 17)
					if (dx * dx + dy * dy) <= 25:
						image.set_pixel(x, y, Color.GRAY)
			
			# Orejas redondas
			for y in range(10, 15):
				for x in range(10, 13):
					var dx = x - 11.5
					var dy = y - 12
					if (dx * dx + dy * dy) <= 4:
						image.set_pixel(x, y, Color.GRAY)
			for y in range(10, 15):
				for x in range(14, 17):
					var dx = x - 15.5
					var dy = y - 12
					if (dx * dx + dy * dy) <= 4:
						image.set_pixel(x, y, Color.GRAY)
			
			# Ojos negros
			image.set_pixel(11, 16, Color.BLACK)
			image.set_pixel(15, 16, Color.BLACK)
			
			# Cola larga
			for x in range(25, 35):
				var y = 22 + int((x - 25) * 0.3)
				if y < 40: image.set_pixel(x, y, Color.GRAY)
		
		"charco":
			# Dibujar charco de agua azul
			for y in range(25, 35):
				for x in range(5, 35):
					var dx = float(x - 20)
					var dy = float(y - 30)
					var noise = sin(dx * 0.2) * cos(dy * 0.2)
					if (dx * dx / 225.0 + dy * dy / 25.0 + noise * 0.1) <= 1:
						image.set_pixel(x, y, Color.CYAN)
						# Añadir brillos
						if randf() < 0.3:
							image.set_pixel(x, y, Color.LIGHT_CYAN)
		
		"caja":
			# Dibujar caja marrón con detalles
			# Caja principal
			for y in range(10, 30):
				for x in range(10, 30):
					image.set_pixel(x, y, Color.SADDLE_BROWN)
			
			# Líneas de la caja
			for x in range(10, 30):
				image.set_pixel(x, 10, Color.BLACK)  # Línea superior
				image.set_pixel(x, 29, Color.BLACK)  # Línea inferior
				image.set_pixel(x, 19, Color.BLACK)  # Línea media
			for y in range(10, 30):
				image.set_pixel(10, y, Color.BLACK)  # Línea izquierda
				image.set_pixel(29, y, Color.BLACK)  # Línea derecha
				image.set_pixel(19, y, Color.BLACK)  # Línea media
		
		"escoba":
			# Dibujar escoba vertical
			# Mango marrón
			for y in range(5, 35):
				for x in range(18, 22):
					image.set_pixel(x, y, Color.SADDLE_BROWN)
			
			# Cerdas amarillas
			for y in range(30, 38):
				for x in range(12, 28):
					var distance_from_center = abs(x - 20)
					if distance_from_center <= (38 - y) / 2:
						image.set_pixel(x, y, Color.YELLOW)
	
	return image

func crear_coleccionable(tipo: String) -> RigidBody2D:
	"""Crea un coleccionable que se mueve de derecha a izquierda"""
	var collectible = RigidBody2D.new()
	collectible.position = Vector2(1100, randf_range(400, 600))
	collectible.gravity_scale = 0
	collectible.set_meta("type", tipo)
	collectible.set_meta("is_collectible", true)
	
	# Crear visual
	var sprite = ColorRect.new()
	sprite.size = Vector2(30, 30)
	sprite.position = Vector2(-15, -15)
	
	match tipo:
		"pollo":
			sprite.color = Color.ORANGE_RED
		"pescado":
			sprite.color = Color.CYAN
		"leche":
			sprite.color = Color.WHITE
		"pelotita":
			sprite.color = Color.PINK
	
	collectible.add_child(sprite)
	
	# Crear área para detectar colisión con jugador
	var area = Area2D.new()
	var area_collision = CollisionShape2D.new()
	var area_shape = RectangleShape2D.new()
	area_shape.size = Vector2(30, 30)
	area_collision.shape = area_shape
	area.add_child(area_collision)
	collectible.add_child(area)
	
	# Conectar señal de colisión
	area.body_entered.connect(_on_collectible_body_entered.bind(collectible))
	
	# Aplicar velocidad hacia la izquierda
	collectible.linear_velocity = Vector2(-150 * game_speed, 0)
	
	return collectible

func _on_obstacle_body_entered(body, obstacle):
	"""Se llama cuando el gato toca un obstáculo"""
	if body == player:
		var tipo = obstacle.get_meta("type", "desconocido")
		player.colisionar_con_obstaculo(tipo)
		# Game over!
		trigger_game_over("¡Chocaste con: " + tipo + "!")

func _on_collectible_body_entered(body, collectible):
	"""Se llama cuando el gato recoge un coleccionable"""
	if body == player:
		var tipo = collectible.get_meta("type", "desconocido")
		var puntos = obtener_puntos_item(tipo)
		
		player.recoger_item(tipo, puntos)
		add_score(puntos)
		items_collected += 1
		
		# Remover el coleccionable
		collectible.queue_free()
		
		# Efecto visual/sonoro aquí si quieres

func obtener_puntos_item(tipo: String) -> int:
	"""Devuelve los puntos que vale cada tipo de item"""
	match tipo:
		"pollo": return 15
		"pescado": return 20
		"leche": return 10
		"pelotita": return 5
		_: return 10

func _on_item_collected(tipo: String):
	"""Maneja la señal del jugador cuando recoge un item"""
	print("¡Item " + tipo + " recolectado!")

func _on_item_collected_signal(tipo: String, puntos: int):
	"""Maneja la señal de item recolectado"""
	print("Signal: Item " + tipo + " recolectado por " + str(puntos) + " puntos")

func _on_obstacle_collision():
	"""Maneja la colisión con obstáculos"""
	trigger_game_over("¡Colisión con obstáculo!")

func trigger_game_over(mensaje: String):
	"""Activa el game over"""
	game_active = false
	game_over.emit()
	print("🎮 GAME OVER! " + mensaje)
	print("Puntuación final: " + str(score))
	print("Items recolectados: " + str(items_collected))
	print("Tiempo jugado: " + str(round(game_time)) + " segundos")

func add_score(points: int):
	"""Añade puntos a la puntuación actual y total"""
	score += points
	total_score += points
	score_changed.emit(score)
	
	# Verificar si se alcanzó el objetivo de 1000 puntos
	if score >= target_score:
		trigger_victory()

func trigger_victory():
	"""¡VICTORIA! El jugador alcanzó 1000 puntos"""
	game_active = false
	print("🏆 ¡¡¡FELICIDADES!!! 🏆")
	print("¡Has alcanzado " + str(target_score) + " puntos!")
	print("🐱 ¡Tu gato negro es un verdadero campeón travieso! 🐱")
	print("Puntuación final: " + str(score) + " puntos")
	print("Items recolectados: " + str(items_collected))
	print("Tiempo jugado: " + str(round(game_time)) + " segundos")
	print("Presiona R para jugar de nuevo")

# Función next_room eliminada - no se usa en el juego de plataformas

func _on_game_over():
	"""Maneja el fin del juego"""
	game_active = false
	print("¡GAME OVER! ¡El gato chocó con un obstáculo!")
	print("Puntuación de esta partida: " + str(score) + " puntos")
	print("Puntuación total acumulada: " + str(total_score) + " puntos")
	print("Items recolectados: " + str(items_collected))
	print("Tiempo jugado: " + str(round(game_time)) + " segundos")
	
	# Opción para reiniciar
	print("Presiona R para reiniciar el juego")

func _on_score_changed(new_score: int):
	# Actualizar UI
	if ui:
		var score_label = ui.get_node("ScoreLabel")
		var total_score_label = ui.get_node("TotalScoreLabel")
		if score_label:
			score_label.text = "Puntos: " + str(new_score)
		if total_score_label:
			total_score_label.text = "Total: " + str(total_score)
	print("Puntuación actual: " + str(new_score))

func _input(event):
	"""Maneja la entrada del jugador"""	
	# Reiniciar juego
	if event is InputEventKey and event.pressed and event.keycode == KEY_R:
		if not game_active:
			restart_game()

func restart_game():
	"""Reinicia el juego manteniendo puntos totales"""
	# Limpiar obstáculos y coleccionables existentes
	if obstacles_container:
		for child in obstacles_container.get_children():
			child.queue_free()
	if collectibles_container:
		for child in collectibles_container.get_children():
			child.queue_free()
	
	# Reiniciar variables de partida
	score = 0
	items_collected = 0
	obstacles_avoided = 0
	game_time = 0.0
	game_active = false
	obstacle_timer = 0.0
	collectible_timer = 0.0
	
	# Configurar nueva partida
	setup_game()
	start_game()
	
	print("🔄 Nueva partida iniciada. Puntos totales: " + str(total_score))

# Funciones del sistema anterior de colores/logros eliminadas
# El juego ahora se enfoca en llegar a 1000 puntos únicamente
