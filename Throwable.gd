# Objetos que se pueden tirar
extends RigidBody2D
class_name Throwable

var tipo_objeto := "florero"
var puntos := 10
var fue_tirado := false
var se_puede_romper := true
var velocidad_minima_tirar := 100.0

# Referencias se configurarán cuando se cree la escena
var sprite: Sprite2D
var collision_shape: CollisionShape2D
var particulas_rotura: CPUParticles2D
var efecto_resaltado: Sprite2D
var reproductor_audio: AudioStreamPlayer2D

# Propiedades por tipo de objeto
var propiedades_objetos := {
	"lapiceras": {
		"puntos": 5,
		"se_rompe": false,
		"sonido_rotura": "pen_drop.ogg",
		"descripcion": "Lapiceras de trabajo, fáciles de tirar"
	},
	"cuadernos": {
		"puntos": 10,
		"se_rompe": false,
		"sonido_rotura": "paper_scatter.ogg",
		"descripcion": "Cuadernos con notas importantes, hojas por todos lados"
	},
	"mouse": {
		"puntos": 15,
		"se_rompe": true,
		"sonido_rotura": "plastic_crack.ogg",
		"descripcion": "Mouse inalámbrico, se puede romper fácilmente"
	},
	"caja_anteojos": {
		"puntos": 20,
		"se_rompe": true,
		"sonido_rotura": "glasses_case.ogg",
		"descripcion": "Caja de anteojos, los necesita para trabajar"
	},
	"celular": {
		"puntos": 25,
		"se_rompe": true,
		"sonido_rotura": "phone_crack.ogg",
		"descripcion": "Smartphone personal, se puede quebrar la pantalla"
	},
	"teclado": {
		"puntos": 30,
		"se_rompe": true,
		"sonido_rotura": "keyboard_crash.ogg",
		"descripcion": "Teclado mecánico, hace mucho ruido al caer"
	},
	"monitor": {
		"puntos": 35,
		"se_rompe": true,
		"sonido_rotura": "screen_shatter.ogg",
		"descripcion": "Monitor de trabajo, carísimo y muy frágil"
	},
	"computadora": {
		"puntos": 40,
		"se_rompe": true,
		"sonido_rotura": "computer_crash.ogg",
		"descripcion": "La computadora de trabajo, interrumpe todo"
	},
	"peluche": {
		"puntos": 50,
		"se_rompe": false,
		"sonido_rotura": "plush_grab.ogg",
		"descripcion": "Peluche favorito de la dueña, objeto especial muy difícil de conseguir"
	}
}

signal objeto_tirado(objeto: Throwable, puntos: int)
signal objeto_roto(objeto: Throwable)

func _ready():
	gravity_scale = 1.0
	lock_rotation = false
	print("Throwable listo - configurar nodos en escena para funcionalidad completa")

func setup(nuevo_tipo: String, posicion: Vector2):
	tipo_objeto = nuevo_tipo
	global_position = posicion
	
	if nuevo_tipo in propiedades_objetos:
		var props = propiedades_objetos[nuevo_tipo]
		puntos = props["puntos"]
		se_puede_romper = props["se_rompe"]

func can_be_thrown() -> bool:
	return not fue_tirado

func throw():
	if fue_tirado:
		return
	
	fue_tirado = true
	
	var direccion_tirar = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-0.5, 0.0)
	).normalized()
	
	var fuerza_tirar = randf_range(200.0, 400.0)
	apply_impulse(direccion_tirar * fuerza_tirar)
	
	objeto_tirado.emit(self, puntos)

func get_points() -> int:
	return puntos

func resaltar(activar: bool):
	if efecto_resaltado:
		efecto_resaltado.visible = activar
		if activar:
			var tween = create_tween()
			tween.set_loops()
			tween.tween_property(efecto_resaltado, "modulate:a", 0.3, 0.5)
			tween.tween_property(efecto_resaltado, "modulate:a", 0.7, 0.5)

func _on_body_entered(body):
	if fue_tirado and linear_velocity.length() > velocidad_minima_tirar:
		verificar_rotura()

func verificar_rotura():
	if se_puede_romper and not fue_roto():
		romper_objeto()

func fue_roto() -> bool:
	return linear_velocity.length() < 10.0

func romper_objeto():
	if particulas_rotura:
		particulas_rotura.emitting = true
	cambiar_a_sprite_roto()
	objeto_roto.emit(self)

func cambiar_a_sprite_roto():
	if sprite:
		sprite.modulate = Color(0.7, 0.7, 0.7, 0.8)

func obtener_descripcion() -> String:
	if tipo_objeto in propiedades_objetos:
		return propiedades_objetos[tipo_objeto]["descripcion"]
	return "Un objeto misterioso"

func _physics_process(_delta):
	var limite_pantalla = get_viewport().get_visible_rect()
	if global_position.y > limite_pantalla.size.y + 100:
		queue_free()
