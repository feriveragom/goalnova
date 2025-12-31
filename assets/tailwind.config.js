// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  darkMode: 'class',
  content: [
    "./js/**/*.js",
    "../lib/goalnova_web.ex",
    "../lib/goalnova_web/**/*.*ex"
  ],
  theme: {
    // Fonts "Inter" for a clean, modern look 
    // Make sure to @import "Inter" in your CSS or include it in your HTML head
    fontFamily: {
      sans: ["Inter", "sans-serif"],
      serif: ["Inter", "serif"],
      mono: ["Fira Code", "monospace"], // Optional: Fira Code for code blocks matches Elixir vibe
    },
    extend: {
      colors: {
        // --- BRAND PALETTE (Raw Materials + Semantic Tokens) ---
        // Combinamos valores raw y tokens semánticos en una sola definición
        brand: {
          // Raw values para casos específicos
          50: "#F5F3FF",
          100: "#EDE9FE",
          200: "#DDD6FE",
          300: "#C4B5FD",
          400: "#A78BFA",
          500: "#8B5CF6",
          600: "#7C3AED",
          700: "#6D28D9",
          800: "#5B21B6",
          900: "#4C1D95",
          950: "#2E1065",
          // Semantic tokens (The Brain) - Mapeo directo a CSS Variables
          DEFAULT: 'var(--color-brand-primary)',
          hover: 'var(--color-brand-hover)',
          active: 'var(--color-brand-active)',
          contrast: 'var(--color-brand-contrast)',
          subtle: 'var(--color-brand-subtle)',
        },

        // Surfaces
        surface: {
          base: 'var(--surface-base)',
          card: 'var(--surface-card)',
          overlay: 'var(--surface-overlay)',
          sunken: 'var(--surface-sunken)',
          hover: 'var(--surface-hover)',
        },

        // Text
        text: {
          main: 'var(--text-main)',
          muted: 'var(--text-muted)',
          disabled: 'var(--text-disabled)',
          inverse: 'var(--text-inverse)',
        },

        // Borders
        border: {
          subtle: 'var(--border-subtle)',
          strong: 'var(--border-strong)',
        },

        // Signals (Semáforos)
        signal: {
          success: 'var(--signal-success-main)',
          'success-subtle': 'var(--signal-success-subtle)',
          'success-text': 'var(--signal-success-text)',

          warning: 'var(--signal-warning-main)',
          'warning-subtle': 'var(--signal-warning-subtle)',
          'warning-text': 'var(--signal-warning-text)',

          danger: 'var(--signal-danger-main)',
          'danger-subtle': 'var(--signal-danger-subtle)',
          'danger-text': 'var(--signal-danger-text)',

          info: 'var(--signal-info-main)',
          'info-subtle': 'var(--signal-info-subtle)',
          'info-text': 'var(--signal-info-text)',
        },

        // Secondary Actions
        action: {
          'neutral-bg': 'var(--action-neutral-bg)',
          'neutral-border': 'var(--action-neutral-border)',
          'neutral-text': 'var(--action-neutral-text)',
          'neutral-hover': 'var(--action-neutral-hover)',
        }
      },
      // Extend shadows to include our token
      boxShadow: {
        'card': 'var(--shadow-card)',
        'popover': 'var(--shadow-popover)',
      },
      // Extend ring width/color if needed, but usually colors handles it
      ringColor: {
        focus: 'var(--ring-focus)',
      },
      backgroundImage: {
        'gradient-main': "linear-gradient(135deg, #667eea 0%, #764ba2 100%)", // Example logic
        'gradient-radial': 'radial-gradient(var(--tw-gradient-stops))',
      }
    },
  },
  plugins: [
    require("@tailwindcss/forms"),

    // VARIANT PLUGINS (For Phoenix LiveView states)
    plugin(({ addVariant }) => addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])),
    plugin(({ addVariant }) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({ addVariant }) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({ addVariant }) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // HEROICONS PLUGIN
    // Simplified logic to match your previous "green" project which was clean and effective.
    plugin(function ({ matchComponents, theme }) {
      let iconsDir = path.join(__dirname, "../deps/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
        ["-micro", "/16/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) }
        })
      })
      matchComponents({
        "hero": ({ name, fullPath }) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
          let size = theme("spacing.6")
          if (name.endsWith("-mini")) size = theme("spacing.5")
          if (name.endsWith("-micro")) size = theme("spacing.4")

          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": size,
            "height": size
          }
        }
      }, { values })
    })
  ]
}
