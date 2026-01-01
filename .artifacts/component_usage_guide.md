# Estrategia de Uso: 30 Variantes de Botones y Links

---

## Norma de Navegación (RÍGIDA - SIN EXCEPCIONES)

**CRÍTICO:** Existe una regla estricta y no negociable para los atributos de navegación en componentes `.button` y `.link`:

### Regla Fundamental

- **`navigate`** → **SOLO navegación INTERNA** (dentro de la aplicación)
  - Rutas dentro de la aplicación LiveView (ej: `"/"`, `"/profile"`, `~p"/users"`)
  - Usa navegación `patch` (SIN recarga de página, socket permanece conectado)
  - Ejemplo: `<.button navigate="/">Home</.button>`
  - Ejemplo: `<.link navigate="/profile">Perfil</.link>`

- **`href`** → **SOLO navegación EXTERNA** (fuera de la aplicación)
  - URLs externas que comienzan con `http://` o `https://`
  - Usa navegación `redirect` (recarga de página, nueva conexión de socket)
  - Ejemplo: `<.button href="https://example.com">Sitio Externo</.button>`
  - Ejemplo: `<.link href="https://hexdocs.pm/phoenix">Documentación</.link>`

### ❌ PROHIBIDO

- **NO usar `href` para rutas internas** (ej: `href="/"` es INCORRECTO)
- **NO usar `navigate` para URLs externas** (ej: `navigate="https://..."` es INCORRECTO)

### Impacto Técnico

- **Usar `navigate` incorrectamente** → Puede causar errores de enrutamiento
- **Usar `href` para rutas internas** → Causa recarga completa de página y desconexión del socket LiveView (comportamiento incorrecto)

---

## 1. PRIMARY BUTTON (6 variantes)

### 1.1 Primary Button - Solo Icono

**Estado:** ⚠️ **Poco común / Uso limitado**

**Cuándo usar:**
- Acciones primarias en espacios muy reducidos (toolbars, headers compactos)
- Iconos universalmente reconocidos (ej: `+` para agregar, `✓` para confirmar)
- Interfaces móviles donde el espacio es crítico
- Acciones repetitivas en listas/tablas donde el contexto es claro

**Cuándo NO usar:**
- Acciones críticas que requieren claridad absoluta
- Primer uso de la aplicación (sin contexto previo)
- Iconos ambiguos o poco reconocibles
- Acciones destructivas o irreversibles

**Escenarios comunes:**
- Botón "Agregar" en toolbar de lista
- Botón "Guardar" en editor compacto
- Botón "Buscar" en barra de búsqueda

**Accesibilidad:**
- **OBLIGATORIO:** `aria-label` descriptivo
- Tamaño mínimo: 48×48px (touch target)
- Tooltip en hover (desktop)

**Referencias:** Material Design no recomienda icon-only para acciones primarias críticas.

---

### 1.2 Primary Button - Solo Texto

**Estado:** ✅ **Muy común / Uso estándar**

**Cuándo usar:**
- Acciones principales que requieren máxima claridad
- Formularios (Enviar, Guardar, Continuar)
- Diálogos de confirmación
- Call-to-action (CTA) principales
- Acciones críticas que no deben malinterpretarse

**Cuándo NO usar:**
- Cuando el espacio es muy limitado
- Acciones que se benefician de refuerzo visual

**Escenarios comunes:**
- "Enviar" en formularios
- "Guardar cambios" en editores
- "Continuar" en wizards
- "Comprar ahora" en e-commerce
- "Registrarse" en landing pages

**Accesibilidad:**
- Texto claro y conciso
- Verbo en infinitivo o imperativo
- Contraste WCAG AA mínimo

**Referencias:** Estándar en Material Design, Apple HIG, Bootstrap.

---

### 1.3 Primary Button - Icono + Texto

**Estado:** ✅ **Muy común / Uso recomendado**

