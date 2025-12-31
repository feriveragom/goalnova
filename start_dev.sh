#!/bin/bash

echo "╔════════════════════════════════════════╗"
echo "║  GoalNova - Development Server Start  ║"
echo "╚════════════════════════════════════════╝"
echo

export MIX_ENV=dev
export PHX_HOST=localhost
export PHX_PORT=4000
export LOG_LEVEL=debug

echo "📋 Validando configuración..."

if ! command -v elixir &> /dev/null; then
    echo "✗ Elixir no está instalado"
    exit 1
fi

if ! command -v mix &> /dev/null; then
    echo "✗ Mix no está instalado"
    exit 1
fi

echo "✓ Elixir y Mix encontrados"
echo

echo "📦 Configurando aplicación..."

if [ ! -d "deps" ]; then
    echo "→ Instalando dependencias..."
    mix deps.get
else
    echo "✓ Dependencias ya instaladas"
fi

if [ ! -d "assets/node_modules" ]; then
    echo "→ Configurando assets..."
    mix assets.setup
else
    echo "✓ Assets ya configurados"
fi

echo "→ Compilando assets..."
mix assets.build

echo "✓ Assets compilados"
echo

echo "╔════════════════════════════════════════╗"
echo "║  Levantando servidor (modo interactivo)║"
echo "╚════════════════════════════════════════╝"
echo

echo "📡 Configuración del servidor:"
echo "  Host: ${PHX_HOST}"
echo "  Port: ${PHX_PORT}"
echo "  URL: http://${PHX_HOST}:${PHX_PORT}"
echo "  Dashboard: http://${PHX_HOST}:${PHX_PORT}/dev/dashboard"
echo

echo "✓ Presiona Ctrl+C para detener el servidor"
echo

iex -S mix phx.server

