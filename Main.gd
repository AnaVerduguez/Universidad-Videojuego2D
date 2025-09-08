# Script principal del juego "Gato Travieso"

extends Node2D
class_name Main

signal game_over
signal score_changed(new_score)

var score := 0
var total_score := 0 # Puntos persistentes
var game_active := false
var items_thrown := 0
var max_items_per_room := 10

var unlocked_colors := ["negro"]
var unlocked_achievements := []

# Referencias se configurarán cuando se creen las escenas
var player: Player
var owner_detector: OwnerDetector  
var ui
var throwable_items: Node2D

var cat_colors := {
	"negro": Color.BLACK,
	"naranja": Color.ORANGE,
	"blanco": Color.WHITE,  
	"gris": Color.GRAY,
	"marron": Color.SADDLE_BROWN
}

var color_unlock_cost := {
	"negro": 0,
	"naranja": 50,
	"blanco": 100,
	"gris": 150,
	"marron": 200
}

var selected_cat_color := "negro"

func _ready():
	game_over.connect(_on_game_over)
	score_changed.connect(_on_score_changed)
	setup_game()
	show_color_selection_menu()
	print("Juego iniciado. Configura las escenas para funcionalidad completa.")

func setup_game():
	score = 0
	game_active = false
	items_thrown = 0
	spawn_throwable_items()
	print("¡Juego listo! Usá WASD para moverte y clic izquierdo/espacio para tirar cosas.")

func show_color_selection_menu():
	print("¡Bienvenido a Gato Travieso!")
	print("Puntos totales: " + str(total_score))
	print("Colores disponibles:")
	
	for color_name in cat_colors.keys():
		if color_name in unlocked_colors:
			print("- " + color_name.capitalize() + " ✅")
		else:
			var cost = color_unlock_cost[color_name]
			print("- " + color_name.capitalize() + " (Requiere " + str(cost) + " pts)")
	
	set_cat_color("negro")

func set_cat_color(color_name: String):
	if color_name in cat_colors and color_name in unlocked_colors:
		selected_cat_color = color_name
		if player:
			player.set_cat_color(cat_colors[color_name])
		print("¡Gato " + color_name + " seleccionado!")

func start_game():
	"""Arranca el juego"""
	game_active = true
	print("¡El juego arrancó! ¡Tirá equipos de la oficina sin que te vea la programadora!")

func spawn_throwable_items():
	if not throwable_items:
		print("ThrowableItems node no configurado aún")
		return
		
	# Lista de objetos tecnológicos que un gato podría tirar en una oficina
	var item_types = ["lapiceras", "cuadernos", "mouse", "caja_anteojos", "celular", "teclado", "monitor", "computadora", "peluche"]
	
	# Generar objetos aleatoriamente por la oficina
	for i in range(max_items_per_room):
		var item = preload("res://Throwable.gd").new()
		var random_type = item_types[randi() % item_types.size()]
		var random_pos = Vector2(
			randf_range(100, get_viewport().get_visible_rect().size.x - 100),
			randf_range(100, get_viewport().get_visible_rect().size.y - 100)
		)
		
		item.setup(random_type, random_pos)
		throwable_items.add_child(item)

func throw_item_at_position(pos: Vector2):
	if not game_active:
		return
	
	if not throwable_items:
		print("Sistema de objetos no configurado")
		return
		
	# Buscar objeto más cercano (simulado por ahora)
	var closest_item = find_closest_throwable_item(pos)
	if closest_item and closest_item.can_be_thrown():
		# Verificar si la dueña nos está viendo
		if owner_detector and owner_detector.is_owner_watching():
			game_over.emit()
			return
		
		# Tirar el objeto
		closest_item.throw()
		add_score(closest_item.get_points())
		items_thrown += 1
		
		print("¡Tiraste un " + closest_item.tipo_objeto + "! +" + str(closest_item.get_points()) + " puntos")
		
		# Verificar logros específicos por objeto
		check_item_achievements(closest_item.tipo_objeto)
		
		# Verificar si se tiraron todos los objetos
		if items_thrown >= max_items_per_room:
			next_room()

func find_closest_throwable_item(pos: Vector2) -> Throwable:
	if not throwable_items:
		return null
		
	var closest_item = null
	var closest_distance = 100.0
	
	for child in throwable_items.get_children():
		if child is Throwable and child.can_be_thrown():
			var distance = pos.distance_to(child.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_item = child
	
	return closest_item

func add_score(points: int):
	"""Añade puntos a la puntuación actual y total"""
	score += points
	total_score += points
	score_changed.emit(score)
	
	# Verificar desbloqueos de colores
	check_color_unlocks()
	# Verificar logros especiales
	check_achievements()

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
	# UI se configurará cuando se cree la escena
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

func _process(_delta):
	if game_active and owner_detector:
		owner_detector.update_detection()

func check_color_unlocks():
	for color_name in color_unlock_cost.keys():
		if color_name not in unlocked_colors:
			if total_score >= color_unlock_cost[color_name]:
				unlock_color(color_name)

func unlock_color(color_name: String):
	if color_name not in unlocked_colors:
		unlocked_colors.append(color_name)
		print("🎨 ¡NUEVO COLOR! " + color_name.capitalize())

func check_achievements():
	if score >= 500 and "empleado_mes" not in unlocked_achievements:
		unlock_achievement("empleado_mes", "🏢 Empleado del Mes", "500 puntos en una partida")

func unlock_achievement(id: String, title: String, description: String):
	"""Desbloquea un logro especial"""
	if id not in unlocked_achievements:
		unlocked_achievements.append(id)
		print("🏆 ¡LOGRO DESBLOQUEADO!")
		print("   " + title)
		print("   " + description)
		print("   ¡+50 puntos bonus!")
		
		# Bonus por desbloquear logro
		total_score += 50

func show_unlocks_status():
	"""Muestra el estado de desbloqueos (útil para debugging)"""
	print("\n=== ESTADO DE DESBLOQUEOS ===")
	print("Puntos totales: " + str(total_score))
	print("Colores desbloqueados: " + str(unlocked_colors))
	print("Logros conseguidos: " + str(unlocked_achievements.size()) + "/" + "5")
	print("===============================\n")

func show_unlock_progress():
	"""Muestra progreso hacia próximos desbloqueos"""
	print("\n--- PROGRESO DE DESBLOQUEOS ---")
	
	# Mostrar próximo color a desbloquear
	for color_name in color_unlock_cost.keys():
		if color_name not in unlocked_colors:
			var cost = color_unlock_cost[color_name]
			var remaining = cost - total_score
			if remaining <= 0:
				print("🎨 " + color_name.capitalize() + " - ¡LISTO PARA DESBLOQUEAR!")
			else:
				print("🎨 " + color_name.capitalize() + " - Faltan " + str(remaining) + " pts")
			break # Solo mostrar el próximo
	
	print("---------------------------")

func check_item_achievements(item_type: String):
	"""Verifica logros específicos por tipo de objeto tirado"""
	match item_type:
		"cuadernos":
			if "tirar_cuaderno" not in unlocked_achievements:
				unlock_achievement("tirar_cuaderno", "📓 Tirar Cuaderno", "Esparciste un cuaderno completo sin ser visto")
		
		"peluche":
			if "ladron_peluches" not in unlocked_achievements:
				unlock_achievement("ladron_peluches", "🧸 Ladrón de Peluches", "Te llevaste el peluche favorito sin que se dé cuenta")