**Cuándo usar:**
- Acciones principales que se benefician de refuerzo visual
- Mejora la comprensión rápida de la acción
- Acciones que tienen múltiples variantes (ej: "Descargar PDF" vs "Descargar Excel")
- Mejora accesibilidad para usuarios con dificultades de lectura

**Cuándo NO usar:**
- Cuando el texto es completamente autoexplicativo
- Espacios muy reducidos donde el icono resta espacio al texto

**Escenarios comunes:**
- "Descargar" + icono flecha abajo
- "Guardar" + icono disquete
- "Enviar" + icono correo
- "Compartir" + icono compartir
- "Agregar al carrito" + icono carrito

**Accesibilidad:**
- Icono complementa, no reemplaza el texto
- Icono a la izquierda del texto (LTR)
- Espaciado adecuado entre icono y texto

**Referencias:** Recomendado por Material Design para mejorar comprensión.

---

### 1.4 Primary Button - Navigate (Interno)

**Estado:** ⚠️ **Poco común / Uso específico**

**Cuándo usar:**
- Navegación interna que es la acción principal de la pantalla
- CTAs que llevan a otra sección de la app (ej: "Ver catálogo completo")
- Navegación dentro de un flujo (ej: "Siguiente paso" en wizard)
- Cuando la navegación es la acción más importante

**Cuándo NO usar:**
- Navegación secundaria (usar link normal)
- Navegación que no es la acción principal (usar secondary/ghost)
- Cuando hay otra acción más importante en la pantalla

**Escenarios comunes:**
- "Ver todos los productos" en homepage
- "Ir a configuración" como CTA principal
- "Continuar al siguiente paso" en wizard

**Accesibilidad:**
- Indicar claramente que es navegación (no acción)
- `aria-label` descriptivo si es necesario

**Referencias:** Material Design diferencia entre "button" (acción) y "link" (navegación).

---

### 1.5 Primary Button - Href (Externo)

**Estado:** ❌ **No recomendado / Uso raro**

**Cuándo usar:**
- Casi nunca - los links externos raramente son la acción principal
- Landing pages donde el CTA principal lleva a sitio externo
- Integraciones con servicios externos (ej: "Conectar con Google")

**Cuándo NO usar:**
- En la mayoría de casos - preferir link normal con estilo de botón si es necesario
- Navegación interna (usar navigate)
- Acciones que no son navegación

**Escenarios comunes:**
- "Registrarse en plataforma externa" en landing page
- "Conectar cuenta" que redirige a OAuth externo

**Accesibilidad:**
- Indicar que abre en nueva ventana/pestaña
- Icono de "external link" recomendado

**Referencias:** Apple HIG recomienda evitar botones para navegación externa.

---

### 1.6 Primary Button - Loading

**Estado:** ✅ **Muy común / Uso estándar**

**Cuándo usar:**
- Después de que el usuario activa una acción que requiere procesamiento
- Durante operaciones asíncronas (API calls, validaciones, guardado)
- Para prevenir múltiples clics en la misma acción
- Operaciones que toman > 500ms

**Cuándo NO usar:**
- Operaciones instantáneas (< 100ms)
- Operaciones que muestran feedback inmediato de otra forma

**Escenarios comunes:**
- "Enviar formulario" → muestra spinner
- "Guardar cambios" → muestra loading
- "Procesar pago" → muestra loading
- "Subir archivo" → muestra progreso

**Implementación:**
- Deshabilitar botón durante loading
- Mostrar spinner/indicador de carga
- Mantener texto visible o cambiar a "Cargando..."
- No permitir múltiples clics

**Referencias:** Estándar en todas las guías de diseño.

---

### 1.7 Primary Button - Disabled

**Estado:** ✅ **Muy común / Uso estándar**

**Cuándo usar:**
- Cuando faltan datos requeridos en formularios
- Cuando la acción no está disponible por permisos
- Cuando hay validaciones pendientes
- Estados donde la acción no tiene sentido (ej: "Eliminar" sin selección)

