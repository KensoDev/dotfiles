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
  };

  programs.bottom.enable = true;

  programs.go = {
    enable = true;
    goPath = "Development/language/go";
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
        size = 24;

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
      vimPlugins.nerdtree
    ];
  };

  xdg.configFile."nvim" = {
    source = ../config/nvim;
    recursive = true;
    force = true; # optional — overwrites existing ~/.config/nvim
  };

  programs.nnn.enable = true;

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
      ll = "n -Hde";
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
