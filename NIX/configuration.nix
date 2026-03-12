{ config, pkgs, lib, ... }:

let
  repo = "/home/svarcade/SVArcade-2025";
  repoUrl = "https://github.com/bezark/SVArcade-2025.git";
in
{
  ################################################################################
  # Boot
  ################################################################################

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "i915" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  ################################################################################
  # Network
  ################################################################################

  networking.hostName = "SVArcade";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 8080 ];
    allowedUDPPorts = [ 41641 ]; # Tailscale
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # Never sleep
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  ################################################################################
  # Auto-update: pull repo, rebuild NixOS if flake changed
  ################################################################################

  systemd.services.svarcade-update = {
    description = "SVArcade auto-update — git pull and NixOS rebuild if flake changed";
    wantedBy = [ "multi-user.target" ];
    before = [ "display-manager.service" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutStartSec = "300"; # 5 min max for the whole thing
    };
    path = [ pkgs.git pkgs.curl pkgs.coreutils pkgs.nixos-rebuild ];
    script = ''
      # Wait for network (max 60s), but don't block forever
      elapsed=0
      while ! curl -sf --max-time 5 --head https://github.com > /dev/null 2>&1; do
        sleep 2
        elapsed=$((elapsed+2))
        if [ $elapsed -ge 60 ]; then
          echo "No network — skipping update"
          exit 0
        fi
      done

      # Clone or pull
      if [ -d "${repo}/.git" ]; then
        OLD_HASH=$(git -C "${repo}" log -1 --format=%H -- NIX/ 2>/dev/null || echo "none")
        git -C "${repo}" pull --ff-only || true
        NEW_HASH=$(git -C "${repo}" log -1 --format=%H -- NIX/ 2>/dev/null || echo "none")
      else
        git clone "${repoUrl}" "${repo}" || { echo "Clone failed — skipping"; exit 0; }
        OLD_HASH="none"
        NEW_HASH="cloned"
      fi

      chown -R svarcade:users "${repo}" 2>/dev/null || true

      # Rebuild only if NIX/ directory changed
      if [ "$OLD_HASH" != "$NEW_HASH" ] && [ -f "${repo}/NIX/flake.nix" ]; then
        echo "Flake changed ($OLD_HASH -> $NEW_HASH) — rebuilding..."
        nixos-rebuild switch --flake "${repo}/NIX#svarcade" || echo "Rebuild failed — continuing with current config"
      else
        echo "Flake unchanged — no rebuild needed"
      fi
    '';
  };

  ################################################################################
  # Display — X11 kiosk with auto-login
  ################################################################################

  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.xserver.windowManager.openbox.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "svarcade";

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Kiosk startup — display setup + launch Godot
  # (git pull already handled by svarcade-update.service)
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-1 --mode 3840x2160 2>/dev/null || true
    xset s off
    xset -dpms
    unclutter -idle 0 &

    # Import assets then launch
    ${pkgs.godot_4}/bin/godot4 --import --path "${repo}"
    exec ${pkgs.godot_4}/bin/godot4 --path "${repo}"
  '';

  ################################################################################
  # Audio
  ################################################################################

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ################################################################################
  # Packages
  ################################################################################

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Kiosk core
    godot_4
    git
    curl
    unclutter-xfixes
    xorg.xrandr

    # Development / admin
    nodejs_22
    helix
    tmux
    htop
    pciutils
    wget
    yazi

    # Remote access
    rustdesk
  ];

  ################################################################################
  # User
  ################################################################################

  users.users.svarcade = {
    isNormalUser = true;
    description = "SVArcade";
    extraGroups = [ "wheel" "networkmanager" "audio" "input" "video" ];
  };

  ################################################################################
  # Services
  ################################################################################

  services.openssh.enable = true;
  services.tailscale.enable = true;

  # Claude Code: installed via npm to ~/.local/bin (needs nodejs in PATH)
  # Run: npm config set prefix ~/.local && npm install -g @anthropic-ai/claude-code

  ################################################################################
  # State
  ################################################################################

  system.stateVersion = "24.11";
}
