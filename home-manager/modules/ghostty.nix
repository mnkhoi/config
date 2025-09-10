{ lib, ... }:
{
  programs.ghostty = lib.mkForce {
    enable = true;
    settings = {
      theme = "catppuccin-mocha";
    };
  };
}


