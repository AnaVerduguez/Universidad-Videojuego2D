# Sistema de detección de la dueña
extends Node2D
class_name OwnerDetector

var duena_esta_mirando := false
var duena_presente := false
var tiempo_mirando := 0.0
var duracion_maxima_mirar := 3.0

@export var tiempo_minimo_aparicion := 5.0
@export var tiempo_maximo_aparicion := 15.0
@export var probabilidad_aparicion := 0.1

var tiempo_proxima_aparicion := 0.0
var tiempo_desde_ultima_aparicion := 0.0
var timer_interno := 0.0

# Referencias se configurarán cuando se cree la escena
var sprite_duena: Sprite2D
var area_vision: Area2D
var advertencia_visual: Sprite2D
var audio_duena: AudioStreamPlayer2D

signal duena_empezo_a_mirar()
signal duena_dejo_de_mirar()
signal gato_pillado()

func _ready():
	programar_proxima_aparicion()
	print("OwnerDetector listo - configurar nodos en escena para funcionalidad completa")

func _process(delta):
	"""
	Actualiza el sistema de detección cada frame
	Args: delta - Tiempo transcurrido desde el último frame
	"""
	timer_interno += delta
	tiempo_desde_ultima_aparicion += delta
	
	# Verificar si es momento de que aparezca la dueña
	if not duena_presente and tiempo_desde_ultima_aparicion >= tiempo_proxima_aparicion:
		hacer_aparecer_duena()
	
	# Si la dueña está mirando, actualizar el tiempo
	if duena_esta_mirando:
		tiempo_mirando += delta
		
		# Si ha estado mirando demasiado tiempo, hacer que se vaya
		if tiempo_mirando >= duracion_maxima_mirar:
			hacer_desaparecer_duena()

func programar_proxima_aparicion():
	"""
	Calcula cuándo debe aparecer la programadora la próxima vez
	"""
	tiempo_proxima_aparicion = randf_range(tiempo_minimo_aparicion, tiempo_maximo_aparicion)
	print("⏰ Próxima aparición de la programadora en: " + str(tiempo_proxima_aparicion) + " segundos")

func hacer_aparecer_duena():
	"""
	Hace que la programadora aparezca y comience a mirar
	"""
	duena_presente = true
	duena_esta_mirando = true
	tiempo_mirando = 0.0
	tiempo_desde_ultima_aparicion = 0.0
	
	# Mostrar elementos visuales
	if sprite_duena:
		sprite_duena.visible = true
		# Animar la aparición
		animar_aparicion_duena()
	
	# Mostrar advertencia visual
	mostrar_advertencia()
	
	# Reproducir sonido de aparición
	reproducir_sonido_aparicion()
	
	# Emitir señal
	duena_empezo_a_mirar.emit()
	
	print("👀 ¡La programadora terminó la videollamada y está mirando!")

func hacer_desaparecer_duena():
	"""
	Hace que la programadora desaparezca y vuelva al trabajo
	"""
	duena_presente = false
	duena_esta_mirando = false
	tiempo_mirando = 0.0
	
	# Ocultar elementos visuales
	if sprite_duena:
		sprite_duena.visible = false
	
	# Ocultar advertencia
	ocultar_advertencia()
	
	# Reproducir sonido de desaparición
	reproducir_sonido_desaparicion()
	
	# Emitir señal
	duena_dejo_de_mirar.emit()
	
	# Programar la próxima aparición
	programar_proxima_aparicion()
	
	print("😌 La programadora volvió al trabajo. El gato puede seguir tirando equipos...")

func animar_aparicion_duena():
	"""
	Anima la aparición de la dueña con efectos visuales
	"""
	if not sprite_duena:
		return
	
	# Efecto de aparición gradual
	sprite_duena.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(sprite_duena, "modulate:a", 1.0, 0.5)
	
	# Pequeña vibración para llamar la atención
	var tween_shake = create_tween()
	tween_shake.set_loops(5)
	tween_shake.tween_property(sprite_duena, "position:x", sprite_duena.position.x + 2, 0.05)
	tween_shake.tween_property(sprite_duena, "position:x", sprite_duena.position.x - 2, 0.05)

func mostrar_advertencia():
	"""
	Muestra una advertencia visual de que la dueña está mirando
	"""
	if advertencia_visual:
		advertencia_visual.visible = true
		
		# Efecto pulsante de advertencia
		var tween = create_tween()
		tween.set_loops()
		tween.tween_property(advertencia_visual, "modulate:a", 0.3, 0.3)
		tween.tween_property(advertencia_visual, "modulate:a", 1.0, 0.3)

