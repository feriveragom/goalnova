# Sistema UI NovaReach: Átomos y Arquitectura

Este documento define los materiales base y cómo se ensamblan para crear una interfaz adaptable y robusta.

---

## 1. Átomos de Diseño (Materia Prima)
*Los ingredientes visuales concretos.*

*   **Paleta de Colores:**
    *   **Neutros:** `Zinc` (Base estructural metálica) - Usado mínimamente.
    *   **Primarios:** `Violet` (Identidad Púrpura NovaReach) - Color de marca.
    *   **Semánticos:** `Emerald` (Éxito), `Rose` (Peligro), `Amber` (Warning), `Sky` (Info).
*   **Tipografía:** `Inter` (Principal/UI), `Fira Code` (Datos/Código).
*   **Geometría:** Bordes `Rounded-md/lg` (Suavidad media).

---

## Tema "Soft Violet Space"
*La identidad visual completa de NovaReach.*

### Filosofía
Un diseño que combina profesionalismo oscuro con identidad violeta sutil. Equilibrio entre "espacio profundo" y "marca visible".

### Directrices Light Mode: "Soft Violet Paper"
**Filosofía de color:** Grises muy claros con toque violeta apagado, menos fluorescente. Colores suaves que no cansen la vista.

**Principios:**
- **Superficies:** Grises muy claros con suspiro de violeta muy sutil, no saturado
- **Bordes:** Visibles pero sutiles (zinc-300/400), suficiente contraste para definir estructura
- **Hovers:** Contraste visible pero suave, usando `--surface-hover`
- **Brand:** Violeta vibrante para elementos de marca, manteniendo identidad

**Referencia:** Valores exactos definidos en `assets/css/app.css` (líneas 25-35)

### Directrices Dark Mode: "Deep Space Identity"
**Filosofía de color:** Gris oscuro apagado, suave para la vista, sin tinte azul dominante. Colores que no molesten en los ojos.

**Principios:**
- **Superficies:** Gris oscuro apagado (tipo `#212733`), no negro puro ni azul saturado
- **Bordes:** Visibles con buen contraste (zinc-600/500), definen estructura claramente
- **Hovers:** Contraste visible sobre tarjetas, usando `--surface-hover`
- **Brand:** Violeta más brillante para compensar fondo oscuro, manteniendo identidad

**Referencia:** Valores exactos definidos en `assets/css/app.css` (líneas 113-125)

### Características del Tema
- ✅ **Identidad clara** sin ser agresiva
- ✅ **Profesional** (no parece juguete)
- ✅ **Accesible** (contraste WCAG AA+)
- ✅ **Coherente** (mismo violeta en ambos modos)
- ✅ **Adaptable** (automático via CSS variables)

### Activación del Modo Light/Dark

**Implementación Técnica:**
- **Inicialización:** Script en `root.html.heex` que se ejecuta antes del CSS para evitar FOUC
- **Toggle:** Botón en `app.html.heex` que alterna la clase `dark` en `document.documentElement`
- **Persistencia:** `localStorage.setItem('theme', 'dark'|'light')`
- **Configuración Tailwind:** `darkMode: 'class'` en `tailwind.config.js`
- **Referencia:** `lib/goalnova_web/components/layouts/root.html.heex` (líneas 10-20)

---

## Arquitectura del Sistema
*La maquinaria que ensambla los átomos resolviendo las "7 Dimensiones" de la UI.*

### Nivel A: Tokens Semánticos (El Cerebro)
Variables CSS que resuelven el **Contexto (Light/Dark)** y la **Adaptación**.
*Definen QUÉ valor toma un rol según el entorno.*

*   **Identidad:** `--brand-primary`, `--brand-hover`, `--brand-contrast`, `--brand-subtle`.
*   **Superficies:** `--surface-base`, `--surface-card`, `--surface-overlay`, `--surface-sunken`, `--surface-hover`.
    *   **Light Mode:** Grises muy claros con toque violeta apagado - "Soft Violet Paper"
    *   **Dark Mode:** Gris oscuro apagado, suave para la vista - "Deep Space Identity"
    *   **Hover:** `--surface-hover` - Token específico para estados hover con contraste visible
    *   **Referencia:** Valores exactos en `assets/css/app.css`
*   **Señales:** `--signal-danger`, `--signal-success`, `--signal-warning`, `--signal-info` (con variantes -main, -subtle, -text).
*   **Texto:** `--text-main`, `--text-muted`, `--text-disabled`, `--text-inverse`.
*   **Bordes:** `--border-subtle`, `--border-strong`.
*   **Efectos:** `--shadow-card`, `--shadow-popover` (desaparecen en dark mode).
*   **Accesibilidad:** `--ring-focus`.
*   **Interacción Neutral:** `--action-neutral-bg`, `--action-neutral-border`, `--action-neutral-text`, `--action-neutral-hover`.

