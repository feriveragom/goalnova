# Especificación de Patrones - GoalNova
## Régimen Estricto Obligatorio

**PROPÓSITO EXCLUSIVO DE ESTE DOCUMENTO:**
Definir los 7 patrones de diseño NO-NEGOCIABLES que DEBEN aplicarse a:
1. Toda refactorización de código existente
2. Todo incremento nuevo
3. Toda intervención futura

**ENFORCEMENT:** No hay excepciones. Si la IA propone código que viola estos patrones, es un ERROR.

---

## 📚 DOCUMENTOS RECTORES COMPLEMENTARIOS

Este documento define los patrones arquitectónicos obligatorios. Para información detallada sobre otros aspectos del proyecto, consultar:

- `.github/patrones_antipatrones.md` (este documento)
- `.artifacts/tecnologias_goalnova.md` (Stack tecnológico y arquitectura de sistemas)
- `.artifacts/grafo_goalnova.md` (Modelo de grafo relacional y sistema de Traits/Edges y Monetización)
- `.artifacts/mvp_goalnova.md` (Estrategia de lanzamiento y definición de MVP)
- `.artifacts/matriz_seguridad_permisos.md` (Sistema de permisos y seguridad)
- `.artifacts/alcance_datos.md` (Alcance y gestión de datos)
- `.artifacts/ui_standards.md` (Estándares de UI y componentes)

---

## 🔴 LOS PATRONES OBLIGATORIOS

### 1. Permission-Driven Security - OBLIGATORIO SIN EXCEPCIÓN

**Regla fundamental:** Acceso controlado **ÚNICAMENTE** por la intersección de permisos atómicos (capabilities) derivados de **Traits/Edges** Y **Feature Flags (Monetización)**. NUNCA por roles jerárquicos o lógica aislada.

**Prohibido:**
- ❌ Verificar roles en código (`if user.role == :admin`)
- ❌ Asumir jerarquía (`if level > 50`)
- ❌ Hardcodear mapeos de roles.
- ❌ Ignorar el estado de monetización (Flag) de un Trait.

**Obligatorio:**
- ✅ Autorización vía `Policy.can?(user, "permission.code")` que encapsula AMBOS chequeos.
- ✅ Fuente de verdad: Listas de permisos (JSONB) **AND** Feature Flags (DB/Cache).
- ✅ Todo se resuelve reduciendo a capabilities atómicas validadas contra el plan de pago.

**Axioma de Seguridad Unificado:**
El acceso real a una capacidad depende de la intersección de dos dimensiones obligatorias:
1.  **Autoridad (Seguridad):** ¿Quién eres? (Traits + Edges).
2.  **Capacidad (Monetización):** ¿Qué has pagado? (Feature Flags).

Esta es la base de nuestra seguridad:
*   `Policy.can?(Yo, PermisoX)` -> (`PermisoX` en mis Traits) **AND** (`Flag` del Trait está ACTIVA).
*   `Policy.can?(Yo, PermisoX, Otro)` -> (`PermisoX` en mis Edges) **AND** (`Flag` del Trait está ACTIVA).

**Aplicación:**
- Controllers, Plugs, LiveViews y Services validan strings de permisos.

---

### 2. Mobile-First UI - OBLIGATORIO SIN EXCEPCIÓN

**Regla fundamental:** Todo diseño comienza en 320px (móvil). Luego se escala a desktop.

**Prohibido:**
- ❌ Diseñar desktop first
- ❌ Clases sin prefijo para desktop

**Obligatorio:**
- ✅ Base: 320px+
- ✅ Breakpoints: `sm:` (640px), `md:` (768px), `lg:` (1024px), `xl:` (1280px)
- ✅ Componentes en `lib/goalnova_web/components/`

---

### 3. Clean Architecture - OBLIGATORIO SIN EXCEPCIÓN

**Regla fundamental:** El dominio (lógica de negocio) NUNCA depende de infraestructura ni UI.

**Estructura:**
`Exterior ──→ Dominio ←── Exterior`

**Prohibido:**
- ❌ Domain importa Ecto, SQL, Phoenix

**Obligatorio:**
- ✅ `domain/` (Puro)
- ✅ `[context]/` (Application/Services)
- ✅ `infra/` (Implementación)
- ✅ `web/` (UI)

---

### 4. Repository Pattern - OBLIGATORIO SIN EXCEPCIÓN