**Cuándo NO usar:**
- Como única forma de ocultar funcionalidad (preferir ocultar completamente)
- Sin explicar por qué está deshabilitado (usar tooltip/mensaje)

**Escenarios comunes:**
- "Enviar" deshabilitado hasta completar campos requeridos
- "Guardar" deshabilitado si no hay cambios
- "Eliminar" deshabilitado sin selección
- "Comprar" deshabilitado si producto no disponible

**Implementación:**
- Reducir opacidad (50-60%)
- Cursor `not-allowed`
- `aria-disabled="true"`
- Tooltip explicando por qué está deshabilitado (recomendado)

**Referencias:** WCAG requiere indicar claramente estado disabled.

---

## 2. SECONDARY BUTTON (6 variantes)

### 2.1 Secondary Button - Solo Icono

**Estado:** ✅ **Común / Uso apropiado**

**Cuándo usar:**
- Acciones secundarias en espacios reducidos
- Listas/tablas con acciones por fila (editar, eliminar, ver)
- Toolbars con múltiples acciones
- Iconos muy reconocibles (lápiz=editar, papelera=eliminar)

**Cuándo NO usar:**
- Acciones ambiguas o poco claras
- Sin contexto suficiente para entender el icono

**Escenarios comunes:**
- Icono lápiz para "Editar" en lista
- Icono ojo para "Ver detalles"
- Icono compartir en redes sociales
- Icono favorito (estrella/corazón)

**Accesibilidad:**
- **OBLIGATORIO:** `aria-label` descriptivo
- Tamaño mínimo: 48×48px
- Tooltip en hover

**Referencias:** Común en Material Design para acciones secundarias en listas.

---

### 2.2 Secondary Button - Solo Texto

**Estado:** ✅ **Muy común / Uso estándar**

**Cuándo usar:**
- Acciones secundarias que complementan la principal
- "Cancelar" junto a "Guardar"
- "Volver" en flujos
- "Omitir" en wizards
- Acciones alternativas que no compiten con la principal

**Cuándo NO usar:**
- Cuando la acción es más importante que la principal
- Cuando hay confusión sobre cuál es la acción principal

**Escenarios comunes:**
- "Cancelar" en formularios/diálogos
- "Volver" en wizards
- "Omitir este paso" en onboarding
- "Más tarde" en prompts

**Accesibilidad:**
- Texto claro y conciso
- Contraste adecuado (menor que primary pero suficiente)

**Referencias:** Estándar en todas las guías de diseño.

---

### 2.3 Secondary Button - Icono + Texto

**Estado:** ✅ **Común / Uso apropiado**

**Cuándo usar:**
- Acciones secundarias que se benefician de claridad adicional
- Cuando el espacio permite icono + texto
- Acciones que tienen variantes (ej: "Compartir en Facebook" vs "Compartir en Twitter")
- Mejora comprensión sin competir con primary

**Cuándo NO usar:**
- Espacios muy reducidos
- Cuando el texto es completamente claro sin icono

**Escenarios comunes:**
- "Compartir" + icono compartir
- "Exportar" + icono descarga
- "Filtrar" + icono filtro
- "Añadir al carrito" + icono carrito

**Accesibilidad:**
- Icono complementa el texto
- Mantener jerarquía visual clara (menos prominente que primary)

**Referencias:** Recomendado cuando mejora claridad.

---

### 2.4 Secondary Button - Navigate (Interno)

**Estado:** ✅ **Común / Uso apropiado**

**Cuándo usar:**
- Navegación secundaria dentro de la app
- "Ver más" en listas
- "Ir a configuración" como acción secundaria
- Navegación que no es la acción principal

**Cuándo NO usar:**
- Navegación que es la acción principal (usar primary)
- Navegación terciaria (usar ghost o link)

**Escenarios comunes:**
- "Ver todos" en secciones
- "Ir a perfil" desde dashboard
- "Ver detalles" en tarjetas

**Accesibilidad:**
- Indicar que es navegación
- Mantener estilo diferenciado de links normales

