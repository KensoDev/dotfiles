# dotfiles

These are my current dotfiles, built with Nix and managed with home-manager.

## What's included

### Terminal setup
- **Ghostty** - terminal with Dracula theme (installed externally, configured via Nix)
- **Tmux** - prefix set to C-s, using gnome-terminal style window navigation
- **Fish** - custom robbyrussell-style prompt with z plugin

### Development tools
- **Neovim** - LSP, treesitter, telescope, Dracula theme
- **Git** - delta for diffs with chameleon theme, custom aliases
- **Go** - GOPATH set to ~/Development/language/go
- **Lazygit** - delta integration for paging

### Utilities
- bat (catppuccin theme)
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
- `git` → hub
- Custom git workflows: `git-sync`, `git-sync-main`, `fetch`, `update`

## Setup

### 1. Configure git user information

Copy the git user config template to `~/.config/` and fill in your details:

```bash
cp home-manager/programs/git-user.nix.example ~/.config/git-user.nix
```

Edit `~/.config/git-user.nix` with your personal information (name, email, GitHub username).

**Why ~/.config?** The git user config is stored outside the flake directory to keep your personal information private and prevent it from being committed to the repository. Nix flakes only include git-tracked files by default, so storing secrets outside the flake is the standard pattern for machine-specific configuration.

### 2. Apply the configuration

Replace `macbookpro-work` with your profile name:

```bash
sudo darwin-rebuild switch --flake '.#macbookpro-work' --impure
```

**Why --impure?** Nix flakes run in pure evaluation mode by default, which restricts access to files outside the flake directory. The `--impure` flag allows Nix to read your git user config from `~/.config/git-user.nix`. This is necessary for importing machine-specific secrets that should not be tracked in git.

## Platform

Running on macOS (darwin)

## Credits

Originally taken from https://github.com/ALT-F4-LLC/dotfiles-nixos
