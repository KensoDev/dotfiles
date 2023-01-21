{ config, lib, pkgs, ... }:

let isDarwin = pkgs.system == "x86_64-darwin";
in {
  #---------------------------------------------------------------------
  # home
  #---------------------------------------------------------------------

  home.file.".config/nvim/after/ftplugin/markdown.vim".text = ''
    setlocal wrap
  '';

  home.packages = (import ./packages.nix) { inherit pkgs; };

  home.sessionVariables = {
    CHARM_HOST = "localhost";
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    PATH = "$PATH:$GOPATH/bin";
    PULUMI_K8S_SUPPRESS_HELM_HOOK_WARNINGS = "true";
    PULUMI_SKIP_UPDATE_CHECK = "true";
  };

  home.stateVersion = "22.05";

  #---------------------------------------------------------------------
  # programs
  #---------------------------------------------------------------------

  programs.bat = {
    enable = true;
    config = { theme = "catppuccin"; };
    themes = {
      catppuccin = builtins.readFile
        (pkgs.customBat.catppuccin + "/Catppuccin-macchiato.tmTheme");
    };
  };

  programs.bottom.enable = true;

  programs.go = {
    enable = true;
    goPath = "Development/language/go";
  };

  programs.git = {
    delta = {
      enable = true;
      options = {
        chameleon = {
          dark = true;
          line-numbers = true;
          side-by-side = true;
          keep-plus-minus-markers = true;
          syntax-theme = "Nord";
          file-style = "#434C5E bold";
          file-decoration-style = "#434C5E ul";
          file-added-label = "[+]";
          file-copied-label = "[==]";
          file-modified-label = "[*]";
          file-removed-label = "[-]";
          file-renamed-label = "[->]";
          hunk-header-style = "omit";
          line-numbers-left-format = " {nm:>1} │";
          line-numbers-left-style = "red";
          line-numbers-right-format = " {np:>1} │";
          line-numbers-right-style = "green";
          line-numbers-minus-style = "red italic black";
          line-numbers-plus-style = "green italic black";
          line-numbers-zero-style = "#434C5E italic";
          minus-style = "bold red";
          minus-emph-style = "bold red";
          plus-style = "bold green";
          plus-emph-style = "bold green";
          zero-style = "syntax";
          blame-code-style = "syntax";
          blame-format = "{author:<18} ({commit:>7}) {timestamp:^12} ";
          blame-palette = "#2E3440 #3B4252 #434C5E #4C566A";
        };
        features = "chameleon";
        side-by-side = true;
      };
    };

    enable = true;
    userEmail = "avi@kensodev.com";
    userName = "Avi Zurel";

    aliases = {
      s = "status";
      st = "status";
    };

    extraConfig = {
      color = {
        ui = true;
        status = "auto";
        diff = "auto";
        branch = "auto";
      };
      push = {
        default = "current";
        autoSetupRemote = true;
      };
      diff.colorMoved = "zebra";
      fetch.prune = true;
      github.user = "KensoDev";
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      rebase.autoStash = true;
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        dimensions = {
          columns = 100;
          lines = 85;
        };
        padding = {
          x = 5;
          y = 5;
        };
        dynamic_padding = false;

        decorations = "buttonless";

        startup_mode = "windowed";
      };

      scrolling = {
        history = 0;
        multiplier = 3;

      };

      font = {
        size = 18;

        bold = {
          style = "Retina";
          family = "FuraCode Nerd Font";
        };

        italic = {
          style = "Retina";
          family = "FuraCode Nerd Font";
        };

        normal = {
          style = "Medium";
          family = "FuraCode Nerd Font";
        };

        offset = {
          y = 0;
          x = 0;
        };
      };

      offset = {                            # Positioning
        x = -1;
        y = 0;
      };

      glyff_offset = {
        x = 0;
        y = 0;
      };
    };


  };


  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --color-only --dark --paging=never";
          useConfig = false;
        };
      };
    };
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;

    plugins = with pkgs; [
      # languages
      customVim.vim-just
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
      vimPlugins.catppuccin-nvim

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

      # configuration
      customVim.thealtf4stream
    ];

    extraConfig = ''
      lua << EOF
        require 'KensoDev'.init()
      EOF
    '';
  };

  programs.nnn.enable = true;

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set-option -a terminal-overrides ",*256col*:RGB"
      #
      # Setting the prefix from C-b to C-s
      set -g prefix C-a
      set-option -g default-command "reattach-to-user-namespace -l zsh"
      
      # Free the original Ctrl-b prefix keybinding
      unbind C-b
      #setting the delay between prefix and command
      set -sg escape-time 1
      # Ensure that we can send Ctrl-S to other apps
      bind C-s send-prefix
      # Set the base index for windows to 1 instead of 0
      set -g base-index 1
      # Set the base index for panes to 1 instead of 0
      setw -g pane-base-index 1
      # splitting panes
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      
      # Reload the file with Prefix r
      bind R source-file ~/.tmux.conf \; display "Reloaded!"
      bind r command-prompt -I "#W" "rename-window '%%'"
      
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      # Moving between windows, gnome-terminal style
      bind -n C-PgUp select-window -t :-
      bind -n C-PgDn select-window -t :+
      
      bind Right select-window -t :-
      bind Left select-window -t :+
      
      # open new window gnome-terminal style
      bind -n C-T new-window -c "#{pane_current_path}"
      set-window-option -g xterm-keys on
      
      # move windows forward and backwards, gnome-terminal style
      bind-key -n C-S-Left swap-window -t -1
      bind-key -n C-S-Right swap-window -t +1
      
      # use the mouse
      set-window-option -g mode-mouse on
      set -g mouse-select-pane on
      set -g mouse-resize-pane on
      set -g mouse-select-window on
      
      # use vim-bindings for copying and pasting text
      unbind [
      bind Escape copy-mode
      
      # use vim-bindings for copying and pasting text
      unbind [
      bind Escape copy-mode
      unbind p
      
      bind-key -Tcopy-mode-vi 'v' send -X begin-selection
      bind-key -Tcopy-mode-vi 'y' send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
      
      bind y run 'tmux save-buffer - | reattach-to-user-namespace pbcopy '
      bind C-y run 'tmux save-buffer - | reattach-to-user-namespace pbcopy '
      
      
      #unbind p
      #bind p run "xclip -o | tmux load-buffer - ; tmux paste-buffer"
      #bind-key -t vi-copy 'v' begin-selection
      ## see http://unix.stackexchange.com/questions/131011/use-system-clipboard-in-vi-copy-mode-in-tmux
      #bind-key -t vi-copy 'y' save-buffer
      #bind -t vi-copy y copy-pipe 'xclip -i'
      #bind -t vi-copy V rectangle-toggle
      
      # end corentin
      
      # Pane resizing
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      # Set the default terminal mode to 256color mode
      set -g default-terminal "screen-256color"
      # enable activity alerts
      setw -g monitor-activity on
      set -g visual-activity on
      # set the status line's colors
      set -g status-fg white
      set -g status-bg black
      # set the color of the window list
      setw -g window-status-fg cyan
      setw -g window-status-bg default
      setw -g window-status-attr dim
      # set colors for the active window
      setw -g window-status-current-fg white
      setw -g window-status-current-bg red
      setw -g window-status-current-attr bright
      # pane
      set -g pane-border-fg green
      set -g pane-border-bg black
      set -g pane-active-border-fg white
      set -g pane-active-border-bg yellow
      # Command / message line
      set -g message-fg white
      set -g message-bg black
      set -g message-attr bright
      # Status line left side
      set -g status-left-length 40
      set -g status-left "#[fg=green]Session: #S #[fg=yellow]#I #[fg=cyan]#P"
      set -g status-utf8 on
      # Status line right side
      # 15% | 28 Nov 18:15
      #set -g status-right "#(~/battery Discharging) | #[fg=cyan]%d %b %R"
      # Center the window list
      set -g status-justify centre
      # enable vi keys.
      setw -g mode-keys vi
      # Open panes in the same directory using the tmux-panes script
      #unbind v
      #unbind n
      #bind v send-keys " ~/tmux-panes -h" C-m
      #bind n send-keys " ~/tmux-panes -v" C-m
      # Maximize and restore a pane
      #unbind Up
      #bind Up new-window -d -n tmp \; swap-pane -s tmp.1 \; select-window -t tmp
      #unbind Down
      #bind Down last-window \; swap-pane -s tmp.1 \; kill-window -t tmp
      #
      # Log output to a text file on demand
      bind P pipe-pane -o "cat >>~/#W.log" \; display "Toggled logging to ~/#W.log"
      
      
      set-window-option -g automatic-rename off
      set -g allow-rename on
      set-option -g status-interval 1
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_path}'
      
      set-option -g history-limit 3000
      
      set-option -g status-position top
      
      #new-window
      new-session
    '';

    plugins = with pkgs; [ customTmux.catppuccin ];
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = if isDarwin then "screen-256color" else "xterm-256color";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };

    shellAliases = {

      cat = "bat";
      fetch = "git fetch --all --jobs=4 --progress --prune";
      ll = "n -Hde";
      pull = "git pull --autostash --jobs=4 --summary origin";
      rebase = "git rebase --autostash --stat";
      secrets = ''doppler run --project "$(whoami)"'';
      update = "fetch && rebase";
      wt = "git worktree";
    };

    plugins = [{
      name = "zsh-z";
      src = pkgs.customZsh.zsh-z;
    }];

    initExtra = ''
      kindc () {
        cat <<EOF | kind create cluster --config=-
      kind: Cluster
      apiVersion: kind.x-k8s.io/v1alpha4
      nodes:
      - role: control-plane
        kubeadmConfigPatches:
        - |
          kind: InitConfiguration
          nodeRegistration:
            kubeletExtraArgs:
              node-labels: "ingress-ready=true"
        extraPortMappings:
        - containerPort: 80
          hostPort: 80
          protocol: TCP
        - containerPort: 443
          hostPort: 443
          protocol: TCP
      EOF
      }

      n () {
        if [ -n $NNNLVL ] && [ "$NNNLVL" -ge 1 ]; then
          echo "nnn is already running"
          return
        fi

        export NNN_TMPFILE="$HOME/.config/nnn/.lastd"

        nnn "$@"

        if [ -f "$NNN_TMPFILE" ]; then
          . "$NNN_TMPFILE"
          rm -f "$NNN_TMPFILE" > /dev/null
        fi
      }
    '';
  };
}