**Referencias:** Apropiado para navegación secundaria.

---

### 2.5 Secondary Button - Href (Externo)

**Estado:** ⚠️ **Poco común / Uso específico**

**Cuándo usar:**
- Links externos que son acciones secundarias importantes
- "Ver documentación" que lleva a sitio externo
- "Ayuda" que abre sitio de soporte externo
- Integraciones con servicios externos (secundarias)

**Cuándo NO usar:**
- En la mayoría de casos - preferir link normal
- Navegación interna (usar navigate)

**Escenarios comunes:**
- "Ver documentación completa" (sitio externo)
- "Soporte técnico" (sitio externo)
- "Conectar con servicio externo" (secundario)

**Accesibilidad:**
- Indicar que es externo
- Icono de "external link" recomendado

**Referencias:** Uso específico, no estándar.

---

### 2.6 Secondary Button - Loading

**Estado:** ✅ **Común / Uso apropiado**

**Cuándo usar:**
- Mismo que Primary Loading, pero para acciones secundarias
- "Exportar" que toma tiempo
- "Sincronizar" como acción secundaria
- Operaciones asíncronas en acciones secundarias

**Implementación:**
- Mismo que Primary Loading
- Mantener jerarquía visual (menos prominente que primary)

**Referencias:** Mismo estándar que Primary Loading.

---

### 2.7 Secondary Button - Disabled

**Estado:** ✅ **Muy común / Uso estándar**

**Cuándo usar:**
- Mismo que Primary Disabled, pero para acciones secundarias
- "Exportar" deshabilitado sin datos
- "Filtrar" deshabilitado sin criterios
- Acciones secundarias no disponibles

**Implementación:**
- Mismo que Primary Disabled
- Mantener jerarquía visual

**Referencias:** Mismo estándar que Primary Disabled.

---

## 3. GHOST BUTTON (6 variantes)

### 3.1 Ghost Button - Solo Icono

**Estado:** ✅ **Común / Uso apropiado**

**Cuándo usar:**
- Acciones terciarias en interfaces densas
- Toolbars con muchas opciones
- Acciones menos frecuentes pero reconocibles
- Menús de contexto (3 puntos, más opciones)

**Cuándo NO usar:**
- Acciones críticas o importantes
- Iconos ambiguos sin contexto

**Escenarios comunes:**
- Menú de opciones (3 puntos horizontales)
- Cerrar (X) en modales
- Información (i) en tooltips
- Configuración (engranaje) en headers

**Accesibilidad:**
- **OBLIGATORIO:** `aria-label` descriptivo
- Tamaño mínimo: 48×48px
- Tooltip en hover

**Referencias:** Común en Material Design para acciones terciarias.

---

### 3.2 Ghost Button - Solo Texto

**Estado:** ✅ **Muy común / Uso estándar**

**Cuándo usar:**
- Acciones terciarias o menos importantes
- "Leer más" en artículos
- "Ver detalles" en tarjetas
- Acciones que no requieren protagonismo
- Similar a links pero con comportamiento de botón

**Cuándo NO usar:**
- Acciones importantes (usar primary/secondary)
- Cuando se confunde con link normal

**Escenarios comunes:**
- "Leer más" al final de resúmenes
- "Ver detalles" en listas
- "Más información" en tooltips
- "Descartar" en formularios

**Accesibilidad:**
- Texto claro
- Diferenciarse visualmente de links (hover state)

**Referencias:** Estándar para acciones terciarias.

---

### 3.3 Ghost Button - Icono + Texto

**Estado:** ✅ **Común / Uso apropiado**

**Cuándo usar:**
- Acciones terciarias que se benefician de icono
- "Ver más" + icono flecha
- "Ayuda" + icono interrogación
- Mantiene claridad sin competir visualmente

**Cuándo NO usar:**
- Espacios muy reducidos
- Cuando el texto es completamente claro

**Escenarios comunes:**
- "Ver más" + icono flecha
- "Ayuda" + icono ?
- "Configuración" + icono engranaje

