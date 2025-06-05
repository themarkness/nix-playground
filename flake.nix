{
  description = "A simple web application";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Development environment
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs_20
            yarn
          ];
        };

        # Build the application
        packages.default = pkgs.stdenv.mkDerivation {
          name = "my-web-app";
          version = "1.0.0";
          src = ./src;
          
          buildInputs = with pkgs; [
            nodejs_20
            yarn
          ];

          buildPhase = ''
            yarn install
            yarn build
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp -r dist/* $out/bin/
          '';
        };
      }
    );
} 