{ pkgs, ... }:

with pkgs; [
  # programs
  awscli2
  azure-cli
  cargo
  fd
  gcc
  ghc
  google-cloud-sdk
  jetbrains.datagrip
  jq
  just
  kubectl
  kubectx
  lazydocker
  nodejs
  ripgrep
  rustc
  rustfmt
  terraform
  virtualenv
  docker
  docker-compose
  kubernetes-helm-wrapped
  bcompare

  #python
  python3Full
  python310Packages.pip
  customPythonPackages.botoenv

  # go
  go

  # javascript
  yarn

  # Shell utilities
  tree

  # git
  hub

  # Custom programs
  hugo

  # Custom Bin
  customBin.gong
  customBin.reattach-to-user-namespace

  # other
  postgresql_15

  # language servers
  gopls
  nil
  nodePackages."@prisma/language-server"
  nodePackages."bash-language-server"
  nodePackages."dockerfile-language-server-nodejs"
  nodePackages."graphql-language-service-cli"
  nodePackages."pyright"
  nodePackages."typescript"
  nodePackages."typescript-language-server"
  nodePackages."vscode-langservers-extracted"
  nodePackages."yaml-language-server"
  rust-analyzer
  sumneko-lua-language-server
  terraform-ls
]