**Accesibilidad:**
- Mantener estilo discreto
- Icono complementa texto

**Referencias:** Apropiado cuando mejora claridad.

---

### 3.4 Ghost Button - Navigate (Interno)

**Estado:** ✅ **Común / Uso apropiado**

**Cuándo usar:**
- Navegación terciaria dentro de la app
- "Ver todos" en secciones secundarias
- Navegación que no requiere énfasis
- Similar a links pero con estilo de botón

**Cuándo NO usar:**
- Navegación principal (usar primary/secondary)
- Cuando un link normal es suficiente

**Escenarios comunes:**
- "Ver más productos" en secciones
- "Ir a ayuda" desde footer
- Navegación discreta

**Accesibilidad:**
- Mantener estilo discreto
- Indicar que es navegación

**Referencias:** Apropiado para navegación terciaria.

---

### 3.5 Ghost Button - Href (Externo)

**Estado:** ⚠️ **Poco común / Uso específico**

**Cuándo usar:**
- Links externos terciarios
- "Política de privacidad" en footer
- Links externos que no requieren énfasis
- Raramente necesario (preferir link normal)

**Cuándo NO usar:**
- En la mayoría de casos - usar link normal
- Links externos importantes (usar secondary)

**Escenarios comunes:**
- Links legales en footer
- Links a documentación externa (terciarios)

**Accesibilidad:**
- Indicar que es externo
- Mantener estilo discreto

**Referencias:** Uso muy específico.

---

### 3.6 Ghost Button - Loading

**Estado:** ⚠️ **Poco común / Uso raro**

**Cuándo usar:**
- Acciones terciarias que requieren procesamiento
- Raramente necesario (acciones terciarias suelen ser instantáneas)

**Cuándo NO usar:**
- En la mayoría de casos - acciones terciarias son rápidas
- Si la acción es importante, usar secondary con loading

**Escenarios comunes:**
- "Sincronizar" como acción terciaria
- Operaciones en background (raro)

**Referencias:** Uso muy específico.

---

### 3.7 Ghost Button - Disabled

**Estado:** ⚠️ **Poco común / Uso raro**

**Cuándo usar:**
- Acciones terciarias temporalmente no disponibles
- Raramente necesario (preferir ocultar si no está disponible)

**Cuándo NO usar:**
- En la mayoría de casos - ocultar si no está disponible
- Si es importante, usar secondary disabled

**Referencias:** Uso muy específico.

---

## 4. DANGER BUTTON (6 variantes)

### 4.1 Danger Button - Solo Icono

**Estado:** ❌ **No recomendado / Uso peligroso**

**Cuándo usar:**
- **Casi nunca** - acciones destructivas requieren claridad absoluta
- Solo en contextos muy específicos donde el icono es universalmente reconocido (papelera=eliminar)
- Y hay confirmación adicional (modal de confirmación)

**Cuándo NO usar:**
- **En la mayoría de casos** - demasiado ambiguo para acciones destructivas
- Sin confirmación adicional
- Sin contexto claro

**Escenarios comunes:**
- Icono papelera en lista (con confirmación)
- Icono X para cerrar/eliminar (con confirmación)

**Accesibilidad:**
- **OBLIGATORIO:** `aria-label` muy descriptivo ("Eliminar elemento X")
- **OBLIGATORIO:** Confirmación adicional (modal)
- Tamaño mínimo: 48×48px

**Referencias:** Material Design recomienda texto para acciones destructivas.

---

### 4.2 Danger Button - Solo Texto

**Estado:** ✅ **Muy común / Uso estándar**

**Cuándo usar:**
- Acciones destructivas que requieren máxima claridad
- "Eliminar", "Borrar", "Eliminar cuenta"
- Siempre con confirmación adicional (modal)

**Cuándo NO usar:**
- Sin confirmación adicional
- Acciones que no son realmente destructivas

