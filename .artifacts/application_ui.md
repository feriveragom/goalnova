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

## Uso de Componentes

Los componentes UI están implementados en `lib/goalnova_web/components/core_components.ex` y siguen la arquitectura definida en este documento.

### Implementación Técnica

**Tokens CSS:** Definidos en `assets/css/app.css`
- Tokens semánticos que se adaptan automáticamente a Light/Dark mode
- Valores específicos para Brand, Surfaces, Text, Signals, Borders, Effects, Focus, Neutral Actions

**Configuración Tailwind:** Mapeada en `assets/tailwind.config.js`
- Clases de utilidad disponibles: `bg-surface-card`, `text-brand`, etc.
- Integración con CSS variables para adaptación automática

**Componentes Elixir:** Implementados en `lib/goalnova_web/components/core_components.ex`
- Componentes como `<.button>`, `<.link>`, `<.modal>`, `<.input>`, etc.
- Usan las clases maestras y tokens definidos en esta arquitectura
- Ejemplos de uso disponibles en `lib/goalnova_web/live/demo_live/`

### Guías de Uso

**Para decisiones sobre cuándo usar cada variante de botones, links y normas de navegación, ver:** [`.artifacts/component_usage_guide.md`](./component_usage_guide.md)

Incluye:
- Norma de navegación (navigate vs href)
- 30 variantes de botones y links con guías de uso
- Escenarios comunes y mejores prácticas según Material Design, Apple HIG, Bootstrap, Tailwind UI

---

## Estrategia Responsive para Botones

**Regla fundamental:** Los botones siguen un patrón Mobile-First donde el tamaño base (móvil) es más grande para cumplir con touch targets, y se reduce en desktop donde el cursor es más preciso.

### Implementación Técnica

El componente `button` en `CoreComponents.ex` usa clases responsive:
```elixir
"py-3 px-4 text-base sm:py-1 sm:px-3 sm:text-sm"
```

