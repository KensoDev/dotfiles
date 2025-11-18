{ config, pkgs, ... }:
let
  nixCfg     = import ./shared/nix.nix { inherit pkgs; };
  nixpkgsCfg = import ./shared/nixpkgs.nix { };
  systemPackages = import ./shared/systemPackages.nix { inherit pkgs; };
  zsh = import ./shared/zsh.nix;
in {
  environment.systemPackages = systemPackages;

  # nix-darwin manages daemon & build users when enable = true
  nix = nixCfg // {
    enable = true;
    optimise.automatic = true;   # replaces deprecated auto-optimise-store

    # Optional: extra nix.conf keys
    settings = (nixCfg.settings or {}) // {
      build-users-group = "nixbld";        # default is already nixbld; explicit is fine
      experimental-features = [ "nix-command" "flakes" ]
        ++ (nixCfg.settings.experimental-features or []);
      trusted-users = [ "@admin" "root" "azurel" ]
        ++ (nixCfg.settings.trusted-users or []);
    };
  };

  nixpkgs = nixpkgsCfg;

  programs = { zsh = zsh; };

  system.stateVersion = 4;
}
