{ config, pkgs, lib, ... }:


let
  kioskLaunch = pkgs.writeShellScriptBin "kiosk-launch" ''
    #!/usr/bin/env bash
    set -euo pipefail

    export WLR_NO_HARDWARE_CURSORS=1

    # 1. Wait for network by pinging a known host or trying a quick HEAD request
    echo "Waiting for network..."
    until ${pkgs.curl}/bin/curl --silent --head https://github.com/bezark/SVArcade-2025 > /dev/null; do
      sleep 2
    done
    echo "Network is up!"

    # 2. Pull or clone the repository
    if [ -d "/home/svarcade/SVArcade-2025/.git" ]; then
      ${pkgs.git}/bin/git -C /home/svarcade/SVArcade-2025 pull
    else
      ${pkgs.git}/bin/git clone https://github.com/bezark/SVArcade-2025.git /home/svarcade/SVArcade-2025
    fi

    # 3. Import changes using Godot
    ${pkgs.godot_4}/bin/godot4 --import --path /home/svarcade/SVArcade-2025/

    # 4. Launch kiosk project
    exec ${pkgs.godot_4}/bin/godot4 --path /home/svarcade/SVArcade-2025/ &

        # Give Godot a moment to start and capture the pointer
    sleep 10

    # Use ydotool to warp the pointer offscreen (ensure ydotool is in your systemPackages)
    ${pkgs.ydotool}/bin/ydotool click # mousemove 9999 9999
    ${pkgs.ydotool}/bin/ydotool  mousemove 9 9
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
      environment= {
        # WLR_LIBINPUT_NO_DEVICES = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
        XCURSOR_THEME = "transparent";  # The name of your theme
        XCURSOR_PATH = "/home/svarcade/SVArcade-2025/CursorTheme"; 
      };
      program = "${kioskLaunch}/bin/kiosk-launch";

     # program = pkgs.writeShellScriptBin "kiosk-launch" ''
     #   !/usr/bin/env bash
     #     # Try to update the repository, or clone it if the folder does not exist.
     #   if [ -d "/home/svarcade/SVArcade-2025/.git" ]; then
     #     ${pkgs.git}/bin/git -C /home/svarcade/SVArcade-2025 pull || true
     #   else
     #     ${pkgs.git}/bin/git clone https://github.com/bezark/SVArcade-2025.git /home/svarcade/SVArcade-2025 || true
     #     fi
     #    # Now launch the Godot project.
     #    ${pkgs.godot_4}/bin/godot4 --path /home/svarcade/SVArcade-2025/
     #  '';

    
      # program = "${pkgs.godot_4}/bin/godot4  --path /home/svarcade/SVArcade-2025/";#--import/home/svarcade/SVArcade-2025/project.godot";
      #-kiosk -private-window https://www.google.com";
        # Launch a simple Wayland terminal (foot) to test Cage
    };

    # --- Disable power management (prevent sleep) ---
    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;

    # --- Remove or disable any other display manager / compositor settings ---
    # (not shown here for brevity)

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
      cage
      ydotool
    ];

    # --- User Configuration ---
    users.users.svarcade = {
      isNormalUser = true;
      description = "SVArcade";
      extraGroups = [ "networkmanager" "wheel" "adbusers" "audio" "dialout" "input" "video" "reneder" ];
    };




    # systemd.timers."hello-world" = {
    #   wantedBy = [ "timers.target" ];
    #     timerConfig = {
    #       OnBootSec = "10s";
    #       OnUnitActiveSec = "10m";
    #       # Alternatively, if you prefer to specify an exact timestamp
    #       # like one does in cron, you can use the `OnCalendar` option
    #       # to specify a calendar event expression.
    #       # Run every Monday at 10:00 AM in the Asia/Kolkata timezone.
    #       #OnCalendar = "Mon *-*-* 10:00:00 Asia/Kolkata";
    #       Unit = "hello-world.service";
    #     };
    # };

    # systemd.services."hello-world" = {
    #   script = ''
    #     set -eu
    #     ${pkgs.coreutils}/bin/echo "Hello World"
    #     cd /home/svarcade/SVArcade-2025
    #     ${pkgs.git}/bin/git pull
    #     # ${pkgs.godot_4}/bin/godot4  --import
    #     # ${pkgs.cage}/bin/cage godot4  --path /home/svarcade/SVArcade-2025/

    #   '';
    #   serviceConfig = {
    #     Type = "oneshot";
    #     User = "svarcade";
    #   };
    # };






    # --- Remote Access ---
    services.openssh.enable = true;
    services.tailscale.enable = true;

    # --- System State ---
    system.stateVersion = "24.11";  # Did you read the comment?
  }

