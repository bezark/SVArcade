# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{

  system.copySystemConfiguration = true;
  #Experimental Features
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = ["amdgpu"];

  networking.hostName = "nixDesktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  systemd.services.tailscaled = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking with Wake-on-LAN
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 8080 8384 22000 ];
      allowedUDPPorts = [ 51820 7878 4242 22000 21027 ];
    };
    interfaces = {
      "enp6s0" = {
        wakeOnLan = {
          enable = true;
        };
      };
      "wlp5s0" = {
        wakeOnLan = {
          enable = true;
        };
      };
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.opengl.driSupport32Bit = true;

  #For power mode
  services.power-profiles-daemon.enable = true;

  # Enable the GNOME Desktop Environment.
   services.xserver.displayManager.gdm = {
    enable = true; 
  # #   # autoLogin = {
  # #   #   enable = true;
  # #   #   user = "johnb";  # Your username
  # #   # };
  };
  services.xserver.desktopManager.gnome.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  services.flatpak.enable = true;
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.pulseaudio.enable = false; # Use Pipewire, the modern sound subsystem

  security.rtkit.enable = true; # Enable RealtimeKit for audio purposes

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #Bluetooth
  hardware.bluetooth = {
    powerOnBoot = true;
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
    KERNEL=="pcm*", GROUP="audio"
  '';

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.johnb = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "John Bezark";
    extraGroups = [ "networkmanager" "wheel" "adbusers" "audio" "dialout" "input"];
    packages = with pkgs; [
      firefox
      chromium
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINEZZxARlyPFzz9uIhKQK9tiCywFjjzN3YTF5flKHHvt johnb@nixDesktop"
    ];
  };


  # fileSystems."/boot" = lib.mkForce {
  #   device = "/dev/disk/by-uuid/3486-CD86";  # Matches your blkid output
  #   fsType = "vfat";
  #   options = [ "rw" "relatime" "fmask=0022" "dmask=0022" "codepage=437" "iocharset=iso8859-1" "shortname=mixed" ];
  # };


  # fileSystems."/mnt/trunk" = {
  #   device = "UUID=26937bbe-7cca-4a8c-8d88-f7da61dd5f50";
  #   fsType = "ext4";  # Or whatever filesystem you formatted it with
  #   options = [ "x-initrd.mount" ];
  # };

  systemd.tmpfiles.rules = [
    "d /mnt/trunk 0755 johnb users - -"
  ];
  programs.adb.enable = true;
  programs.java.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    python3
    python312Packages.httplib2
    nodejs_22
    typescript-language-server
    vscode-langservers-extracted
    nixd
    markdown-oxide

    temurin-bin-17
    jdk17
    android-studio
    android-udev-rules
    android-tools
    appimage-run


    certbot





    gnome-power-manager
    power-profiles-daemon
    pipewire
    # pamixer
    alsa-plugins
    alsa-utils

    godot_4
    gdtoolkit_4

    



    haskellPackages.pandoc-cli
    texliveSmall

    bluez
    bluez-tools
    kooha
    ffmpeg_7
    alvr 
    libvirt


    wget 

    dbus



    helix
    nmap
    nnn
    yazi
    broot
    tmux
    screen


    wireguard-tools

    git
    github-desktop
    gitg
    gh
    hut




    postman
    nixos-generators

    # xclip
    # xsel


    wl-clipboard
    wtype


    kdePackages.kruler



    
    xdotool
    ydotool
    zsh
    gnome-keyring
    kitty
    ghostty

    # font-awesome
    # material-design-icons
    # nerdfonts

####HYPRLAND
    waybar
    networkmanager_dmenu
    pavucontrol
    rofi-bluetooth

    nwg-panel
    nwg-dock-hyprland
    nwg-displays

    # dunst
    libnotify
    swaynotificationcenter
    wofi
    # dolphin
    nwg-look
    hyprshot
    hyprpaper
    hyprsunset
    hyprpicker

    sassc
    gnome-themes-extra
    gtk-engine-murrine


    
    # (import (pkgs.callPackage (pkgs.fetchFromGitHub {
    #   owner = "MalpenZibo";
    #   repo = "ashell";
    #   rev = "refs/heads/main"; # Or specify the branch/tag you need
    #   sha256 = "sha256-O/Y/l05osLmGgEt+3YtSGaySU5GFxGdNzVGHX6gfc7s="; # Replace with the correct hash
    # }) {}).defaultPackage.x86_64-linux)


    
  ];

  # wayland.windowManager.hyprland.systemd.variables = ["-all"];

  programs.hyprland.enable = true;
  programs.hyprland.systemd.setPath.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];


  programs.zsh = {
    enable = true;
    shellAliases = {
      br = "broot";
      yz = "yazi";
      vs = "vdirsyncer sync";
    };
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };

  programs.steam.enable = true;

  environment.variables = { EDITOR = "ghostty"; VISUAL = "ghostty"; TERMINAL = "ghostty"; };

  environment.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk11}/lib/openjdk";
    ANDROID_SDK_ROOT = "${pkgs.android-studio}/libexec/android-sdk";
    EDITOR = "ghostty";
  };



  

  programs.bash.shellAliases = {
    br = "broot";
    yz = "yazi";
  };
  

  # programs.zsh.initExtra = ''
  #   export HYPRLAND_INSTANCE_SIGNATURE=$(grep -z '^HYPRLAND_INSTANCE_SIGNATURE=' /proc/$(pgrep -n Hyprland)/environ | cut -d= -f2-)
  # '';

  # programs.bash.shellInit = ''
  #   export HYPRLAND_INSTANCE_SIGNATURE=$(grep -z '^HYPRLAND_INSTANCE_SIGNATURE=' /proc/$(pgrep -n Hyprland)/environ | cut -d= -f2-)
  # '';

  

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    fira-code
    font-awesome
    powerline-fonts
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "23.05"; # Did you read the comment?

}
