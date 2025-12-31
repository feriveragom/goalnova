**Referencia completa del stack:** Ver `.artifacts/stack_tecnologico.md`

# Crear proyecto Phoenix desde cero

```bash
mix phx.new . --no-install --adapter bandit
```

**Opciones importantes:**
- `.` - Crea el proyecto en el directorio actual
- `--no-install` - No instala dependencias (solo crea la estructura)
- `--adapter bandit` - Usa Bandit como servidor HTTP (según nuestro stack)

# Verificar que funciona

```bash
mix deps
```

Esto mostrará las dependencias definidas sin instalarlas.

# Configurar proyecto para no usar base de datos aún

Después de crear el proyecto con `mix phx.new`, necesitas configurarlo para que NO intente conectarse a la base de datos. Las dependencias pueden quedarse en `mix.exs`, pero debes evitar que se inicien o configuren.

## 1. Comentar en `lib/goalnova/application.ex`

Comenta estas líneas en la lista de `children` para que no se inicien:

```elixir
def start(_type, _args) do
  children = [
    GoalnovaWeb.Telemetry,
    # Goalnova.Repo,  # ← Comentar esta línea
    # {DNSCluster, query: Application.get_env(:goalnova, :dns_cluster_query) || :ignore},  # ← Comentar esta línea
    {Phoenix.PubSub, name: Goalnova.PubSub},
    # {Finch, name: Goalnova.Finch},  # ← Comentar esta línea
    GoalnovaWeb.Endpoint
  ]
  # ...
end
```

## 2. Comentar en `config/config.exs`

Comenta la línea de `ecto_repos`:

```elixir
config :goalnova,
  # ecto_repos: [Goalnova.Repo],  # ← Comentar esta línea
  generators: [timestamp_type: :utc_datetime]
```

## 3. Comentar en `config/dev.exs`

Comenta toda la configuración de la base de datos:

```elixir
# Configure your database
# config :goalnova, Goalnova.Repo,
#   username: "postgres",
#   password: "postgres",
#   hostname: "localhost",
#   database: "goalnova_dev",
#   stacktrace: true,
#   show_sensitive_data_on_connection_error: true,
#   pool_size: 10
```

## 4. Actualizar dependencias en `mix.exs`

### Agregar dependencia

Agrega `timex` a la lista de dependencias:

```elixir
defp deps do
  [
    # ... otras dependencias ...
    {:timex, "~> 3.7"}
  ]
end
```

### Comentar dependencias (opcional)

Si no vas a usar el mailer, puedes comentar estas dependencias en `mix.exs`:

```elixir
defp deps do
  [
    # ... otras dependencias ...
    # {:swoosh, "~> 1.5"},  # ← Comentar si no usas mailer
    # {:finch, "~> 0.13"},  # ← Comentar si no usas mailer (Swoosh lo necesita)
  ]
end
```

**Nota:** Las dependencias de base de datos (phoenix_ecto, postgrex) y dns_cluster pueden quedarse en `mix.exs`. Solo evita que se inicien o configuren comentando las líneas en `application.ex` y archivos de configuración mencionadas arriba.

# Variables de entorno para desarrollo

**Todas las variables de entorno para desarrollo se configuran en `start_dev.sh`.**

Este archivo es el que se usa para levantar el servidor en desarrollo. Si necesitas agregar nuevas variables de entorno, edita `start_dev.sh` y agrégalas en la sección de variables (al inicio del archivo).

Ejemplo de cómo agregar una nueva variable:

```bash
export MIX_ENV=dev
export PHX_HOST=localhost
export PHX_PORT=4000
export LOG_LEVEL=debug
export NUEVA_VARIABLE=valor  # ← Agregar aquí
```

Para iniciar el servidor, ejecuta:

```bash
./start_dev.sh
```
