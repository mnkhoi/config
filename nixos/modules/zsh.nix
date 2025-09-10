{ pkgs , ... }:
{
  programs.zsh = {
    enable = true;
    interactiveShellInit = ''
      starship init zsh | source
      zoxide init zsh | source

    '';
    shellAliases = {
      nmtui = "impala";
      cd = "z";
      ls = "eza"; 
    };
  };

  programs.fish.enable = true;
}
