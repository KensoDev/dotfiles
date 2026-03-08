self: super: {
  customBin = with self; {
    gong = pkgs.stdenv.mkDerivation {
      name = "gong-2.5.0";
      src = pkgs.fetchurl {
        url = "https://github.com/KensoDev/gong/releases/download/v2.5.0/gong_2.5.0_Darwin_arm64.tar.gz";
        sha256 = "02k2jxi8kk1sj01b5kh4dbw00dfx0fmdvlyv2chwfjpk8v1f262c";
      };
      sourceRoot = ".";
      installPhase = ''
        mkdir -p $out/bin
        cp gong $out/bin/gong
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

      # Patch for macOS compatibility
      postPatch = if stdenv.isDarwin then ''
        # Replace Linux-specific network_bandwidth.sh with macOS-compatible version
        cat > scripts/network_bandwidth.sh << 'EOF'
#!/usr/bin/env bash
# macOS-compatible network bandwidth monitor for tmux Dracula theme

INTERVAL="1"  # update interval in seconds

# Get network interface from tmux option, default to en0
network_name=$(tmux show-option -gqv "@dracula-network-bandwidth")
if [ -z "$network_name" ]; then
    # Auto-detect primary interface
    network_name=$(route -n get default 2>/dev/null | grep interface | awk '{print $2}')
    if [ -z "$network_name" ]; then
        network_name="en0"
    fi
fi

get_bytes() {
    # Get network statistics for the interface
    # netstat output columns: Name Mtu Network Address Ipkts Ierrs Ibytes Opkts Oerrs Obytes Coll
    # We want columns 7 (Ibytes) and 10 (Obytes)
    netstat -ibn | grep -E "^''${network_name}\s" | head -1 | awk '{print $7, $10}'
}

format_bytes() {
    local bytes=$1
    local output=""
    local unit=""

    if [ $bytes -gt 1073741824 ]; then
        output=$(echo "$bytes 1024" | awk '{printf "%.2f", $1/($2 * $2 * $2)}')
        unit="gB/s"
    elif [ $bytes -gt 1048576 ]; then
        output=$(echo "$bytes 1024" | awk '{printf "%.2f", $1/($2 * $2)}')
        unit="mB/s"
    else
        output=$(echo "$bytes 1024" | awk '{printf "%.2f", $1/$2}')
        unit="kB/s"
    fi

    echo "$output $unit"
}

main() {
    while true; do
        # Get initial bytes
        read initial_download initial_upload <<< $(get_bytes)

        # Handle case where interface doesn't exist or no data
        if [ -z "$initial_download" ] || [ -z "$initial_upload" ]; then
            echo "↓ N/A • ↑ N/A"
            sleep $INTERVAL
            continue
        fi

        sleep $INTERVAL

        # Get final bytes
        read final_download final_upload <<< $(get_bytes)

        # Handle case where interface doesn't exist or no data
        if [ -z "$final_download" ] || [ -z "$final_upload" ]; then
            echo "↓ N/A • ↑ N/A"
            continue
        fi

        # Calculate bytes per second
        total_download_bps=$((final_download - initial_download))
        total_upload_bps=$((final_upload - initial_upload))

        # Handle negative values (can happen during interface reset)
        if [ $total_download_bps -lt 0 ]; then
            total_download_bps=0
        fi
        if [ $total_upload_bps -lt 0 ]; then
            total_upload_bps=0
        fi

        # Format the output
        download_formatted=$(format_bytes $total_download_bps)
        upload_formatted=$(format_bytes $total_upload_bps)

        echo "↓ $download_formatted • ↑ $upload_formatted"
    done
}

main
EOF
        chmod +x scripts/network_bandwidth.sh
      '' else "";
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