func ocultar_advertencia():
	"""
	Oculta la advertencia visual
	"""
	if advertencia_visual:
		advertencia_visual.visible = false

func reproducir_sonido_aparicion():
	"""
	Reproduce el sonido cuando aparece la programadora
	"""
	if audio_duena:
		print("🔊 Sonido: *silla girando, pasos desde el escritorio*")
		# En un juego completo:
		# audio_duena.stream = load("res://sounds/office_chair_move.ogg")
		# audio_duena.play()

func reproducir_sonido_desaparicion():
	"""
	Reproduce el sonido cuando la programadora vuelve al trabajo
	"""
	if audio_duena:
		print("🔊 Sonido: *tecleo, música de concentración*")
		# En un juego completo:
		# audio_duena.stream = load("res://sounds/keyboard_typing.ogg")
		# audio_duena.play()

func is_owner_watching() -> bool:
	"""
	Verifica si la dueña está mirando actualmente
	Returns: true si la dueña está mirando
	"""
	return duena_esta_mirando

func update_detection():
	"""
	Actualiza el sistema de detección (llamado desde Main.gd)
	Esta función se puede usar para lógica adicional de detección
	"""
	# Por ahora, la lógica principal está en _process()
	# Aquí se pueden agregar verificaciones adicionales
	pass

func verificar_si_gato_pillado(posicion_gato: Vector2) -> bool:
	"""
	Verifica si el gato está en el campo de visión de la dueña
	Args: posicion_gato - La posición actual del gato
	Returns: true si el gato fue pillado
	"""
	if not duena_esta_mirando:
		return false
	
	# Verificar si el gato está en el área de visión
	if area_vision:
		var gatos_en_vision = area_vision.get_overlapping_bodies()
		for cuerpo in gatos_en_vision:
			if cuerpo.has_method("detener_movimiento"):  # Es el jugador
				return true
	
	return false

func _on_jugador_en_vision(cuerpo):
	"""
	Se ejecuta cuando el jugador entra en el campo de visión de la dueña
	Args: cuerpo - El cuerpo que entró (debería ser el jugador)
	"""
	if duena_esta_mirando and cuerpo.has_method("detener_movimiento"):
		# ¡El gato fue pillado!
		print("😱 ¡LA DUEÑA PILLÓ AL GATO!")
		gato_pillado.emit()

func _on_jugador_fuera_vision(cuerpo):
	"""
	Se ejecuta cuando el jugador sale del campo de visión de la dueña
	Args: cuerpo - El cuerpo que salió
	"""
	if cuerpo.has_method("reanudar_movimiento"):
		print("🤫 El gato salió del campo de visión...")

# === FUNCIONES DE DIFICULTAD ===
func aumentar_dificultad():
	"""
	Hace que la dueña aparezca más frecuentemente (para niveles avanzados)
	"""
	tiempo_minimo_aparicion = max(3.0, tiempo_minimo_aparicion - 1.0)
	tiempo_maximo_aparicion = max(8.0, tiempo_maximo_aparicion - 2.0)
	duracion_maxima_mirar += 0.5
	
	print("📈 Dificultad aumentada: la dueña será más vigilante")

func reducir_dificultad():
	"""
	Hace que la dueña aparezca menos frecuentemente (para principiantes)
	"""
	tiempo_minimo_aparicion = min(10.0, tiempo_minimo_aparicion + 1.0)
	tiempo_maximo_aparicion = min(20.0, tiempo_maximo_aparicion + 2.0)
	duracion_maxima_mirar = max(2.0, duracion_maxima_mirar - 0.5)
	
	print("📉 Dificultad reducida: la dueña será menos vigilante")

func obtener_tiempo_hasta_proxima_aparicion() -> float:
	"""
	Calcula cuánto tiempo falta para la próxima aparición
	Returns: float con los segundos hasta la próxima aparición
	"""
	return max(0.0, tiempo_proxima_aparicion - tiempo_desde_ultima_aparicion)

func forzar_aparicion_duena():
	"""
	Fuerza que la dueña aparezca inmediatamente (útil para debugging)
	"""
	tiempo_desde_ultima_aparicion = tiempo_proxima_aparicion
	print("🔧 Aparición de dueña forzada para pruebas")
