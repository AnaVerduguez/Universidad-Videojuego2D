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
	
	set_cat_black_color()

func crear_fondo():
	"""Crea y configura el fondo del juego"""
	# Crear el fondo manualmente usando ParallaxBackground
	game_background = ParallaxBackground.new()
	add_child(game_background)
	# Mover el fondo al fondo de la jerarquía
	move_child(game_background, 0)
	
	# Configurar el parallax background
	game_background.scroll_ignore_camera_zoom = false
	
	# Crear la capa de parallax
	var background_layer = ParallaxLayer.new()
	background_layer.motion_scale = Vector2(0.5, 0.8)  # Velocidad del parallax
	game_background.add_child(background_layer)
	
	# Crear el sprite del fondo
	var background_sprite = Sprite2D.new()
	background_layer.add_child(background_sprite)
	
	# Cargar y configurar la imagen de fondo
	var texture = load("res://Game Assets/wallpaper.jpg")
	if texture:
		background_sprite.texture = texture
		configurar_fondo_escala(background_sprite, background_layer)
		print("🖼️ Fondo pixel art cargado exitosamente")
	else:
		print("❌ Error: No se pudo cargar wallpaper.jpg")
		crear_fondo_simple_fallback(background_sprite)

func configurar_fondo_escala(sprite: Sprite2D, layer: ParallaxLayer):
	"""Configura la escala y posición del fondo"""
	var screen_size = get_viewport().get_visible_rect().size
	var texture_size = sprite.texture.get_size()
	
	# Calcular escala para cubrir toda la pantalla sin deformar
	var scale_x = screen_size.x / texture_size.x
	var scale_y = screen_size.y / texture_size.y
	var scale_factor = max(scale_x, scale_y) # Usar el mayor para cubrir toda la pantalla
	
	# Aplicar escala
	sprite.scale = Vector2(scale_factor, scale_factor)
	
	# Centrar el fondo
	sprite.position = Vector2(screen_size.x / 2, screen_size.y / 2)
	
	# Configurar repetición horizontal para parallax infinito
	layer.motion_mirroring = Vector2(texture_size.x * scale_factor, 0)
	
	print("🎨 Fondo configurado - Escala: " + str(scale_factor))

func crear_fondo_simple_fallback(sprite: Sprite2D):
	"""Crear un fondo simple si falla la carga"""
	var image = Image.create(1024, 768, false, Image.FORMAT_RGBA8)
	# Crear gradiente de cielo nocturno
	for y in range(768):
		var color = Color.DARK_BLUE.lerp(Color.PURPLE, float(y) / 768.0)
		for x in range(1024):
			image.set_pixel(x, y, color)
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	sprite.texture = texture
	sprite.scale = Vector2(1, 1)
	sprite.position = Vector2(512, 384)

func set_cat_black_color():
	"""Establece el gato con color negro - único color disponible"""
	if player:
		player.set_cat_color(Color.BLACK)
		print("🐾 ¡Gato negro listo para saltar!")

