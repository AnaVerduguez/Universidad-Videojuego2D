# 📋 CHANGELOG - Gato Travieso

Registro de cambios y actualizaciones del videojuego.

---

## 🧹 [Versión 2.1.4] - 2025-01-13
### 🗑️ **Limpieza Masiva del Proyecto**

### ✨ **Archivos Eliminados**
- **❌ Scripts Obsoletos**: Removidos de la versión espacial anterior
  - `OwnerDetector.gd` + `.uid` - Sistema de detección de dueña
  - `SpaceBackground.gd` + `.uid` - Fondo espacial anterior  
  - `Throwable.gd` + `.uid` - Sistema de objetos lanzables
- **🗑️ Archivos Sistema**: Eliminados `.DS_Store` (macOS)
- **📄 Duplicados**: Removido `GDD_Gato_Saltarin.md` duplicado

### 📁 **Estructura Final Limpia**
```
Gato_Travieso/
├── 📋 Documentación
│   ├── README.md
│   ├── CHANGELOG.md  
│   └── GDD_Gato_Travieso.md
├── ⚙️ Core del Juego
│   ├── project.godot
│   ├── main.tscn
│   ├── Main.gd + .uid
│   ├── player.tscn
│   └── Player.gd + .uid
└── 🎨 Assets
    ├── cat.jpg (gato protagonista)
    └── wallpaper.jpg (fondo pixel art)
```

### 🎯 **Beneficios de la Limpieza**
- **⚡ Proyecto más liviano**: -6 archivos innecesarios
- **📚 Documentación actualizada**: README refleja estructura real
- **🎮 Enfoque claro**: Solo archivos del juego de plataformas actual
- **🔧 Mantenimiento simplificado**: Menos archivos que gestionar

---

## 📝 [Versión 2.1.3] - 2025-01-13
### 🏷️ **Cambio de Nombre Oficial**

### ✨ **Cambios de Branding**
- **🎮 Nombre Oficial**: Cambiado de "Gato Saltarín" a "Gato Travieso"
- **📋 GDD Actualizado**: Renombrado a `GDD_Gato_Travieso.md`
- **📚 Documentación**: README y CHANGELOG actualizados
- **⚙️ Project Settings**: Configuración de Godot actualizada

### 🔧 **Cambios Técnicos**
- **📝 Scripts**: Comentarios y mensajes actualizados
- **💬 Mensajes In-Game**: "¡BIENVENIDO A GATO TRAVIESO!"
- **📄 Archivos**: Todos los documentos reflejan el nuevo nombre
- **🎯 Descripción**: "Un juego de plataformas donde eres un gato travieso que debe recolectar comida y evitar obstáculos"

### 📖 **Coherencia de Marca**
- **Identidad Visual**: Mantiene el mismo estilo y estética
- **Gameplay**: Sin cambios en mecánicas o jugabilidad
- **Personalidad**: El gato mantiene su carácter travieso y adorable

---

## 🎨 [Versión 2.1.2] - 2025-01-13
### 🖼️ **Nuevo Fondo Pixel Art con Parallax Scrolling**

### ✨ **Cambios Visuales Principales**
- **🌌 Fondo Pixel Art**: Integrado `wallpaper.jpg` como fondo del juego
- **⚡ Parallax Scrolling**: El fondo se mueve suavemente con el gato
- **🎯 Escalado Inteligente**: El fondo se adapta sin deformarse a cualquier resolución
- **🔄 Repetición Seamless**: Movimiento continuo sin cortes visuales

### 🔧 **Nuevas Funcionalidades Técnicas**
- **📝 Script Background.gd**: Nuevo sistema de manejo de fondos
- **🎮 Clase GameBackground**: Manejo profesional del parallax
- **📐 Autoescalado**: Algoritmo que preserva proporciones
- **🔗 Integración con Player**: El fondo responde al movimiento del gato

### 🎨 **Mejoras de Estilo**
- **🏗️ Plataformas Rediseñadas**: Colores que combinan con el fondo pixel art
- **🖼️ Bordes Pixel Art**: Plataformas con estilo retro auténtico
- **🌈 Paleta Coherente**: Verde césped, marrón tierra, gris piedra
- **👾 Estilo Unificado**: Todo el juego mantiene cohesión visual

