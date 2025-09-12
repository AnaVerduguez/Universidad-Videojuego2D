# 🐱 Gato Travieso - Juego de Plataformas 2D

Un emocionante juego de plataformas con **hermoso fondo pixel art** donde controlás un adorable gato que debe saltar, correr y recolectar comida mientras evita obstáculos peligrosos. ¡Una aventura llena de acción gatuna con estilo retro!

## 🎮 Descripción del Juego

En "Gato Travieso" controlás un adorable **gato negro** en un desafiante mundo de plataformas 2D. El objetivo es simple pero desafiante:
- **🎯 LLEGAR A 1000 PUNTOS para ganar** - ¡Ese es tu único objetivo!
- **Saltar y esquivar obstáculos** para mantenerte con vida.
- **Recolectar comida** (pollo, pescado, leche, pelotas) para sumar puntos.
- **Sobrevivir hasta conseguir 1000 puntos** - Un solo golpe te elimina.

## ✨ Características

### 🐾 Jugabilidad de Plataformas
- **Movimiento de plataformas** con controles A/D y ESPACIO para saltar.
- **Sistema de gravedad** - el gato cae y puede saltar solo en el suelo.
- **Obstáculos peligrosos** - ¡evitarlos o será Game Over!
- **Coleccionables de comida** con diferentes valores de puntuación:
  - 🍗 **Pollo** (15 pts) - Comida nutritiva para gatos.
  - 🐟 **Pescado** (20 pts) - ¡El favorito de los gatos! Mayor puntuación.
  - 🥛 **Leche** (10 pts) - Bebida clásica para gatos.
  - ⚽ **Pelotita** (5 pts) - Juguete divertido, puntuación baja.

### 🚧 Obstáculos Peligrosos  
- 🐭 **Ratón** - ¡Ironía felina! Este ratón es peligroso.
- 💧 **Charco de Agua** - Los gatos odian mojarse.
- 📦 **Caja** - Obstáculos sólidos en el camino.
- 🧹 **Escoba** - Herramientas de limpieza amenazantes.

### 🏆 Objetivo del Juego
- **🐱 Gato único**: Solo hay un adorable **gato negro** - sin colores desbloqueables
- **🎯 Meta clara**: **¡Llegar a 1000 puntos para GANAR!**
- **❌ Sin compras**: No hay sistema de tienda ni desbloqueos
- **⚡ Pura habilidad**: Solo tú, el gato y el desafío de sobrevivir

### ⚡ Mecánicas de Juego Simplificadas
- **Sistema de puntuación** directo - cada item suma puntos hacia los 1000.
- **Spawn automático** - obstáculos y comida aparecen constantemente.
- **Física realista** - gravedad, salto y colisiones precisas.
- **Game Over inmediato** - una colisión reinicia tu progreso a 0.
- **Victoria a los 1000** - ¡El juego termina cuando alcanzas la meta!
- **Estadísticas de victoria** - tiempo total y items recolectados.

### 🎨 Estilo Visual Pixel Art
- **🌌 Fondo Dinámico**: Hermoso paisaje pixel art nocturno que se mueve con parallax
- **🎯 Sin Deformación**: El fondo se escala inteligentemente sin distorsión
- **🏗️ Plataformas Retro**: Diseño pixel con bordes y colores coherentes
- **👾 Estética Unificada**: Todo mantiene el estilo pixel art nostálgico

## 🕹️ Controles

| Acción | Tecla/Control |
|--------|---------------|
| Mover Izquierda | `A` o `Flecha Izquierda` |
| Mover Derecha | `D` o `Flecha Derecha` |
| Saltar | `ESPACIO` |
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
├── main.tscn             # Escena principal del juego
├── player.tscn           # Escena del jugador
├── Game Assets/          # Assets del juego (imágenes)
│   ├── cat.jpg           # Sprite del gato
│   └── wallpaper.jpg     # Fondo pixel art
├── README.md             # Este archivo
├── CHANGELOG.md          # Registro de cambios
└── GDD_Gato_Travieso.md  # Game Design Document
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