**Escenarios comunes:**
- "Eliminar cuenta" en configuración
- "Borrar proyecto" en dashboard
- "Eliminar elemento" en listas (con confirmación)

**Accesibilidad:**
- Texto muy claro y directo
- **OBLIGATORIO:** Confirmación adicional
- Color rojo/rose para indicar peligro

**Referencias:** Estándar en todas las guías de diseño.

---

### 4.3 Danger Button - Icono + Texto

**Estado:** ✅ **Muy común / Uso recomendado**

**Cuándo usar:**
- Acciones destructivas que se benefician de refuerzo visual
- "Eliminar" + icono papelera (reforzar gravedad)
- Mejora comprensión de la acción destructiva

**Cuándo NO usar:**
- Sin confirmación adicional
- Cuando el texto es completamente claro

**Escenarios comunes:**
- "Eliminar" + icono papelera
- "Borrar cuenta" + icono advertencia
- "Eliminar permanentemente" + icono papelera

**Accesibilidad:**
- **OBLIGATORIO:** Confirmación adicional
- Icono refuerza gravedad
- Color rojo/rose

**Referencias:** Recomendado por Material Design para acciones destructivas.

---

### 4.4 Danger Button - Navigate (Interno)

**Estado:** ❌ **No recomendado / Uso raro**

**Cuándo usar:**
- Casi nunca - la navegación raramente es destructiva
- "Ir a página de eliminación" (raro)

**Cuándo NO usar:**
- En la mayoría de casos - navegación no es destructiva
- Preferir link normal o secondary

**Referencias:** Uso muy específico y raro.

---

### 4.5 Danger Button - Href (Externo)

**Estado:** ❌ **No recomendado / Uso raro**

**Cuándo usar:**
- Casi nunca - links externos raramente son destructivos
- "Ir a página externa de eliminación" (muy raro)

**Cuándo NO usar:**
- En la mayoría de casos
- Preferir link normal

**Referencias:** Uso muy específico y raro.

---

### 4.6 Danger Button - Loading

**Estado:** ✅ **Común / Uso apropiado**

**Cuándo usar:**
- Durante procesamiento de acción destructiva
- "Eliminando..." con spinner
- Importante para prevenir múltiples clics

**Implementación:**
- Mostrar "Eliminando..." o mantener texto + spinner
- Deshabilitar botón
- No permitir cancelación fácil durante loading

**Referencias:** Estándar para acciones destructivas.

---

### 4.7 Danger Button - Disabled

**Estado:** ✅ **Común / Uso apropiado**

**Cuándo usar:**
- Cuando la acción destructiva no está disponible
- Sin selección para eliminar
- Sin permisos para eliminar
- Validaciones pendientes

**Implementación:**
- Mismo que otros disabled
- Mantener color rojo/rose pero atenuado
- Tooltip explicando por qué está deshabilitado

**Referencias:** Estándar para acciones destructivas.

---

## 5. LINK NAVIGATE (3 variantes)

### 5.1 Link Navigate - Solo Icono

**Estado:** ✅ **Común / Uso apropiado**

**Cuándo usar:**
- Navegación rápida con iconos reconocibles
- Icono casa = Home
- Icono usuario = Perfil
- Navegación en barras compactas (móvil)

**Cuándo NO usar:**
- Iconos ambiguos
- Sin contexto suficiente

**Escenarios comunes:**
- Icono casa en navbar
- Icono usuario en header
- Icono configuración en menú

**Accesibilidad:**
- **OBLIGATORIO:** `aria-label` descriptivo
- Tamaño mínimo: 48×48px
- Tooltip en hover

**Referencias:** Común en navegación móvil.

---

### 5.2 Link Navigate - Solo Texto

**Estado:** ✅ **Muy común / Uso estándar**

**Cuándo usar:**
- Navegación estándar en menús
- Links en contenido
- Navegación principal/secundaria
- La forma más común de navegación

**Cuándo NO usar:**
- Cuando se necesita refuerzo visual
- En espacios muy reducidos

