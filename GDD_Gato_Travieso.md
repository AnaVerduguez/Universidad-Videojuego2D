# 📋 GAME DESIGN DOCUMENT
## 🐱 Gato Travieso - Juego de Plataformas 2D

**Versión:** 2.1.2  
**Fecha:** 13 de Enero, 2025  
**Desarrollador:** Ana Verdúguez  
**Institución:** UMET - Universidad Metropolitana  
**Motor:** Godot Engine 4.4  

---

## 📖 TABLA DE CONTENIDOS

1. [Resumen Ejecutivo](#1-resumen-ejecutivo)
2. [Concepto del Juego](#2-concepto-del-juego)
3. [Mecánicas de Gameplay](#3-mecánicas-de-gameplay)
4. [Controles del Jugador](#4-controles-del-jugador)
5. [Arte y Estética Visual](#5-arte-y-estética-visual)
6. [Sistemas de Audio](#6-sistemas-de-audio)
7. [Interfaz de Usuario](#7-interfaz-de-usuario)
8. [Arquitectura Técnica](#8-arquitectura-técnica)
9. [Progresión y Balanceado](#9-progresión-y-balanceado)
10. [Análisis de Competencia](#10-análisis-de-competencia)
11. [Cronograma de Desarrollo](#11-cronograma-de-desarrollo)
12. [Post-Launch y Expansiones](#12-post-launch-y-expansiones)

---

## 1. RESUMEN EJECUTIVO

### 1.1 Visión del Juego
**"Gato Travieso"** es un juego de plataformas 2D estilo runner infinito con hermoso fondo de bosque pixel art multicapa. El jugador controla un adorable gato negro que debe sobrevivir esquivando obstáculos y recolectando comida en un místico bosque con parallax professional para alcanzar exactamente 1000 puntos y ganar el juego.

### 1.2 Público Objetivo
- **Primario:** Jugadores casuales de 8-35 años
- **Secundario:** Fanáticos de juegos retro y pixel art
- **Terciario:** Estudiantes y educadores en desarrollo de videojuegos

### 1.3 Plataformas
- **Principal:** PC (Windows, macOS, Linux)
- **Futuro:** Potencial para móviles y web

### 1.4 Puntos Clave de Venta
- ✨ **Simplicidad elegante:** Un objetivo claro - llegar a 1000 puntos
- 🎨 **Arte pixel hermoso:** Fondo nocturno con parallax scrolling
- 🐱 **Personaje carismático:** Gato negro adorable y expresivo
- ⚡ **Jugabilidad addictiva:** Fácil de aprender, difícil de dominar
- 🎯 **Sin distracciones:** Sin micropagos, sin DLC, puro gameplay

---

## 2. CONCEPTO DEL JUEGO

### 2.1 Género
- **Primario:** Plataformas 2D
- **Secundario:** Runner Infinito
- **Terciario:** Arcade

### 2.2 Historia y Setting
En un mundo pixel art nocturno, nuestro protagonista es un **gato negro** aventurero que ha descubierto un reino lleno de comida deliciosa pero también peligros inesperados. Su misión es simple pero desafiante: **recolectar exactamente 1000 puntos de comida** para convertirse en el gato más próspero del reino.

### 2.3 Temática
- **Tema Principal:** Supervivencia y recolección
- **Sub-temas:** Perseverancia, precisión, timing
- **Tono:** Alegre, nostálgico, ligeramente desafiante

### 2.4 Filosofía de Diseño
1. **"Un objetivo, múltiples intentos"** - Meta clara pero difícil
2. **"Simplicidad visual, complejidad táctica"** - Controles simples, decisiones complejas
3. **"Respeto por el tiempo del jugador"** - Partidas cortas pero significativas

---

## 3. MECÁNICAS DE GAMEPLAY

### 3.1 Mecánica Principal: Supervivencia por Puntos
- **Objetivo:** Alcanzar exactamente **1000 puntos** para ganar
- **Condición de Victoria:** Llegar a 1000 puntos sin morir
- **Condición de Derrota:** Colisionar con cualquier obstáculo

### 3.2 Sistema de Movimiento
```
• Movimiento Horizontal: A (izquierda) / D (derecha)
• Salto: Barra Espaciadora
• Física: Gravedad realista + detección de suelo
• Velocidad: 300 píxeles/segundo horizontal
• Salto: -600 píxeles/segundo impulso inicial
• Gravedad: 2000 píxeles/segundo²
```

### 3.3 Sistema de Coleccionables
| Item | Puntos | Color Visual | Spawn Rate |
|------|--------|--------------|------------|
| 🍗 Pollo | 15 pts | Naranja-Rojo | Común |
| 🐟 Pescado | 20 pts | Cian | Menos común |
| 🥛 Leche | 10 pts | Blanco | Común |
| ⚽ Pelotita | 5 pts | Rosa | Muy común |

### 3.4 Sistema de Obstáculos
| Obstáculo | Descripción | Color | Comportamiento |
|-----------|-------------|-------|----------------|
| 🐭 Ratón | Ironía felina | Gris | Movimiento lineal |
| 💧 Charco | Los gatos odian agua | Azul | Estático en suelo |
| 📦 Caja | Obstáculo sólido | Marrón | Movimiento constante |
| 🧹 Escoba | Herramienta limpieza | Amarillo | Movimiento oscilante |

### 3.5 Sistema de Spawn
- **Obstáculos:** Cada 2.0 segundos
- **Coleccionables:** Cada 1.5 segundos
- **Posición:** Aparecen desde la derecha (X: 1100)
- **Velocidad:** -200 px/s (obstáculos), -150 px/s (coleccionables)
- **Limpieza:** Auto-eliminación al salir de pantalla

---

## 4. CONTROLES DEL JUGADOR

### 4.1 Esquema de Controles Primario
```
A / ← : Mover Izquierda
D / → : Mover Derecha  
ESPACIO : Saltar (solo en suelo)
R : Reiniciar Juego (tras Game Over)
```

### 4.2 Respuesta de Input
- **Latencia:** < 16ms (1 frame a 60fps)
- **Buffer de Salto:** 0.1 segundos antes de tocar suelo
- **Coyote Time:** 0.1 segundos tras salir del suelo

### 4.3 Accesibilidad
- **Remapeo:** Futuro - permitir personalización de teclas
- **Visuales:** Contrastes altos para daltonismo
- **Audio:** Indicadores sonoros para eventos importantes

---

## 5. ARTE Y ESTÉTICA VISUAL

### 5.1 Dirección Artística
- **Estilo:** Pixel Art 16-bit nostálgico
- **Paleta:** Tonos nocturnos con acentos cálidos
- **Resolución Base:** 1024x768 (4:3 clásico)
- **Pixel Perfect:** Escalado sin antialiasing

### 5.2 Assets Visuales

#### 5.2.1 Protagonista
- **Archivo:** `cat.jpg`
- **Escala:** 0.2x para proporción correcta
- **Color:** Negro con modulación dinámica
- **Animaciones:** Idle, caminar, saltar, caer

#### 5.2.2 Fondo de Bosque Multicapa
- **Arte:** Assets profesionales de Eder Muniz - "Free Pixel Art Forest"
- **Técnica:** Parallax Scrolling multicapa (12 capas independientes)
- **Estilo:** Bosque místico pixel art con profundidad atmosférica
- **Capas:** Desde cielo (0.1x velocidad) hasta primer plano (1.0x velocidad)
- **Efectos especiales:** 2 capas dedicadas a luces y partículas atmosféricas
- **Resolución:** 928x793 píxeles por capa, escalado inteligente
- **Repetición:** Horizontal infinita con `motion_mirroring`
- **Movimiento:** Diferencial según distancia (0.02x velocidad del jugador)

#### 5.2.3 Plataformas Temáticas del Bosque
- **Estilo:** ColorRect con bordes pixel art temáticos
- **Colores del Bosque:** 
  - Suelo: Tierra del bosque (0.3, 0.2, 0.1)
  - Plataforma 1: Verde musgo (0.2, 0.4, 0.1)
  - Plataforma 2: Marrón tronco (0.4, 0.3, 0.2)
  - Plataforma 3: Verde hoja oscuro (0.15, 0.3, 0.08)

#### 5.2.4 UI Elements
- **Fuente:** Monospace pixel-perfect
- **Colores UI:** Blanco sobre fondo semitransparente
- **Layout:** Esquina superior derecha para score

### 5.3 Efectos Visuales
- **Parallax:** Fondo se mueve a 50% velocidad horizontal, 80% vertical
- **Partículas:** Futuro - efectos al recoger items
- **Screen Shake:** Futuro - al colisionar con obstáculos

---

## 6. SISTEMAS DE AUDIO

### 6.1 Música
- **Estilo:** Chiptune nostálgico 8-bit
- **Tempo:** 120-140 BPM (energético pero no agresivo)
- **Loop:** Seamless de 2-3 minutos
- **Volumen:** Configurable en opciones

### 6.2 Efectos de Sonido
| Evento | Descripción | Duración | Pitch |
|--------|-------------|----------|-------|
| Salto | "Whoosh" suave | 0.2s | Alto |
| Recoger Item | "Ding" satisfactorio | 0.1s | Variable por tipo |
| Colisión | "Thud" dramático | 0.3s | Bajo |
| Victoria | Fanfarria celebratoria | 2.0s | Ascendente |

### 6.3 Audio Dinámico
- **Adaptativo:** Intensidad musical aumenta cerca de 1000 puntos
- **Espacial:** Panning sutil basado en posición de objetos
- **Compresión:** Normalización para no ensordeces

---

## 7. INTERFAZ DE USUARIO

### 7.1 HUD (Heads-Up Display)
```
┌─────────────────────────────────────┐
│                     Puntos: 847/1000│
│                      Items: 42      │
│                      Tiempo: 2:34   │
└─────────────────────────────────────┘
```

### 7.2 Pantallas del Juego

#### 7.2.1 Pantalla de Inicio
- Logo del juego centralizado
- Instrucciones básicas de control
- "Presiona ESPACIO para comenzar"

#### 7.2.2 Pantalla de Juego
- HUD mínimo en esquina superior derecha
- Fondo parallax ocupando toda la pantalla
- Elementos de gameplay sobre el fondo

#### 7.2.3 Pantalla de Game Over
```
🎮 GAME OVER!
¡Chocaste con: [obstáculo]!

Puntuación final: XXX puntos
Items recolectados: XX
Tiempo jugado: X:XX

Presiona R para jugar de nuevo
```

#### 7.2.4 Pantalla de Victoria
```
🏆 ¡¡¡FELICIDADES!!! 🏆
¡Has alcanzado 1000 puntos!
🐱 ¡Tu gato negro es un verdadero campeón! 🐱

Estadísticas finales:
- Items recolectados: XX
- Tiempo total: X:XX
- Eficiencia: XX%

Presiona R para jugar de nuevo
```

### 7.3 Principios de UX
- **Claridad:** Información esencial siempre visible
- **Feedback:** Respuesta inmediata a todas las acciones
- **Consistencia:** Misma tipografía y colores en todo el juego

---

## 8. ARQUITECTURA TÉCNICA

### 8.1 Motor y Herramientas
- **Motor:** Godot Engine 4.4
- **Lenguaje:** GDScript
- **Control de Versiones:** Git
- **Arte:** Software de pixel art (Aseprite recomendado)

### 8.2 Estructura de Archivos
```
Gato_Saltarin/
├── project.godot
├── Main.gd (Script principal)
├── Player.gd (Lógica del gato)
├── main.tscn (Escena principal)
├── player.tscn (Escena del jugador)
├── Game Assets/
│   ├── cat.jpg
│   └── wallpaper.jpg
├── README.md
├── CHANGELOG.md
└── GDD_Gato_Saltarin.md
```

### 8.3 Clases Principales

#### 8.3.1 Main (extends Node2D)
```gdscript
# Variables globales del juego
var score: int = 0
var target_score: int = 1000
var game_active: bool = false

# Sistemas de spawn
func spawn_random_obstacle()
func spawn_random_collectible()
func trigger_victory()
func trigger_game_over()
```

#### 8.3.2 Player (extends CharacterBody2D)
```gdscript
# Configuración de movimiento
@export var velocidad_caminar := 300.0
@export var velocidad_salto := -600.0
@export var gravedad := 2000.0

# Estados
var en_suelo: bool = false
var puede_moverse: bool = true

# Funciones principales
func _physics_process(delta)
func obtener_direccion_horizontal()
func cargar_textura_gato_real()
```

### 8.4 Sistemas de Colisión
- **Jugador:** CharacterBody2D con RectangleShape2D
- **Plataformas:** StaticBody2D con CollisionShape2D
- **Obstáculos:** RigidBody2D + Area2D para detección
- **Coleccionables:** RigidBody2D + Area2D para recolección

### 8.5 Optimización
- **Object Pooling:** Reutilización de obstáculos y coleccionables
- **Culling:** Eliminación de objetos fuera de pantalla
- **Parallax Eficiente:** Cálculos mínimos para scroll de fondo

---

## 9. PROGRESIÓN Y BALANCEADO

### 9.1 Curva de Dificultad
El juego mantiene dificultad **constante** intencionalmente:
- No hay aumento de velocidad de spawn
- No hay reducción de tamaños de plataformas  
- La dificultad proviene de la **duración necesaria** para llegar a 1000 puntos

### 9.2 Economía de Puntos
Para llegar a 1000 puntos, ejemplos de combinaciones:
- **50 Pollos** (50 × 15 = 750) + **10 Pescados** (10 × 20 = 200) + **5 Leches** (5 × 10 = 50) = 1000
- **Tiempo estimado:** 3-7 minutos dependiendo de habilidad
- **Items necesarios:** Aproximadamente 65-200 items

### 9.3 Análisis de Riesgo/Recompensa
- **Items de alto valor** (pescado) suelen aparecer en posiciones más desafiantes
- **Items de bajo valor** (pelotita) son más seguros de recolectar
- El jugador debe **balancear seguridad vs eficiencia**

---

## 10. ANÁLISIS DE COMPETENCIA

### 10.1 Juegos Similares
| Juego | Similitudes | Diferencias |
|-------|-------------|-------------|
| **Chrome Dino** | Runner infinito, salto | Nuestro tiene meta clara (1000pts) |
| **Jetpack Joyride** | Recolectar items | Menos caótico, más estratégico |
| **Super Cat Tales** | Protagonista felino | Nuestro es 2D puro, no metroidvania |
| **Flappy Bird** | Dificultad, simplicidad | Más forgiving, múltiples oportunidades |

### 10.2 Propuesta de Valor Única
- **Meta Clara:** Objetivo específico vs supervivencia infinita
- **Gato Real:** Imagen fotográfica vs sprites dibujados
- **Estética Coherente:** Todo el arte mantiene estilo pixel consistente
- **Sin Monetización:** Juego completo sin compras

---

## 11. CRONOGRAMA DE DESARROLLO

### 11.1 Fases Completadas ✅
- **[DONE] Fase 1 - Prototipo Core** (Semana 1)
  - Movimiento básico del gato
  - Sistema de plataformas
  - Spawn de obstáculos y coleccionables

- **[DONE] Fase 2 - Sistemas de Juego** (Semana 1)
  - Sistema de puntuación
  - Condiciones de victoria/derrota
  - Game loop completo

- **[DONE] Fase 3 - Arte e Integración** (Semana 1)
  - Integración de assets (cat.jpg) y fondo procedural
  - Parallax scrolling background
  - UI básica funcional

### 11.2 Fases Futuras 🔄
- **Fase 4 - Polish y Audio** (Semana 2)
  - Sistema de audio completo
  - Efectos visuales adicionales
  - Menú de opciones

- **Fase 5 - Testing y Balanceado** (Semana 3)
  - Playtesting con usuarios
  - Ajuste de dificultad
  - Optimización de rendimiento

- **Fase 6 - Release** (Semana 4)
  - Build final
  - Documentación completa
  - Preparación para distribución

---

## 12. POST-LAUNCH Y EXPANSIONES

### 12.1 Updates Planeados
- **v2.2.0 - Audio Update**
  - Música chiptune original
  - Efectos de sonido completos
  - Configuración de volumen

- **v2.3.0 - Visual Polish**
  - Animaciones del gato
  - Partículas al recoger items
  - Mejores efectos visuales

### 12.2 Posibles Expansiones
- **Modo Tiempo:** Llegar a 1000 puntos en tiempo límite
- **Modo Survival:** Cuántos puntos antes de morir
- **Nuevos Gatos:** Diferentes razas con habilidades únicas
- **Nuevos Biomas:** Diferentes fondos y obstáculos temáticos

### 12.3 Métricas de Éxito
- **Retención:** % de jugadores que completan el juego
- **Tiempo promedio:** Duración típica para llegar a 1000 puntos
- **Puntuación media:** Puntos típicos antes de Game Over
- **Tasa de reintento:** Cuántas veces los jugadores reinician

---

## 📊 APÉNDICES

### A. Especificaciones Técnicas Mínimas
- **OS:** Windows 10, macOS 10.12, Ubuntu 16.04
- **RAM:** 2 GB
- **Almacenamiento:** 100 MB
- **GPU:** Cualquier GPU moderna (integrada compatible)

### B. Asset List Completo
**Sprites:**
- `cat.jpg` - Sprite principal del protagonista

**Fondo Multicapa (Free Pixel Art Forest - Eder Muniz):**
- `Background layers/Layer_0000_9.png` - Primer plano
- `Background layers/Layer_0001_8.png` - Elementos cercanos  
- `Background layers/Layer_0002_7.png` - Follaje primer plano
- `Background layers/Layer_0003_6.png` - Árboles cercanos
- `Background layers/Layer_0004_Lights.png` - Partículas de luz
- `Background layers/Layer_0005_5.png` - Vegetación densa
- `Background layers/Layer_0006_4.png` - Árboles medios
- `Background layers/Layer_0007_Lights.png` - Luces atmosféricas
- `Background layers/Layer_0008_3.png` - Bosque medio
- `Background layers/Layer_0009_2.png` - Árboles fondo
- `Background layers/Layer_0010_1.png` - Montañas lejanas
- `Background layers/Layer_0011_0.png` - Cielo
- `Background.png` - Preview completo

**Código:**
- `project.godot` - Configuración del proyecto
- Scripts: `Main.gd`, `Player.gd`
- Escenas: `main.tscn`, `player.tscn`

### C. Controles de Calidad
- [ ] Framerate estable 60fps
- [ ] Sin memory leaks
- [ ] Responsive en todas las resoluciones soportadas
- [ ] Balanceado de dificultad validado por playtesting

---

**© 2025 Ana Verdúguez - UMET**  
**Gato Travieso v2.1.2**  
**Game Design Document**