### Nivel B: Clases Maestras (El Cuerpo)
Componentes CSS (`.card`, `.btn`) que encapsulan el resto de dimensiones: **Geometría, Espacio, Estado y Tiempo**.
*Consumen los Tokens y aplican las reglas constantes.*

**Estilos Globales Base (`@layer base`):**
*   `body` - Fondo base y tipografía del sistema
*   `a` - Transición de colores automática para todos los enlaces

**Estilos Globales de Componentes (`@layer components`):**
*   `a:hover` - **Todos los enlaces tienen hover automático** con `--surface-hover` (implementado con `!important` para sobrescribir clases de Tailwind)

**Clases Maestras Implementadas:**
*   `.surface-card` - Tarjeta con fondo adaptable, bordes y sombras
*   `.btn` - Base de botón con estados focus/disabled
*   `.btn-primary` - Botón de acción principal (violeta)
*   `.btn-secondary` - Botón de acción secundaria (neutral)
*   `.btn-ghost` - Botón transparente
*   `.btn-danger` - Botón destructivo (rojo/rose)
*   `.input-field` - Campo de formulario adaptable
*   `.input-field-error` - Estado de error para inputs
*   `.text-brand` - Texto con color de marca
*   `.text-subtle` - Texto secundario/muted
*   `.text-error` - Texto de error

---

## Estado Actual de Implementación

### ✅ Completado

**Fase 1: Tokens CSS**
- ✅ Todas las categorías de tokens definidas en `app.css`
- ✅ Light Mode con identidad violeta sutil
- ✅ Dark Mode con violeta oscuro profesional
- ✅ Sistema completo de 8 categorías (Brand, Surfaces, Text, Signals, Borders, Effects, Focus, Neutral Actions)

**Fase 2: Config Tailwind**
- ✅ `tailwind.config.js` mapeado a CSS variables
- ✅ Clases de utilidad disponibles: `bg-surface-card`, `text-brand`, etc.

**Fase 3: Clases Maestras**
- ✅ Componentes base: `.btn`, `.input-field`, `.surface-card`
- ✅ Variantes de botones implementadas

**Fase 4: Aplicación**
- ✅ `CoreComponents.ex` refactorizado parcialmente
- ✅ `demo_live.html.heex` limpiado
- ✅ `application_ui.html.heex` usando nuevas clases
- ⚠️ `home_live.html.heex` y layouts todavía usan clases legacy (`bg-card-light dark:bg-card-dark`)

### 🔄 Pendiente

**Limpieza de Layouts:**
- `home_live.html.heex` - Cambiar de `bg-card-light dark:bg-card-dark` a `.surface-card`
- `app.html.heex` - Verificar que header usa tokens correctos
- Otros LiveViews que puedan tener clases hardcoded

**Optimizaciones:**
- Eliminar clases duplicadas de utilidad donde se puedan usar master classes
- Documentar casos de uso de cada clase maestra
- Crear variantes adicionales si se necesitan (`.btn-sm`, `.btn-lg`, etc.)

---

## Reglas de Uso

### ✅ HACER
- Usar clases maestras siempre que sea posible: `class="surface-card"` 
- Usar tokens de color: `bg-[var(--surface-base)]`, `text-brand`
- **Los enlaces (`<a>`, `<.link>`) tienen hover automático** - No es necesario agregar clases de hover manualmente
- **Para hovers en otros elementos:** Usar `hover:bg-[var(--surface-hover)]` - Contraste visible y consistente
- Mantener la disciplina: NUNCA usar `bg-white` o `bg-black` directamente

### ❌ NO HACER
- NO usar `dark:` prefijos si existe una clase maestra
- NO hardcodear colores hex en el HTML
- NO usar `bg-card-light dark:bg-card-dark` (obsoleto, usar `.surface-card`)
- NO usar `text-primary-700 dark:text-primary-300` (obsoleto, usar `.text-brand`)
- **NO usar `hover:bg-[var(--color-brand-subtle)]` para hovers** - Usar `--surface-hover` en su lugar
- NO usar clases hardcoded para hovers (`hover:bg-zinc-50`, `hover:bg-gray-100`, etc.) - Usar tokens

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

### Referencia de Ejemplos

Ver `lib/novareach_web/live/demo_live/tabs/app_ui_desktop/app_ui_desktop.html.heex` para ejemplos correctos de uso de `navigate` (interno) y `href` (externo).

---

## Próximos Pasos

1. **Auditoría de Vistas:** Revisar todos los `.heex` para eliminar clases legacy
2. **Expandir Master Classes:** Crear más componentes según necesidad (`.badge`, `.alert`, etc.)
3. **Testing Visual:** Verificar que no haya roturas visuales en Dark/Light mode
4. **Documentación de Componentes:** Crear guía de uso para cada clase maestra
