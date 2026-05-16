#!/bin/bash
# switch-theme.sh — unstow old theme, stow new one, reload all apps

DOTFILES="$HOME/dotfiles"
THEMES_DIR="$DOTFILES/themes"
CURRENT_FILE="$DOTFILES/.current-theme"
THEME="$1"

# ── guards ────────────────────────────────────────────────────────────────────

if [ -z "$THEME" ]; then
  echo "Usage: switch-theme.sh <theme>"
  echo "Available: $(ls "$THEMES_DIR" | tr '\n' ' ')"
  echo "Current:   $(cat "$CURRENT_FILE" 2>/dev/null || echo 'none')"
  exit 1
fi

if [ ! -d "$THEMES_DIR/$THEME" ]; then
  echo "Error: theme '$THEME' not found in $THEMES_DIR"
  exit 1
fi

CURRENT=$(cat "$CURRENT_FILE" 2>/dev/null)

if [ "$CURRENT" = "$THEME" ]; then
  echo "Already on theme: $THEME"
  exit 0
fi

# ── stow ─────────────────────────────────────────────────────────────────────

echo "→ removing theme: $CURRENT"
[ -n "$CURRENT" ] && stow --no-folding -d "$THEMES_DIR" -t ~ -D "$CURRENT" 2>/dev/null

echo "→ applying theme: $THEME"
stow --no-folding -d "$THEMES_DIR" -t ~ "$THEME"
echo "$THEME" > "$CURRENT_FILE"

# ── reload apps ───────────────────────────────────────────────────────────────

# polybar
echo "→ reloading polybar"
pkill polybar
sleep 0.2
~/.config/polybar/launch.sh &

# picom
echo "→ reloading picom"
pkill picom
sleep 0.2
picom --config ~/.config/picom/picom.conf &

# dunst
echo "→ reloading dunst"
pkill dunst
sleep 0.2
dunst &

# tmux
echo "→ reloading tmux"
tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null

# neovim — send colorscheme to all running instances
echo "→ reloading neovim"
for sock in /tmp/nvim.*/0 /tmp/nvim*.sock; do
  [ -S "$sock" ] && nvim --server "$sock" --remote-send ":source ~/.config/nvim/lua/theme.lua<CR>" 2>/dev/null
done

# rofi — no daemon, picks up config on next launch automatically

# i3 — reload to pick up new colors
echo "→ reloading i3"
i3-msg reload

# notify
sleep 0.5
notify-send "theme switched" "$THEME" --urgency=low

echo "✓ done — active theme: $THEME"
