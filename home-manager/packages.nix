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

  # docker
  lazydocker

  #python
  python312
  python312Packages.pip
  python312Packages.uv
  python312Packages.bump2version

  # go
  go

  # javascript
  yarn-berry

  # Shell utilities
  tree
  fish

  # Custom programs
  hugo
  customBin.gong

  customBin.reattach-to-user-namespace

  # other
  postgresql_15

  # language servers
  gopls
  nil
  pyright  # Python LSP

  nodePackages."bash-language-server"
  dockerfile-language-server
  nodePackages."graphql-language-service-cli"
  nodePackages."typescript"
  nodePackages."typescript-language-server"
  nodePackages."vscode-langservers-extracted"
  nodePackages."yaml-language-server"
  rust-analyzer
  terraform-ls

  # Terminal notification support for tmux
  terminal-notifier
]