**Escenarios comunes:**
- "Inicio", "Perfil", "Configuración" en menú
- "Ver más" en contenido
- Links en footer

**Accesibilidad:**
- Texto claro
- Diferenciarse visualmente del texto normal
- Indicar estado activo/visitado

**Referencias:** Estándar en todas las guías de diseño.

---

### 5.3 Link Navigate - Icono + Texto

**Estado:** ✅ **Común / Uso apropiado**

**Cuándo usar:**
- Navegación que se beneficia de icono
- Menús de navegación principales
- Mejora reconocimiento rápido
- Navegación en listas

**Cuándo NO usar:**
- Espacios muy reducidos
- Cuando el texto es completamente claro

**Escenarios comunes:**
- "Inicio" + icono casa en navbar
- "Perfil" + icono usuario
- "Configuración" + icono engranaje

**Accesibilidad:**
- Icono complementa texto
- Mantener estilo de link (no botón)

**Referencias:** Común en navegación principal.

---

## 6. LINK HREF (3 variantes)

### 6.1 Link Href - Solo Icono

**Estado:** ⚠️ **Poco común / Uso específico**

**Cuándo usar:**
- Links externos con iconos muy reconocibles
- Iconos de redes sociales (Twitter, Facebook, LinkedIn)
- Espacios muy reducidos
- Footer con iconos sociales

**Cuándo NO usar:**
- Iconos ambiguos
- Sin contexto suficiente
- Links importantes

**Escenarios comunes:**
- Iconos de redes sociales en footer
- "Abrir en nueva pestaña" con icono
- Links externos en toolbars

**Accesibilidad:**
- **OBLIGATORIO:** `aria-label` descriptivo
- Indicar que es externo
- Tamaño mínimo: 48×48px
- Icono de "external link" recomendado

**Referencias:** Común para redes sociales.

---

### 6.2 Link Href - Solo Texto

**Estado:** ✅ **Muy común / Uso estándar**

**Cuándo usar:**
- Links externos estándar
- "Política de privacidad" en footer
- "Documentación" que lleva a sitio externo
- Links en contenido que van a sitios externos

**Cuándo NO usar:**
- Links internos (usar navigate)
- Cuando se necesita indicar que es externo visualmente

**Escenarios comunes:**
- Links legales en footer
- "Ver documentación completa" (sitio externo)
- Links a recursos externos

**Accesibilidad:**
- Indicar que es externo (texto o icono)
- `target="_blank"` con `rel="noopener"`
- Avisar que abre en nueva ventana

**Referencias:** Estándar para links externos.

---

### 6.3 Link Href - Icono + Texto

**Estado:** ✅ **Común / Uso recomendado**

**Cuándo usar:**
- Links externos que se benefician de indicación visual
- "Ver documentación" + icono external link
- Mejora claridad de que es externo
- Links importantes a recursos externos

**Cuándo NO usar:**
- Espacios muy reducidos
- Cuando el texto ya indica que es externo

**Escenarios comunes:**
- "Documentación" + icono external link
- "Soporte" + icono external link
- "Ver en GitHub" + icono external link

**Accesibilidad:**
- **OBLIGATORIO:** Icono de "external link" (arrow-top-right-on-square)
- Indicar que abre en nueva ventana
- `target="_blank"` con `rel="noopener"`

**Referencias:** Recomendado por Material Design para links externos.

---

## Resumen: Frecuencia de Uso

### ✅ Muy Común (Uso Estándar)
- Primary: Solo texto, Icono+texto, Loading, Disabled
- Secondary: Solo texto, Icono+texto, Loading, Disabled
- Ghost: Solo texto, Solo icono, Icono+texto, Navigate
- Danger: Solo texto, Icono+texto, Loading, Disabled
- Link Navigate: Solo texto, Icono+texto
- Link Href: Solo texto, Icono+texto

### ✅ Común (Uso Apropiado)
- Primary: Navigate
- Secondary: Solo icono, Navigate, Loading, Disabled
- Ghost: Navigate, Loading (raro)
- Danger: Loading, Disabled
- Link Navigate: Solo icono
- Link Href: Solo icono

