{ config, pkgs, ... }:
let
  nix = import ./shared/nix.nix { inherit pkgs; };
  nixpkgs = import ./shared/nixpkgs.nix { enablePulseAudio = true; };
  systemPackages = import ./shared/systemPackages.nix {
    inherit pkgs;
    extraPackages = with pkgs; [
      dunst
      k3s
      libnotify
      lxappearance
      pavucontrol
      xclip
    ];
  };
in {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  fileSystems."/host" = {
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    device = ".host:/";
    options = [
      "umask=22"
      "uid=1000"
      "gid=1000"
      "allow_other"
      "auto_unmount"
      "defaults"
    ];
  };

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
      };
    };

    fonts = with pkgs; [ (nerdfonts.override { fonts = [ "Meslo" ]; }) ];
  };

  environment = {
    pathsToLink = [ "/libexec" "/share/zsh" ];
    systemPackages = systemPackages;
  };

  hardware = {
    opengl.enable = true;

    pulseaudio = {
      enable = true;
      extraConfig = "unload-module module-suspend-on-idle";
      support32Bit = true;
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  nix = nix;

  nixpkgs = nixpkgs;

  programs = {
    dconf.enable = true;
    geary.enable = true;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services = {
    logind.extraConfig = ''
      RuntimeDirectorySize=20G
    '';

    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };

    picom.enable = true;
    twingate.enable = true;
  };

  sound.enable = true;

  system.stateVersion = "22.05";

  time.timeZone = "America/Los_Angeles";

  users = {
    mutableUsers = false;
  };

  virtualisation = {
    containerd = {
      enable = true;
      settings = let
        fullCNIPlugins = pkgs.buildEnv {
          name = "full-cni";
          paths = with pkgs; [ cni-plugin-flannel cni-plugins ];
        };
      in {
        plugins."io.containerd.grpc.v1.cri".cni = {
          bin_dir = "${fullCNIPlugins}/bin";
          conf_dir = "/var/lib/rancher/k3s/agent/etc/cni/net.d/";
        };
      };
    };

    docker.enable = true;

    podman = {
      enable = true;
      extraPackages = with pkgs; [ zfs ];
    };
  };
}