### ⚙️ **Configuración Técnica**
- **🔄 Parallax Speed**: Velocidad optimizada (0.5x, 0.8y)
- **📏 Motion Scale**: Configuración automática de repetición
- **🖥️ Viewport Responsive**: Se adapta a cambios de ventana
- **🎯 Z-Index Management**: Fondo siempre en la capa correcta

---

## 🎮 [Versión 2.1.1] - 2025-01-13
### 🚀 **Mejora de Controles - Salto con Barra Espaciadora**

### ✨ **Cambios**
- **⌨️ Control de Salto Mejorado**: Cambiado de tecla W a BARRA ESPACIADORA
- **🎯 Mayor Intuición**: Control más estándar para juegos de plataformas
- **📝 Documentación Actualizada**: README y mensajes del juego actualizados

### 🔧 **Cambios Técnicos**
- **⚙️ Nueva Acción**: Creada acción "jump" en project.godot
- **❌ Acción Removida**: Eliminada dependencia de "move_up" para saltar
- **🎮 Input Mapping**: Barra espaciadora (keycode 32) asignada al salto

### 📚 **Controles Actualizados**
- **A/D**: Mover izquierda/derecha
- **ESPACIO**: Saltar ⭐ (NUEVO)
- **R**: Reiniciar juego

---

## 🎯 [Versión 2.1.0] - 2025-01-13
### ⚡ **Simplificación Total del Juego**

### ✨ **Cambios Principales**
- **🐱 Gato Único**: Solo gato negro - eliminado sistema de colores
- **🎯 Objetivo Claro**: ¡Llegar a 1000 puntos para GANAR!
- **❌ Sin Compras**: Eliminado completamente sistema de desbloqueos y tienda
- **🏆 Victoria Definitiva**: El juego termina al alcanzar 1000 puntos

### 🔥 **Características Eliminadas**
- ❌ Sistema de colores de gato (5 colores → 1 color)
- ❌ Desbloqueos con puntos
- ❌ Sistema de logros y achievements
- ❌ Compra de colores
- ❌ Puntuación "infinita"

### ⚡ **Nuevas Mecánicas**
- **🎯 Meta de 1000 Puntos**: Victoria clara y alcanzable
- **🐾 Gato Negro Único**: Personaje fijo, sin personalizaciones
- **🏆 Pantalla de Victoria**: Celebración especial al ganar
- **📊 Estadísticas de Victoria**: Tiempo y items al completar el objetivo

### 🎮 **Experiencia de Juego**
- **Más Enfocado**: Un solo objetivo claro
- **Menos Distracción**: Sin menús de colores o tiendas  
- **Más Desafío**: Sobrevivir hasta 1000 puntos requiere habilidad
- **Victoria Satisfactoria**: Sensación de logro al completar el juego

---

## 🎨 [Versión 2.0.1] - 2025-01-13
### 🐱 **Actualización de Sprite del Gato**

### ✨ **Cambios**
- **🖼️ Nueva Imagen del Gato**: Cambiado de `BakingMewmories_CatWithMouse.png` a `cat.jpg`
- **📐 Ajuste de Escala**: Optimizado tamaño del sprite para mejor visualización (0.2x)
- **🧹 Assets Actualizados**: Removida imagen PNG anterior, conservando solo la JPG

### 🔧 **Mejoras Técnicas**
- **📱 Soporte JPG**: Mejorado soporte para formatos de imagen JPG
- **⚡ Carga Optimizada**: Mensaje de confirmación específico para JPG
- **📝 Documentación**: Actualizado CHANGELOG con referencias correctas

---

## 🎮 [Versión 2.0.0] - 2025-01-13
### 🚀 **¡NUEVA MODALIDAD: GATO SALTARÍN - JUEGO DE PLATAFORMAS!**