### ⚠️ Poco Común (Uso Específico)
- Primary: Solo icono, Href
- Secondary: Href
- Ghost: Href, Disabled (raro)
- Danger: Navigate, Href
- Link Href: Solo icono (específico)

### ❌ No Recomendado (Uso Raro/Peligroso)
- Primary: Href (casi nunca)
- Danger: Solo icono (sin confirmación), Navigate, Href

---

## 7. DROPDOWN MENU

El componente `.dropdown` permite crear menús desplegables. El slot `:item` recibe `hide_command` que debe usarse para cerrar el dropdown al hacer clic.

### Uso Básico

El slot `:item` permite pasar cualquier componente (`.link`, `.button`, etc.) directamente:

```heex
<.dropdown id="actions-menu">
  <:trigger :let={dropdown}>
    <button phx-click={dropdown.toggle_command}>Acciones</button>
  </:trigger>
  
  <:item :let={hide_command}>
    <.link navigate="/profile" phx-click={hide_command} class="w-full flex items-center gap-3">
      <.svg name="hero-user" class="w-5 h-5 text-subtle" />
      Mi Perfil
    </.link>
  </:item>
  
  <:item :let={hide_command}>
    <.button phx-click={JS.push("download") |> hide_command} phx-value-format="pdf" variant="ghost" class="w-full justify-start">
      <.svg name="hero-arrow-down-tray" class="w-5 h-5 text-subtle" />
      Descargar PDF
    </.button>
  </:item>
</.dropdown>
```

### Reglas Importantes

1. **Siempre usar `hide_command`**: El slot `:item` recibe `hide_command` que debe combinarse con el `phx-click` del componente para cerrar el dropdown automáticamente.

2. **Usar componentes existentes**: Pasa `.link` o `.button` directamente dentro del slot `:item`, no uses atributos del slot.

3. **Estilos del wrapper**: El wrapper del item ya incluye padding, hover y transiciones. Los componentes internos deben usar `w-full` para ocupar todo el ancho.

4. **Iconos**: Los iconos deben incluirse dentro del componente (`.link` o `.button`), no como atributos del slot.

### Ejemplos Comunes

#### Navegación Interna (navigate)
```heex
<:item :let={hide_command}>
  <.link navigate="/profile" phx-click={hide_command} class="w-full flex items-center gap-3">
    <.svg name="hero-user" class="w-5 h-5 text-subtle" />
    Mi Perfil
  </.link>
</:item>
```

#### Navegación Externa (href)
```heex
<:item :let={hide_command}>
  <.link href="/auth/logout" data-phx-link="redirect" phx-click={hide_command} class="w-full flex items-center gap-3 text-[var(--signal-danger-main)]">
    <.svg name="hero-arrow-right-on-rectangle" class="w-5 h-5 text-subtle" />
    Cerrar Sesión
  </.link>
</:item>
```

#### Acción con Evento (phx-click)
```heex
<:item :let={hide_command}>
  <.button phx-click={JS.push("download") |> hide_command} phx-value-format="pdf" variant="ghost" class="w-full justify-start">
    <.svg name="hero-arrow-down-tray" class="w-5 h-5 text-subtle" />
    Descargar PDF
  </.button>
</:item>
```

#### Acción con Múltiples Valores
```heex
<:item :let={hide_command}>
  <.button phx-click={JS.push("export") |> hide_command} phx-value-format="csv" phx-value-date="2024-01-01" variant="ghost" class="w-full justify-start">
    <.svg name="hero-arrow-down-tray" class="w-5 h-5 text-subtle" />
    Exportar CSV
  </.button>
</:item>
```

### Clases Recomendadas

- **Para `.link`**: `class="w-full flex items-center gap-3"` (ajusta según necesites)
- **Para `.button`**: `class="w-full justify-start"` (para alinear contenido a la izquierda)

---

# ...