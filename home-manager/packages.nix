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
  lazydocker
  nodejs
  python3Full
  python310Packages.pip
  ripgrep
  rustc
  rustfmt
  terraform
  virtualenv
  yarn
  tree
  hub
  docker
  docker-compose
  kubernetes-helm-wrapped

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