### ✨ **Nuevas Características Principales**
- **🔄 Transformación Completa**: Cambio total de mecánicas de juego espacial a plataformas 2D
- **🐱 Nuevo Protagonista**: Gato saltarín con textura real usando `cat.jpg`
- **⚡ Sistema de Física**: Implementada gravedad, salto y movimiento de plataformas
- **🎯 Nuevos Objetivos**: Evitar obstáculos y recolectar comida para ganar puntos

### 🎮 **Sistema de Juego**
#### **Controles Renovados**
- **A/D**: Movimiento horizontal (izquierda/derecha)  
- **W**: Salto (solo en el suelo)
- **❌ Eliminados**: Vuelo espacial y lanzamiento de objetos

#### **🚧 Obstáculos (Game Over al contacto)**
- **🐭 Ratón**: Obstáculo gris que se desplaza
- **💧 Charco de Agua**: Obstáculo azul peligroso  
- **📦 Caja**: Obstáculo marrón sólido
- **🧹 Escoba**: Obstáculo amarillo en movimiento

#### **🍽️ Sistema de Coleccionables**
- **🍗 Pollo**: +15 puntos (color naranja-rojo)
- **🐟 Pescado**: +20 puntos (color cian) - ¡El más valioso!
- **🥛 Leche**: +10 puntos (color blanco)
- **⚽ Pelotita**: +5 puntos (color rosa)

### 🏗️ **Nuevas Mecánicas Técnicas**
- **📐 Plataformas Físicas**: Suelo principal + 3 plataformas flotantes
- **⏰ Sistema de Spawn Automático**: 
  - Obstáculos cada 2.0 segundos
  - Coleccionables cada 1.5 segundos
- **📊 Estadísticas Mejoradas**:
  - Items recolectados
  - Obstáculos evitados  
  - Tiempo de juego
- **🎨 Colores de Gato Actualizados**: Gato blanco por defecto

### 🗂️ **Organización de Assets**
- **📁 Carpeta Renombrada**: `"Art Assets"` → `"Game Assets"`
- **🧹 Limpieza Masiva**: Eliminadas 23 imágenes no utilizadas
- **✅ Assets Conservados**: Solo `cat.jpg`

### ⚠️ **Características Removidas**
- ❌ Sistema de vuelo espacial
- ❌ Lanzamiento de objetos
- ❌ OwnerDetector (detección de dueña)
- ❌ SpaceBackground (fondo espacial)
- ❌ Movimiento libre en todas las direcciones

### 🔧 **Mejoras Técnicas**
- **📱 Detección de Colisiones**: Sistema Area2D para obstáculos y coleccionables
- **⚡ Optimización de Rendimiento**: Eliminación automática de objetos fuera de pantalla
- **🎮 Game Over Mejorado**: Mensajes específicos según tipo de colisión
- **📈 Progresión Dinámica**: Velocidad del juego escalable

---

## 📜 [Versión 1.0.0] - Versión Anterior
### **Gato Travieso Espacial** (Version Original)
- 🌌 Juego de vuelo espacial libre
- 🎯 Mecánica de lanzar objetos de oficina  
- 👩‍💻 Sistema de detección de programadora dueña
- 🎨 5 colores de gato desbloqueables
- 📊 Sistema de puntuación básico
- ⭐ Múltiples objetos tecnológicos para tirar

---

## 📊 **Estadísticas de Desarrollo v2.0.0**
- **📝 Líneas de Código Modificadas**: ~300+
- **⏱️ Tiempo de Desarrollo**: 1 sesión intensiva
- **🎯 Enfoque**: Experiencia de plataformas clásica
- **🐱 Protagonista**: Gato con textura artística real
- **🎮 Género**: Plataformas 2D → Runner Infinito

---

## 🚀 **Próximas Funcionalidades Planeadas** 
- 🎵 Sistema de audio y efectos de sonido
- 🏆 Logros y puntuaciones máximas persistentes
- 🎨 Más texturas para obstáculos y coleccionables
- ⚡ Power-ups temporales para el gato
- 📱 Sistema de niveles progresivos

---

**🐾 ¡Disfruta del nuevo Gato Travieso!** 🐾
