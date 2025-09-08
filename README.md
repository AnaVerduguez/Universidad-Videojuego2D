# 🐱 Gato Travieso - Juego 2D en Primera Persona

Un juego divertido donde controlás un gato travieso que debe tirar objetos de oficina para ganar puntos sin que lo vea su dueña programadora. Ambientado en un home office moderno.

## 🎮 Descripción del Juego

En "Gato Travieso" controlás un gato desde una perspectiva 2D en primera persona en la oficina de una programadora. Los objetivos son:
- **Tirar equipos tecnológicos** por toda la oficina para ganar puntos.
- **Evitar ser visto** por tu dueña programadora cuando está trabajando.
- **Personalizar tu gato** eligiendo entre diferentes colores.
- **Conseguir la máxima puntuación** antes de ser descubierto.

## ✨ Características

### 🐾 Jugabilidad
- **Movimiento en primera persona** con controles WASD.
- **Sistema de detección** - la dueña aparece aleatoriamente.
- **Mecánica de sigilo** - debés dejar de hacer travesuras cuando te esté mirando.
- **Diferentes objetos tecnológicos** con distintos valores de puntuación:
  - ✏️ Lapiceras (5 pts) - fáciles de tirar, hacen poco ruido.
  - 📓 Cuadernos (10 pts) - esparcen hojas por todos lados.
  - 🖱️ Mouse (15 pts) - se puede romper, valor medio.
  - 👓 Caja de anteojos (20 pts) - frágil, la necesita para trabajar.
  - 📱 Celular (25 pts) - muy valioso, se puede quebrar la pantalla.
  - ⌨️ Teclado (30 pts) - hace mucho ruido al caer, caro.
  - 🖥️ Monitor (35 pts) - muy frágil, carísimo, alto riesgo.
  - 💻 Computadora (40 pts) - la más valiosa, deja sin trabajo a su dueña.
  - 🧸 Peluche favorito (50 pts) - objeto especial, muy difícil de conseguir.

### 🎨 Sistema de Desbloqueos
- **Empezás solo con**: ⚫ **Negro** (gato sigiloso)
- **Desbloquear con puntos**:
  - 🟠 Naranja (50 pts) - gato clásico travieso.
  - ⚪ Blanco (100 pts) - angelical... aparentemente.
  - 🟤 Marrón (200 pts) - gato de oficina veterano.
    - 🩶 Gris (150 pts) - discreto en la oficina.
  - 🎯 **Objetivos Especiales** (300+ pts) 


### 🎯 Mecánicas de Juego
- **Sistema de puntuación** con bonus por rotura de objetos.
- **Sistema de desbloqueos** - colores y objetivos con puntos acumulados.
- **Detección inteligente** - la dueña aparece en momentos aleatorios.
- **Advertencias visuales** cuando la dueña está cerca.
- **Progresión de dificultad** - más objetos en habitaciones avanzadas.
- **Objetivos especiales** - logros únicos para recompensar estrategias.

## 🕹️ Controles

| Acción | Tecla/Control |
|--------|---------------|
| Mover | `WASD` o `Flechas` |
| Tirar objeto | `Clic izquierdo` o `Espacio` |
| Reiniciar juego | `R` |

## 🛠️ Instalación y Ejecución

### Requisitos
- **Motor Godot 4.2+** (descargar desde [godotengine.org](https://godotengine.org/))
- Sistema operativo: Windows, macOS, o Linux

### Pasos para ejecutar
1. **Descargar e instalar Godot**:
   ```bash
   # Ir a https://godotengine.org/download
   # Descargar la versión estable más reciente (4.2+)
   ```

2. **Clonar o descargar este repositorio**:
   ```bash
   git clone https://github.com/AnaVerduguez/Universidad-Videojuego2D.git
   cd Universidad-Videojuego2D
   ```

3. **Abrir el proyecto en Godot**:
   - Abrir Godot Engine
   - Hacer clic en "Importar"
   - Navegar hasta la carpeta del proyecto
   - Seleccionar el archivo `project.godot`
   - Hacer clic en "Importar y Editar"

4. **Ejecutar el juego**:
   - Presionar `F5` o hacer clic en el botón "Play"
   - Si es la primera vez, seleccionar `Main.tscn` como escena principal

## 📁 Estructura del Proyecto

```
Videojuego/
├── project.godot          # Configuración del proyecto Godot
├── Main.gd               # Script principal del juego
├── Player.gd             # Script del jugador (gato)
├── Throwable.gd          # Script de objetos que se pueden tirar
├── OwnerDetector.gd      # Sistema de detección de la dueña
├── README.md             # Este archivo
└── CHANGELOG.md          # Registro de cambios
```

## 🎲 Cómo Jugar

1. **Al iniciar**: Empezás con gato negro por defecto.
2. **Movimiento**: Usar WASD para moverte por la oficina.
3. **Tirar objetos**: 
   - Acercarse a los objetos que brillan.
   - Hacer clic izquierdo o presionar espacio para tirarlos.
   - Cada objeto tiene diferentes puntos.
4. **¡Cuidado con la programadora!**:
   - Aparece cuando vuelve de su descanso.
   - Si te ve tirando equipos = GAME OVER
   - Prestar atención a las advertencias visuales y sonidos de la PC.
5. **Estrategia**: Acumular puntos para desbloqueos y mantenerse alerta.
6. **Desbloqueos**: Usar puntos acumulados para conseguir nuevos colores y objetivos.

## 🏆 Objetivos Especiales y Logros

### 🎯 **Objetivos de Desbloqueo** (300+ pts)
- **📞 Interrumpir Llamadas** - Subirse a la mesa durante videollamadas.
- **📓 Tirar Cuaderno** - Esparcir un cuaderno completo sin ser visto.
- **🚪 Infiltrado Sigiloso** - Entrar a la oficina 5 veces sin ser detectado.
- **🧸 Ladrón de Peluches** - Llevarse el peluche favorito de la dueña sin que se dé cuenta.
- **🏢 Empleado del Mes** - Conseguir 500 puntos en una sola partida.

### Tecnologías
- **Engine**: Godot 4.2+
- **Lenguaje**: GDScript
- **Plataforma**: Multiplataforma (Windows, macOS, Linux)

## 📝 Licencia

Proyecto educativo - UMET
© 2025 Ana Verdúguez

---

¡Divertite siendo un gato travieso! 🐱💨