func crear_plataformas_iniciales():
	"""Crea las plataformas básicas del juego que combinan con el fondo pixel"""
	if not platforms_container:
		return
	
	# Crear suelo principal - color marrón tierra que combina con el pixel art
	var suelo = crear_plataforma(Vector2(512, 700), Vector2(1024, 100), Color(0.4, 0.2, 0.1, 1.0))
	platforms_container.add_child(suelo)
	
	# Crear plataformas flotantes - colores que combinan con el estilo pixel
	var plat1 = crear_plataforma(Vector2(200, 600), Vector2(150, 20), Color(0.3, 0.6, 0.2, 1.0))  # Verde césped
	platforms_container.add_child(plat1)
	
	var plat2 = crear_plataforma(Vector2(500, 500), Vector2(150, 20), Color(0.5, 0.5, 0.5, 1.0))  # Gris piedra
	platforms_container.add_child(plat2)
	
	var plat3 = crear_plataforma(Vector2(800, 400), Vector2(150, 20), Color(0.2, 0.4, 0.1, 1.0))  # Verde oscuro
	platforms_container.add_child(plat3)

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
		var parallax_offset = -player.velocity * 0.02  # Muy sutil para no marearse
		game_background.scroll_offset += parallax_offset
	
	# Spawns de obstáculos
	obstacle_timer += delta
	if obstacle_timer >= obstacle_spawn_rate:
		spawn_random_obstacle()
		obstacle_timer = 0.0
	
	# Spawns de coleccionables
	collectible_timer += delta  
	if collectible_timer >= collectible_spawn_rate:
		spawn_random_collectible()
		collectible_timer = 0.0

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
	"""Crea un obstáculo que se mueve de derecha a izquierda"""
	var obstacle = RigidBody2D.new()
	obstacle.position = Vector2(1100, randf_range(500, 650))  # Aparece desde la derecha
	obstacle.gravity_scale = 0  # Sin gravedad para que no caiga
	obstacle.set_meta("type", tipo)
	obstacle.set_meta("is_obstacle", true)
	
	# Crear visual
	var sprite = ColorRect.new()
	sprite.size = Vector2(40, 40)
	sprite.position = Vector2(-20, -20)
	
	match tipo:
		"raton":
			sprite.color = Color.GRAY
		"charco":
			sprite.color = Color.BLUE
		"caja":
			sprite.color = Color.SADDLE_BROWN
		"escoba":
			sprite.color = Color.YELLOW
	
	obstacle.add_child(sprite)
	
	# Crear colisión
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(40, 40)
	collision.shape = shape
	obstacle.add_child(collision)
	
	# Añadir área para detectar colisión con jugador
	var area = Area2D.new()
	var area_collision = CollisionShape2D.new()
	var area_shape = RectangleShape2D.new()
	area_shape.size = Vector2(40, 40)
	area_collision.shape = area_shape
	area.add_child(area_collision)
	obstacle.add_child(area)
	
	# Conectar señal de colisión
	area.body_entered.connect(_on_obstacle_body_entered.bind(obstacle))
	
	# Aplicar velocidad hacia la izquierda
	obstacle.linear_velocity = Vector2(-200 * game_speed, 0)
	
	return obstacle

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

func next_room():
	"""Avanza a la siguiente habitación de la oficina (nivel)"""
	print("¡Has causado suficiente caos en esta parte de la oficina!")
	print("Puntuación final: " + str(score) + " puntos")
	
	# En un juego completo, aquí se cargaría la siguiente área de la oficina
	# Por ahora reiniciamos con más objetos tecnológicos
	items_thrown = 0
	max_items_per_room += 2
	
	# Limpiar objetos actuales y generar nuevos
	for child in throwable_items.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	spawn_throwable_items()
	
	print("¡Nueva área de la oficina! Ahora hay " + str(max_items_per_room) + " equipos para tirar.")

func _on_game_over():
	"""Maneja el fin del juego"""
	game_active = false
	print("¡GAME OVER! ¡La programadora te pilló tirando equipos!")
	print("Puntuación de esta partida: " + str(score) + " puntos")
	print("Puntuación total acumulada: " + str(total_score) + " puntos")
	print("Objetos tirados: " + str(items_thrown))
	
	# Mostrar progreso hacia desbloqueos
	show_unlock_progress()
	
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
	if event.is_action_pressed("throw_item"):
		if game_active:
			var mouse_pos = get_global_mouse_position()
			throw_item_at_position(mouse_pos)
		elif not game_active and score == 0:
			# Iniciar juego si no ha empezado
			start_game()
	
	# Reiniciar juego
	if event is InputEventKey and event.pressed and event.keycode == KEY_R:
		if not game_active:
			restart_game()

func restart_game():
	"""Reinicia el juego (manteniendo puntos totales y desbloqueos)"""
	# Limpiar objetos actuales
	for child in throwable_items.get_children():
		child.queue_free()
	
	# Reiniciar variables de partida (NO los puntos totales ni desbloqueos)
	score = 0
	game_active = false
	items_thrown = 0
	max_items_per_room = 10
	
	# Configurar nueva partida
	setup_game()
	start_game()
	
	print("🔄 Nueva partida iniciada. Puntos totales: " + str(total_score))

# Funciones del sistema anterior de colores/logros eliminadas
# El juego ahora se enfoca en llegar a 1000 puntos únicamente
