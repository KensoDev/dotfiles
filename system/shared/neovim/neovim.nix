self: super: {
  customVim = with self; {
     kensodev = pkgs.vimUtils.buildVimPlugin {
      name = "KensoDev";
      src = ./nvim;
    };

    vim-just = pkgs.vimUtils.buildVimPlugin {
      name = "vim-just";
      src = pkgs.fetchFromGitHub {
        owner = "NoahTheDuke";
        repo = "vim-just";
        rev = "838c9096d4c5d64d1000a6442a358746324c2123";
        sha256 = "sha256-DSC47z2wOEXvo2kGO5JtmR3hyHPiYXrkX7MgtagV5h4=";
      };
    };
  };
}
