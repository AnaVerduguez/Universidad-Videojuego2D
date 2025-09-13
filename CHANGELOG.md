# Changelog

## [1.6.0] - 2025-09-13

### 🌲 Fondo de Bosque Profesional con Parallax Multicapa
- **NUEVO**: Integración de assets profesionales "Free Pixel Art Forest" de Eder Muniz
- **NUEVO**: Sistema de parallax con 12 capas independientes 
- **NUEVO**: Capas especiales de luces atmosféricas y partículas
- **NUEVO**: Velocidades diferenciadas: desde cielo (0.1x) hasta primer plano (1.0x)
- **NUEVO**: Resolución 928x793 por capa con escalado inteligente
- **NUEVO**: Repetición horizontal infinita con `motion_mirroring`
- **REEMPLAZADO**: Fondo generado por código por assets reales multicapa
- **ACTUALIZADO**: Plataformas con colores temáticos del bosque:
  - Tierra del bosque (marrón oscuro)
  - Verde musgo, marrón tronco, verde hoja oscuro
- **MEJORADO**: Profundidad visual y atmósfera inmersiva

### 🗂️ Gestión de Assets
- **COPIADO**: 12 capas PNG de fondo desde carpeta externa
- **AÑADIDO**: Preview completo del bosque como referencia
- **ORGANIZADO**: Estructura limpia en `Game Assets/Background layers/`

### 📝 Documentación Técnica
- **ACTUALIZADO**: README.md con descripción de fondo multicapa
- **ACTUALIZADO**: GDD con especificaciones técnicas detalladas
- **DETALLADO**: Asset list completo con todas las capas
- **MEJORADO**: Descripciones técnicas de parallax y escalado

---

## [1.5.0] - 2025-09-13

### 🎨 Visual Overhaul - Fondo Nocturno & Pantalla Victoria
- **CAMBIADO**: Reemplazado fondo de galaxia por fondo nocturno pixel art estilo 8bit
- **NUEVO**: Cielo estrellado azul oscuro con gradiente
- **NUEVO**: Césped verde texturizado con briznas individuales
- **NUEVO**: Tierra marrón con efectos de profundidad
- **NUEVO**: 200 estrellas normales + 30 estrellas brillantes en formación cruz
- **NUEVO**: Pantalla de victoria visual con cartel "GANASTE!" 
- **NUEVO**: Cartel dorado (400x200px) con texto pixel art rojo y sombra
- **NUEVO**: Efecto de parpadeo suave en el cartel de victoria
- **NUEVO**: Overlay semi-transparente en pantalla de victoria
- **MEJORADO**: Sistema de reinicio limpia pantalla de victoria correctamente

### 🗑️ Limpieza de Assets
- **ELIMINADO**: `wallpaper.jpg` - ya no se utiliza (reemplazado por fondo procedural)
- **ACTUALIZADO**: Documentación actualizada para reflejar cambios visuales

### 📝 Documentación
- **ACTUALIZADO**: README.md - sección visual con nuevos elementos
- **ACTUALIZADO**: GDD_Gato_Travieso.md - especificaciones técnicas detalladas de victoria
- **ACTUALIZADO**: Comentarios en código para reflejar nuevo estilo pixel art

### 🔧 Mejoras Técnicas
- **NUEVO**: Función `mostrar_pantalla_victoria()` - genera cartel visual
- **NUEVO**: Función `crear_cartel_ganaste()` - dibuja texto pixel art "GANASTE!"
- **NUEVO**: Función `limpiar_pantalla_victoria()` - limpia elementos de UI
- **MEJORADO**: `restart_game()` ahora limpia correctamente la pantalla de victoria
- **OPTIMIZADO**: Generación de fondo más eficiente por capas

---

## Versiones Anteriores

### [1.4.0] - 2025-09-13
- Arreglado display de `cat.jpg` - imagen real del gato ahora visible
- Configurado texture filtering para JPGs
- Debug prints para troubleshooting de assets

### [1.3.0] - 2025-09-13  
- Cambio de control de salto: W → Barra Espaciadora
- Simplificación: solo gato negro, objetivo 1000 puntos
- Eliminación de sistema de compras/colores

### [1.2.0] - 2025-09-13
- Integración de `cat.jpg` como sprite del gato
- Reemplazo de sprites generados por imagen real

### [1.1.0] - 2025-09-13
- Renombrado carpeta "Art Assets" → "Game Assets" 
- Limpieza de assets innecesarios
- Actualización de documentación del proyecto

### [1.0.0] - 2025-09-13
- Conversión completa: juego office → plataformas 2D
- Implementación de física de salto y gravedad
- Sistema de spawning de obstáculos y coleccionables
- Mecánicas de puntuación y victoria
- Creación de documentación completa (README, GDD)
