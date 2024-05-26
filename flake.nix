{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";

    scummvm-tools_src.url = "github:scummvm/scummvm-tools?ref=v2.7.0";
    scummvm-tools_src.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, scummvm-tools_src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages = rec {
          default = scummvm-tools;

          scummvm-tools = pkgs.stdenv.mkDerivation rec {
            pname = "scummvm-tools";
            version = "v2.7.0";

            src = scummvm-tools_src;

            enableParallelBuilding = true;

            buildInputs = with pkgs; [
              SDL
              zlib
            ];
          };
        };

        apps = rec {
          default = scummvm-tools-cli;

          scummvm-tools-cli = flake-utils.lib.mkApp {
            drv = packages.scummvm-tools;
            exePath = "/bin/scummvm-tools-cli";
          };
        };
      }
    );
}
