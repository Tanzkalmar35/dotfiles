# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Supports multiple themes with a single switch script and a polybar theme picker.

---

## Stack

| App       | Purpose                        |
|-----------|--------------------------------|
| i3        | window manager                 |
| polybar   | status bar + theme picker      |
| alacritty | terminal                       |
| neovim    | editor                         |
| tmux      | terminal multiplexer           |
| rofi      | app launcher + theme switcher  |
| picom     | compositor                     |
| dunst     | notifications                  |
| nushell   | shell                          |

Current theme: **Kanagawa Dragon**

---

## Repository Structure

```
~/dotfiles/
│
├── base/                          # logic configs, stowed once
│   ├── alacritty/.config/alacritty/
│   │   └── alacritty.toml         # imports colors.toml from active theme
│   ├── dunst/.config/dunst/
│   │   └── dunstrc                # imports colors.dunstrc from active theme
│   ├── nvim/.config/nvim/
│   │   ├── init.lua               # requires("theme")
│   │   └── lua/                   # plugins, keymaps, etc.
│   ├── picom/.config/picom/
│   │   └── picom.conf
│   ├── polybar/.config/polybar/
│   │   ├── launch.sh
│   │   └── theme-picker.sh
│   ├── rofi/.config/rofi/
│   │   ├── config.rasi            # imports colors.rasi from active theme
│   │   └── app-launcher/
│   │       └── launcher.sh
│   ├── tmux/.config/tmux/
│   │   └── tmux.conf              # sources colors.conf from active theme
│   └── nushell/
│
├── themes/
│   └── kanagawa-dragon/           # one folder per theme
│       └── .config/               # maps directly to ~/.config/
│           ├── alacritty/
│           │   └── colors.toml
│           ├── dunst/
│           │   └── colors.dunstrc
│           ├── i3/
│           │   └── config         # i3 is fully per-theme (colors too intertwined)
│           ├── nvim/lua/
│           │   └── theme.lua
│           ├── polybar/
│           │   └── config.ini     # polybar is fully per-theme
│           ├── rofi/
│           │   └── colors.rasi
│           └── tmux/
│               └── colors.conf
│
├── autostow.sh                    # stow helper script
├── switch-theme.sh                # theme switcher
└── .current-theme                 # tracks active theme (auto-managed)
```

### The split: base vs theme

Most apps follow this pattern — base config has all logic and sources one file from the active theme:

| App       | Base sources                                          | Theme provides  |
|-----------|-------------------------------------------------------|-----------------|
| alacritty | `import = ["~/.config/alacritty/colors.toml"]`        | `colors.toml`   |
| tmux      | `source-file ~/.config/tmux/colors.conf`              | `colors.conf`   |
| rofi      | `@import "~/.config/rofi/colors.rasi"`                | `colors.rasi`   |
| dunst     | reads all `*.dunstrc` in dir automatically            | `colors.dunstrc`|
| neovim    | `require("theme")`                                    | `theme.lua`     |
| i3        | fully per-theme                                       | `config`        |
| polybar   | fully per-theme                                       | `config.ini`    |

---

## Setting Up on a New Machine

### 1. Install dependencies

```bash
sudo pacman -S stow git i3 polybar alacritty neovim tmux rofi picom dunst \
               feh nushell papirus-icon-theme ttf-jetbrains-mono-nerd
```

### 2. Clone the repo

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
```

### 3. Set the active theme

```bash
echo "kanagawa-dragon" > ~/dotfiles/.current-theme
```

### 4. Back up any existing configs that would conflict

```bash
mv ~/.config/alacritty ~/.config/alacritty.bak
mv ~/.config/i3        ~/.config/i3.bak
mv ~/.config/polybar   ~/.config/polybar.bak
# etc. for any app already configured
```

### 5. Stow everything

```bash
chmod +x ~/dotfiles/autostow.sh ~/dotfiles/switch-theme.sh
~/dotfiles/autostow.sh --all
```

### 6. Make scripts executable

```bash
chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/polybar/theme-picker.sh
chmod +x ~/.config/rofi/app-launcher/launcher.sh
```

### 7. Restart i3

Log out and back in, or press `$mod+Shift+r` to reload i3.

---

## Switching Themes

**Via polybar** — click the theme icon (󰏘) on the far left of the bar. A rofi menu lists all available themes.

**Via terminal:**

```bash
~/dotfiles/switch-theme.sh kanagawa-dragon
```

The switch script automatically:
1. Unstows the current theme
2. Stows the new one
3. Reloads polybar, picom, dunst, tmux, neovim, and i3

---

## The autostow Script

```bash
~/dotfiles/autostow.sh            # restow base + active theme (default)
~/dotfiles/autostow.sh --base     # only base packages
~/dotfiles/autostow.sh --theme    # only active theme
~/dotfiles/autostow.sh --pkg nvim # single base package
```

Safe to run at any time — it unstows before restowing so it's always idempotent.

---

## Adding a New Theme

1. Copy an existing theme as a starting point:
   ```bash
   cp -r ~/dotfiles/themes/kanagawa-dragon ~/dotfiles/themes/mytheme
   ```

2. Edit the color values in each file under `mytheme/.config/`.

3. Switch to it:
   ```bash
   ~/dotfiles/switch-theme.sh mytheme
   ```

The new theme automatically appears in the polybar picker.

---

## Neovim — Live Theme Switching

To enable live theme switching in running neovim instances, add this to your `init.lua`:

```lua
vim.fn.serverstart('/tmp/nvim.sock')
```

The switch script sends a `:source` command to this socket when themes change.

To fix the line number column background not matching the theme, add this to `theme.lua` after setting the colorscheme:

```lua
vim.cmd.colorscheme("kanagawa-dragon")

vim.api.nvim_set_hl(0, "SignColumn",   { bg = "#181616" })
vim.api.nvim_set_hl(0, "LineNr",       { fg = "#2d4f67", bg = "#181616" })
vim.api.nvim_set_hl(0, "LineNrAbove",  { fg = "#2d4f67", bg = "#181616" })
vim.api.nvim_set_hl(0, "LineNrBelow",  { fg = "#2d4f67", bg = "#181616" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#7fb4ca", bg = "#181616", bold = true })
```

---

## Troubleshooting

**Stow conflict: "existing target is not owned by stow"**
A real directory exists where stow wants to place a symlink. Remove it first:
```bash
rm -rf ~/.config/appname
~/dotfiles/autostow.sh --pkg appname
```

**Stow folding issue — theme conflicts with base**
Always use `--no-folding`. The autostow script handles this automatically. If you ran stow manually without it, unstow and restow via autostow.sh.

**Theme picker shows no themes**
Check that `~/dotfiles/.current-theme` exists:
```bash
cat ~/dotfiles/.current-theme
```

**Picom errors on launch**
Run manually to see output:
```bash
pkill picom && picom --config ~/.config/picom/picom.conf
```

**Check what's currently symlinked**
```bash
ls -la ~/.config/alacritty   # should show symlinks into ~/dotfiles
```

**Dry run stow without applying**
```bash
stow --no-folding -d ~/dotfiles/base -t ~ -n -v nvim
```
