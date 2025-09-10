# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, outputs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/default.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
        settings = {
          experimental-features = "nix-command flakes";
          flake-registry = "";
          nix-path= config.nix.nixPath;
          trusted-users = ["root" "@wheel"];
        };
  channel.enable = false;
      registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      };
  
  # hostname
  networking.hostName = "user";

  # Enable networking

  networking.wireless.iwd.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,vn";
    variant = ",telex";
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "overload(control, esc)"; # Caps Lock as Ctrl when held, Esc when tapped
          };
          alt = {
            capslock = "capslock";
          };
        };
      };
    };
  };

  services.udisks2.enable = true;

  services.auto-cpufreq.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
   # package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  services.pulseaudio = {
    enable = false;
    support32Bit = true;
  };

  hardware.bluetooth = { 
    enable = true; 
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
    };
    };
  };

  services.blueman.enable = true;

  sound.enable = true;

  security.rtkit.enable = true;

  # Enable audio through pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Configure console keymap
  console.keyMap = "us";

  
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;  # Enables better Nix integration
  };


  users = {
    khoinguyen = {
      isNormalUser = true;
      description = "Khoi Nguyen";
      #openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      #];
      extraGroups = ["wheel" "networkmanager" "input" "libvirtd"];
      packages = with pkgs; [];
      shell = pkgs.zsh;
    };
  };

 
  environment.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    NH_FLAKE = "/etc/nixos";
    TERM = "xterm-256color";    
    CARGO_MOMMYS_LITTLE = "boy/princess/pet";
    CARGO_MOMMYS_MOODS = "chill/thirsty";
  };

  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
   fonts.fontDir.enable = true;

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];


  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  #services.openssh = {
    #enable = true;
    #settings = {
      # Opinionated: forbid root login through SSH.
      #PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      #PasswordAuthentication = false;
    #};
  #};
  time.timeZone = "America/Toronto";

  system.stateVersion = "24.11"; # Did you read the comment?

}

