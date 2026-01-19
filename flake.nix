{
  description = "A very basic flake";

  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = (
          import nixpkgs {
            inherit system;
          }
        );
      in
      {
        packages.default = with pkgs.clangStdenv;
          mkDerivation {
            pname = "jxl-video-streamer";
            version = "1.0.0";
            src = ./.;

            cmakeFlags = [];
            nativeBuildInputs = [];
            buildInputs = [];
            buildPhase = ''
              mkdir -p build
              cmake -S $src -B ./build -DCMAKE_BUILD_TYPE=Release
              cmake --build build
            '';
          };

        devShells.default =
          with pkgs;
          mkShell.override { stdenv = pkgs.clangStdenv; } {

            packages = [
              # Generic DevTools
              # clang-tools must be first before clang
              pkgs.clang-tools
              pkgs.cmake
              pkgs.glib
              pkgs.ninja
              pkgs.gtk2
              pkgs.clang
              pkgs.nixfmt
            ];
          };
      }
    );
}