**Regla fundamental:** El dominio define interfaces (behaviours). La infraestructura las implementa.

**Prohibido:**
- ❌ SQL en services/controllers
- ❌ Dominio dependiendo de implementación

**Obligatorio:**
- ✅ Behaviour en domain
- ✅ Implementación en infra
- ✅ Services usan behaviour

---

### 5. Service Layer - OBLIGATORIO SIN EXCEPCIÓN

**Regla fundamental:** Toda lógica de negocio compleja vive en servicios.

**Prohibido:**
- ❌ Lógica en controllers
- ❌ Orquestación en UI

**Obligatorio:**
- ✅ Services en `lib/goalnova/[context]/`
- ✅ Controllers solo delegan

#### 5.1 Railway Oriented Programming (Bloques Monádicos `Error.m`)
**Prohibido:** `case` anidados.
**Obligatorio:** Usar `Error.m` para flujos complejos.

**⚠️ REGLAS CRÍTICAS DE SINTAXIS (Anti-Alucinación):**

1.  **NUNCA usar asignación `=`:** Rompe la macro.
    - ❌ `user = Accounts.create(...)`
    - ✅ `user <- Accounts.create(...)`

2.  **SIEMPRE capturar efectos secundarios:**
    - ❌ `Logger.info("...")` (Línea suelta rompe la macro)
    - ✅ `_ <- Logger.info("...") |> Error.return()` (Envuelto correctamente)

3.  **TODO debe ser mónada (`{:ok, _}` | `{:error, _}`):**
    - Si usas una función pura (ej: `Map.put`), envuélvela.
    - ❌ `params = Map.put(payload, :id, 1)`
    - ✅ `params <- Map.put(payload, :id, 1) |> Error.return()`

```elixir
defmodule ... do
  require Monad.Error, as: Error

  def register_user(params) do
    Error.m do
      # 1. Extracción monádica (<-) obligatoria
      attrs  <- Validate.params(params)
      
      # 2. Efecto secundario envuelto
      _      <- Logger.info("Creando usuario") |> Error.return()
      
      # 3. Operación que puede fallar
      payload   <- Accounts.create(attrs)
      
      # 4. Transformación pura envuelta
      user   <- Map.put(payload, :meta, "new") |> Error.return()
      
      # 5. Retorno final explícito
      Error.return(user)
    end
  end
end
```

---

### 6. Context Pattern - OBLIGATORIO SIN EXCEPCIÓN

**Regla fundamental:** Código agrupado por dominio autónomo.

**Estructura:**
`accounts`, `permissions`, `grafo`, `infra`

**Obligatorio:**
- ✅ Contextos definidos con Service, Tests e Interfaces.

---

### 7. Colocated Templates (LiveView Strict Folder Structure)

**Regla fundamental:** Cada LiveView/Componente en su propia carpeta. Estara conformado por *.ex y *.html.heex

**Prohibido:**
- ❌ `~H` inline para vistas completas.

**Estructura:**
```text
lib/goalnova_web/live/home_live/
├── index.ex
└── index.html.heex
```

---

## 📋 CHECKLIST DE VALIDACIÓN (Pre-Merge)

**Si falla uno → RECHAZAR CÓDIGO.**

1. [ ] ¿Autorización vía `Policy.can?` (No roles)?
2. [ ] ¿UI Mobile-First?
3. [ ] ¿Clean Architecture (Domain puro)?
4. [ ] ¿SQL aislado en Repositories?
5. [ ] ¿Lógica en Services (con `Error.m` correcto)?
6. [ ] ¿Context Pattern respetado?
7. [ ] ¿Templates separados?

---

## 🚫 ANTI-PATRONES BLOQUEANTES

| Anti-Patrón | Problema | Solución |
|-------------|----------|----------|
| **SQL Injection** | Vulnerabilidad | Usar parámetros (`$param`) |
| **Lógica en Controller** | No testeable | Mover a Services |
| **Role Checks** | Rígido | Usar `Policy.can?` |
| **N+1 Queries** | Performance | Eager loading |
| **Exceptions for Flow** | Control de flujo | Usar ROP (`Error.m`) |
| **Asignación `=` en Error.m** | Rompe macro | Usar `<-` |
| **Logs sueltos en Error.m** | Rompe flujo | Usar `|> Error.return()` |

