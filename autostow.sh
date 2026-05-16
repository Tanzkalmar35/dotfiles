#!/bin/bash
# stow.sh — restow base and active theme
# run this whenever you change a config file during setup

DOTFILES="$HOME/dotfiles"
CURRENT=$(cat "$DOTFILES/.current-theme" 2>/dev/null)

# ── helpers ───────────────────────────────────────────────────────────────────

usage() {
  echo "Usage: stow.sh [--base] [--theme] [--all] [--pkg <name>]"
  echo ""
  echo "  --base        restow all base packages"
  echo "  --theme       restow active theme ($CURRENT)"
  echo "  --all         restow base + active theme (default)"
  echo "  --pkg <name>  restow a single base package by name (e.g. alacritty)"
  exit 0
}

stow_pkg() {
  local dir="$1"
  local pkg="$2"
  echo "  stowing $pkg"
  stow --no-folding -d "$dir" -t ~ -D "$pkg" 2>/dev/null  # unstow first (idempotent)
  stow --no-folding -d "$dir" -t ~ "$pkg"
}

stow_base() {
  echo "→ stowing base"
  for pkg in $DOTFILES/base/*/; do
    stow_pkg "$DOTFILES/base" "$(basename "$pkg")"
  done
}

stow_theme() {
  if [ -z "$CURRENT" ]; then
    echo "✗ no active theme found — run switch-theme.sh first"
    exit 1
  fi
  echo "→ stowing theme: $CURRENT"
  stow_pkg "$DOTFILES/themes" "$CURRENT"
}

# ── args ──────────────────────────────────────────────────────────────────────

case "$1" in
  --base)       stow_base ;;
  --theme)      stow_theme ;;
  --all | "")   stow_base && stow_theme ;;
  --pkg)
    [ -z "$2" ] && { echo "✗ --pkg requires a package name"; exit 1; }
    stow_pkg "$DOTFILES/base" "$2"
    ;;
  --help | -h)  usage ;;
  *)            echo "✗ unknown option: $1"; usage ;;
esac

echo "✓ done"
