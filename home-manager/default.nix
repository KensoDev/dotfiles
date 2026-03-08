{ config, lib, pkgs, ... }:

{
  imports = [
    ./programs/git.nix
    ./programs/tmux.nix
  ];

  #---------------------------------------------------------------------
  # home
  #---------------------------------------------------------------------
  home.packages = (import ./packages.nix) { inherit pkgs; };

  home.sessionVariables = {
    CHARM_HOST = "localhost";
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
  };

  home.stateVersion = "22.05";

  #---------------------------------------------------------------------
  # programs
  #---------------------------------------------------------------------

  programs.bat = {
    enable = true;
    config = { theme = "catppuccin"; };
  };

  programs.go = {
    enable = true;
    env.GOPATH = "Development/language/go";
  };

  # Ghostty configuration (installed externally, not via Nix)
  xdg.configFile."ghostty/config".text = ''
    # Theme
    theme = dracula

    # Font settings
    font-family = "JetBrainsMono Nerd Font Mono"
    font-size = 22

    # Window settings - matching Alacritty
    window-width = 100
    window-height = 85
    window-padding-x = 5
    window-padding-y = 5
    window-decoration = true

    # Scrollback - much longer history
    scrollback-limit = 100000

    # Use fish shell
    command = ${pkgs.fish}/bin/fish

    # Additional recommended settings
    confirm-close-surface = false
    macos-titlebar-style = transparent

    # Keybindings
    keybind = super+v=paste_from_clipboard
  '';

  # Dracula theme for Ghostty
  xdg.configFile."ghostty/themes/dracula".text = ''
    # Dracula theme
    background = 282a36
    foreground = f8f8f2
    cursor-color = f8f8f2
    selection-background = 44475a
    selection-foreground = f8f8f2

    # Black
    palette = 0=#21222c
    palette = 8=#6272a4

    # Red
    palette = 1=#ff5555
    palette = 9=#ff6e6e

    # Green
    palette = 2=#50fa7b
    palette = 10=#69ff94

    # Yellow
    palette = 3=#f1fa8c
    palette = 11=#ffffa5

    # Blue
    palette = 4=#bd93f9
    palette = 12=#d6acff

    # Magenta
    palette = 5=#ff79c6
    palette = 13=#ff92df

    # Cyan
    palette = 6=#8be9fd
    palette = 14=#a4ffff

    # White
    palette = 7=#f8f8f2
    palette = 15=#ffffff
  '';

  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        pagers = [
          {
            colorArg = "always";
            pager = "delta --color-only --dark --paging=never";
            useConfig = false;
          }
        ];
      };
    };
  };

  # lazydocker configuration with vim keybindings
  xdg.configFile."lazydocker/config.yml".text = ''
    gui:
      scrollHeight: 2
      language: 'en'
      theme:
        activeBorderColor:
          - green
          - bold
        inactiveBorderColor:
          - white
        optionsTextColor:
          - blue
      returnImmediately: false
      wrapMainPanel: true
    confirmOnQuit: false
    keybinding:
      # Vim-style navigation
      scrollDown: 'j'
      scrollUp: 'k'
      prevPanel: 'h'
      nextPanel: 'l'
      gotoTop: 'g'
      gotoBottom: 'G'
      prevScreen: 'H'
      nextScreen: 'L'
      # Container actions
      open: '<enter>'
      remove: 'd'
      forceRemove: 'D'
      restart: 'r'
      stop: 's'
      exec: 'e'
      viewLogs: 'v'
      # Global
      quit: 'q'
      toggleHelp: '?'
  '';

  programs.neovim = {
    enable = true;
    package = pkgs.neovim;

    
    plugins = with pkgs; [
      # languages
      vimPlugins.nvim-lspconfig
      vimPlugins.vim-nix
      vimPlugins.vim-prisma
      vimPlugins.vim-terraform

      # treesitter
      vimPlugins.nvim-treesitter

      # completion
      vimPlugins.cmp-buffer
      vimPlugins.cmp-cmdline
      vimPlugins.cmp-nvim-lsp
      vimPlugins.cmp-path
      vimPlugins.cmp-tabnine
      vimPlugins.cmp-treesitter
      vimPlugins.cmp-vsnip
      vimPlugins.lspkind-nvim
      vimPlugins.nvim-cmp
      vimPlugins.vim-vsnip

      # telescope
      vimPlugins.plenary-nvim
      vimPlugins.popup-nvim
      vimPlugins.telescope-nvim

      # theme
      vimPlugins.dracula-nvim

      # floaterm
      vimPlugins.vim-floaterm

      # extras
      vimPlugins.gitsigns-nvim
      vimPlugins.indent-blankline-nvim
      vimPlugins.lsp-colors-nvim
      vimPlugins.lsp_lines-nvim
      vimPlugins.lualine-nvim
      vimPlugins.nerdcommenter
      vimPlugins.nvim-treesitter-context
      vimPlugins.nvim-web-devicons
      vimPlugins.nerdtree
    ];
  };

  xdg.configFile."nvim" = {
    source = ../config/nvim;
    recursive = true;
    force = true; # optional — overwrites existing ~/.config/nvim
  };

  # Fish prompt functions
  xdg.configFile."fish/functions/fish_prompt.fish".text = ''
    function fish_prompt
        set -l last_status $status

        # Arrow (green if success, red if error)
        if test $last_status -eq 0
            echo -n (set_color green)'➜ '(set_color normal)
        else
            echo -n (set_color red)'➜ '(set_color normal)
        end

        # Directory name only (cyan)
        echo -n (set_color cyan)(basename (pwd))(set_color normal)

        # Git branch if in a git repo (magenta)
        if git rev-parse --git-dir >/dev/null 2>&1
            set -l branch (git branch --show-current 2>/dev/null; or git rev-parse --short HEAD 2>/dev/null)
            if test -n "$branch"
                echo -n (set_color brmagenta)' git:('$branch')'(set_color normal)
            end
        end

        echo -n ' '
    end
  '';

  xdg.configFile."fish/functions/fish_right_prompt.fish".text = ''
    function fish_right_prompt
        # Empty right prompt
    end
  '';

  programs.fish = {
    enable = true;

    loginShellInit = ''
      # Add home-manager and nix paths
      fish_add_path --prepend --move ~/.nix-profile/bin
      fish_add_path --prepend --move ~/.local/state/home-manager/gcroots/current-home/home-path/bin
      fish_add_path --prepend --move /run/current-system/sw/bin
      fish_add_path --append --move $HOME/Development/language/go/bin
    '';

    shellAliases = {
      cat = "bat";
      fetch = "git fetch --all --jobs=4 --progress --prune";
      git-sync = "git stash;fetch;git checkout master; git reset --hard origin/master";
      git-sync-main = "git stash;fetch;git checkout main; git reset --hard origin/main";
      pull = "git pull --autostash --jobs=4 --summary origin";
      rebase = "git rebase --autostash --stat";
      secrets = ''doppler run --project "(whoami)"'';
      update = "fetch && rebase";
      wt = "git worktree";
      git = "hub";
      dev = "nix develop . -c $SHELL";
      develop = "nix develop . -c $SHELL";
    };

    interactiveShellInit = ''
      # Set fish colors to dracula-like theme
      set -g fish_color_autosuggestion 6272a4
      set -g fish_color_command f8f8f2
      set -g fish_color_comment 6272a4
      set -g fish_color_end 50fa7b
      set -g fish_color_error ff5555
      set -g fish_color_param bd93f9
      set -g fish_color_quote f1fa8c

      # venv activation helper - use activate.fish for fish shell
      function venv
        if test -f .venv/bin/activate.fish
          source .venv/bin/activate.fish
        else if test -f ./.venv/bin/activate.fish
          source ./.venv/bin/activate.fish
        else
          echo "No virtual environment found in .venv/"
        end
      end

      # Set very long history - 1 million commands
      set -g fish_history_max_sessions 1000000

      # Disable tide and use custom robbyrussell-style prompt
      set -U tide_left_prompt_items
      set -U tide_right_prompt_items
    '';

    plugins = [
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
          sha256 = "sha256-+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
        };
      }
      {
        name = "tide";
        src = pkgs.fetchFromGitHub {
          owner = "IlanCosman";
          repo = "tide";
          rev = "v6.1.1";
          sha256 = "sha256-ZyEk/WoxdX5Fr2kXRERQS1U1QHH3oVSyBQvlwYnEYyc=";
        };
      }
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };

    shellAliases = {
      cat = "bat";
      fetch = "git fetch --all --jobs=4 --progress --prune";
      git-sync = "git stash;fetch;git checkout master; git reset --hard origin/master";
      git-sync-main = "git stash;fetch;git checkout main; git reset --hard origin/main";
      pull = "git pull --autostash --jobs=4 --summary origin";
      rebase = "git rebase --autostash --stat";
      secrets = ''doppler run --project "$(whoami)"'';
      update = "fetch && rebase";
      wt = "git worktree";
      git = "hub";
      dev = "nix develop . -c $SHELL";
      develop = "nix develop . -c $SHELL";
    };

    plugins = [{
      name = "zsh-z";
      src = pkgs.customZsh.zsh-z;
    }];
  };
}
