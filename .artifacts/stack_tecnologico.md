# Stack local instalado a reutilizar
```bash
elixir --version && erl -version && mix --version
    Erlang/OTP 25 [erts-13.0.4] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit:ns]

    Elixir 1.14.3 (compiled with Erlang/OTP 25)
    Erlang (SMP,ASYNC_THREADS) (BEAM) emulator version 13.0.4
    Erlang/OTP 25 [erts-13.0.4] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit:ns]

    Mix 1.14.3 (compiled with Erlang/OTP 25)

```

# Mix
```elixir
  def project do
    [
      app: :goalnova,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  defp deps do
    [
      # ============================================================================
      # PHOENIX CORE - Dependencias esenciales de Phoenix
      # ============================================================================
      {:phoenix, "~> 1.7.14"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.0.0-rc.1", override: true},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      
      # Telemetry (usado por Phoenix para métricas)
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      
      # Gettext (internacionalización - usado por Phoenix)
      {:gettext, "~> 0.20"},
      
      # Bandit (servidor HTTP moderno - usado por Phoenix)
      {:bandit, "~> 1.5"},
      
      # ============================================================================
      # DEPENDENCIAS ACTIVAS - Para usar ahora
      # ============================================================================
      
      # Testing
      {:floki, ">= 0.30.0", only: :test},
      
      # Build tools / Assets
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      
      # Utilidades
      {:jason, "~> 1.2"},
      {:timex, "~> 3.7"},
      
      # Ecto (solo para changesets y validación de formularios - sin conexión a DB)
      {:ecto_sql, "~> 3.10"},
      
      # ============================================================================
      # DEPENDENCIAS COMENTADAS - Para después o problemáticas sin otras deps
      # ============================================================================
      
      # Base de datos - PostgreSQL (para después, cuando configuremos la conexión)
      # {:phoenix_ecto, "~> 4.4"},
      # {:postgrex, ">= 0.0.0"},
      
      # Base de datos - Mnesia (para después)
      # {:memento, "~> 0.3.2"},
      
      # Autenticación (para después)
      # {:assent, "~> 0.2"},
      
      # Job processing (da problemas sin PostgreSQL - para después)
      # {:oban, "~> 2.17"}
    ]
  end
  
  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind goalnova", "esbuild goalnova"],
      "assets.deploy": [
        "tailwind goalnova --minify",
        "esbuild goalnova --minify",
        "phx.digest"
      ]
    ]
  end
end
```
