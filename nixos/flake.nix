{
  description = "A simple NixOS flake for Hetzner Cloud server with Bonfire";

  inputs = {
    # NixOS official package source, using the nixos-25.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    bonfire-app.url = "github:bonfire-networks/bonfire-app/main"; # Or a specific tag/commit
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, bonfire-app, flake-utils }:
    {
      nixosConfigurations.nixos-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix # Your main configuration.nix
          ./hardware-configuration.nix # Add other modules here if you have them, e.g., hardware-configuration.nix
        ];
        specialArgs = {
          inherit bonfire-app; # Pass bonfire-app input to configuration.nix
        };
      };
    };
}
