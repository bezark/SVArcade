{
  description = "SVArcade kiosk — NixOS config for the physical arcade cabinet";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable }: {
    nixosConfigurations.svarcade = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        # Overlay: pull Godot 4.6.1 from unstable
        ({ ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              godot_4 = nixpkgs-unstable.legacyPackages.x86_64-linux.godot_4;
            })
          ];
        })
      ];
    };
  };
}
