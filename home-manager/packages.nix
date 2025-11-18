{ pkgs, ... }:

with pkgs; [
  # programs
  awscli2
  fd
  gcc
  google-cloud-sdk
  jq
  just
  nodejs
  ripgrep
  ack
  terraform
  packer
  virtualenv
  docker
  docker-compose
  bcompare
  httpie
  ngrok

  ffmpeg
  yt-dlp

  # git
  hub

  #python
  python312
  python312Packages.pip
  python312Packages.uv

  # go
  go

  # javascript
  yarn

  # Shell utilities
  tree

  # Custom programs
  hugo

  customBin.reattach-to-user-namespace

  # other
  postgresql_15

  # language servers
  gopls
  nil

  nodePackages."bash-language-server"
  nodePackages."dockerfile-language-server-nodejs"
  nodePackages."graphql-language-service-cli"
  nodePackages."typescript"
  nodePackages."typescript-language-server"
  nodePackages."vscode-langservers-extracted"
  nodePackages."yaml-language-server"
  rust-analyzer
  terraform-ls
]
