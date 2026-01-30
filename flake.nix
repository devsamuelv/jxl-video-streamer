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
        packages.jxl =
          with pkgs.clangStdenv;
          mkDerivation {
            pname = "jxl-lib";
            version = "1.0.0";
            src = nixpkgs.legacyPackages.x86_64-linux.fetchFromGitHub {
              owner = "devsamuelv";
              repo = "cpp-httplib";
              rev = "629644ef9765ab33284498b2daa6842fc32c9ab6";
              sha256 = "sha256-gUgt/0gnAytPYQksYVwPQF9Pk/+TOCuxdYkmU9ocLy4=";
            };
          };

        packages.default =
          with pkgs.clangStdenv;
          mkDerivation {
            pname = "jxl-video-streamer";
            version = "1.0.0";
            src = ./.;

            cmakeFlags = [ ];
            nativeBuildInputs = [ ];
            buildInputs = [ pkgs.jxl ];
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
              pkgs.jxl
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
