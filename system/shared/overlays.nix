self: super: {
  customBin = with self; {
    gong = pkgs.stdenv.mkDerivation {
      name = "gong";
      src = pkgs.fetchurl {
        url = "https://github.com/KensoDev/gong/releases/download/1.7.0/gong_darwin_amd64";
        sha256 = "1gdgwj700sm0xvgc7iga45ayxc40bx9gkrkcy933szccvi43nk44";
      };
      phases = ["installPhase" "patchPhase"];
      installPhase = ''
        mkdir -p $out/bin
        cp $src $out/bin/gong
        chmod +x $out/bin/gong
      '';
    };

    reattach-to-user-namespace = stdenv.mkDerivation {
      name = "reattach-to-user-namespace";

      src = fetchFromGitHub {
        owner = "ChrisJohnsen";
        repo = "tmux-MacOSX-pasteboard";
        rev = "v2.9";
        sha256 = "1qgimh58hcx5f646gj2kpd36ayvrdkw616ad8cb3lcm11kg0ag79";
      };

      buildFlags =
        if stdenv.hostPlatform.system == "x86_64-darwin" then [ "ARCHES=x86_64" ]
        else if stdenv.hostPlatform.system == "aarch64-darwin" then [ "ARCHES=arm64" ]
        else throw "reattach-to-user-namespace isn't being built for ${stdenv.hostPlatform.system} yet.";

      installPhase = ''
        mkdir -p $out/bin
        cp reattach-to-user-namespace $out/bin/
      '';

      meta = with lib; {
        description = "A wrapper that provides access to the Mac OS X pasteboard service";
        license = licenses.bsd2;
        maintainers = with maintainers; [ lnl7 ];
        platforms = platforms.darwin;
      };
    };
  };

  customBat = with self; {
    catppuccin = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "bat";
      rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
      sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
    };
  };

  customRofi = with self; {
    catppuccin = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "rofi";
      rev = "5350da41a11814f950c3354f090b90d4674a95ce";
      sha256 = "sha256-DNorfyl3C4RBclF2KDgwvQQwixpTwSRu7fIvihPN8JY=";
    };
  };

  customTmux = with self; {
    dracula = pkgs.tmuxPlugins.mkTmuxPlugin {
      pluginName = "dracula";
      src = pkgs.fetchFromGitHub {
        owner = "dracula";
        repo = "tmux";
        rev = "v2.1.0";
        sha256 = "sha256-89S8LHTx2gYWj+Ejws5f6YRQgoj0rYE7ITtGtZibl30=";
      };
      version = "2.1.0";
    };
  };

  customZsh = with self; {
    zsh-z = pkgs.fetchFromGitHub {
      owner = "agkozak";
      repo = "zsh-z";
      rev = "82f5088641862d0e83561bb251fb60808791c76a";
      sha256 = "sha256-6BNYzfTcjWm+0lJC83IdLxHwwG4/DKet2QNDvVBR6Eo=";
    };
  };
}
