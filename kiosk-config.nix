{ config, pkgs, lib, ... }:


let
  kioskLaunch = pkgs.writeShellScriptBin "kiosk-launch" ''
    #!/usr/bin/env bash

    # 1. Update repository
    if [ -d "/home/svarcade/SVArcade-2025/.git" ]; then
      ${pkgs.git}/bin/git -C /home/svarcade/SVArcade-2025 pull || true
    else
      ${pkgs.git}/bin/git clone https://github.com/bezark/SVArcade-2025.git /home/svarcade/SVArcade-2025 || true
    fi

    # 2. Import changes using Godot
    ${pkgs.godot_4}/bin/godot4 --import --path /home/svarcade/SVArcade-2025/ || true

    # 3. Launch kiosk project
    exec ${pkgs.godot_4}/bin/godot4 --path /home/svarcade/SVArcade-2025/
  '';
in
  {
    imports = [ ./hardware-configuration.nix ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    # boot.initrd.kernelModules = [ "amdgpu" ];
    boot.initrd.kernelModules = [ "i915" ];  # Intel iGPU kernel module
    services.xserver.videoDrivers = [ "intel" ];  # Intel driver
    hardware.opengl.enable = true;
    hardware.opengl.driSupport32Bit = true;

    networking.hostName = "SVArcade";
    networking = {
      networkmanager.enable = true;
      firewall = {
        enable = true;
        allowedTCPPorts = [ 8080 8384 22000 ];
        allowedUDPPorts = [ 51820 7878 4242 22000 21027 ];
      };
    };

    # Tailscale daemon service configuration
    systemd.services.tailscaled = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };

    time.timeZone = "America/New_York";
    i18n.defaultLocale = "en_US.UTF-8";

    # services.self-deploy = {
    #   enable = true;

    #   startAt = "hourly";

    #   repository = "git@github.com:bezark/SVArcade-2025.git";
    #   nixFile = "/kiosk-config.nix";
    #   nixAttribute = "system";
    #   # sshKeyFile = "${config.users.users.gaetan.home}/.ssh/rsa_server";
    # };

    
    # --- Use Cage for Kiosk Mode ---
    services.cage = {
      enable = true;
      user = "svarcade";
      program = "${kioskLaunch}/bin/kiosk-launch";


    
      # program = "${pkgs.godot_4}/bin/godot4  --path /home/svarcade/SVArcade-2025/";#--import/home/svarcade/SVArcade-2025/project.godot";
    };

    # --- Disable power management (prevent sleep) ---
    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;


    # --- Enable Pipewire/ALSA support (no PulseAudio) ---
    hardware.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    nixpkgs.config.allowUnfree = true;

    # --- System Packages ---
    environment.systemPackages = with pkgs; [
  
     
      # Tools you already had
      rustdesk
      tmux
      screen
      nodejs_22
      temurin-bin-17
      git
      godot_4
      gdtoolkit_4
      wget
      github-desktop
      yazi
      broot
      helix
    ];

    # --- User Configuration ---
    users.users.svarcade = {
      isNormalUser = true;
      description = "SVArcade";
      extraGroups = [ "networkmanager" "wheel" "adbusers" "audio" "dialout" "input" "video" "reneder" ];
    };








    # --- Remote Access ---
    services.openssh.enable = true;
    services.tailscale.enable = true;

    # --- System State ---
    system.stateVersion = "24.11";  # Did you read the comment?
  }

