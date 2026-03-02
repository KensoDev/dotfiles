# dotfiles

These are my current dotfiles, built with Nix and managed with home-manager.

## What's included

### Terminal setup
- **Alacritty** - terminal with Dracula theme
- **Tmux** - prefix set to C-s, using gnome-terminal style window navigation
- **Zsh** - oh-my-zsh with robbyrussell theme, custom shell functions

### Development tools
- **Neovim** - LSP, treesitter, telescope, Dracula theme
- **Git** - delta for diffs with chameleon theme, custom aliases
- **Go** - GOPATH set to ~/Development/language/go
- **Lazygit** - delta integration for paging

### Utilities
- bat (catppuccin theme)
- bottom
- nnn
- httpie
- ngrok
- ack

## Structure

```
.
├── config/
│   └── nvim/              # Neovim config (lua)
├── home-manager/
│   ├── default.nix        # Main home-manager config
│   ├── packages.nix       # Package definitions
│   ├── nixos.nix          # NixOS specific settings
│   └── programs/
│       ├── git.nix        # Git and delta config
│       └── tmux.nix       # Tmux config
└── system/
    └── shared/
        ├── nix.nix
        ├── overlays.nix
        └── systemPackages.nix
```

## Key features

### Git with delta
Side-by-side diffs with syntax highlighting, using Nord colors and custom file labels

### Tmux keybindings
- Prefix: C-s
- Split panes: prefix + / and prefix + -
- Move windows: Ctrl+Shift+Left/Right
- Reload config: prefix + r

### Shell aliases
- `cat` → bat
- `ll` → nnn
- `git` → hub
- Custom git workflows: `git-sync`, `git-sync-main`, `fetch`, `update`

## Setup

Copy the git user config template and fill in your details:

```bash
cp home-manager/programs/git-user.nix.example home-manager/programs/git-user.nix
```

Edit `home-manager/programs/git-user.nix` with your personal information.

Apply the configuration (replace `macbookpro-work` with your profile name):

```bash
sudo darwin-rebuild switch --flake '.#macbookpro-work' --max-jobs auto --cores 0 --print-build-logs --show-trace
```

## Platform

Running on macOS (darwin)

## Credits

Originally taken from https://github.com/ALT-F4-LLC/dotfiles-nixos
