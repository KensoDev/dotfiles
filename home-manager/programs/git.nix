
{ pkgs, ... }:

{
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
}
