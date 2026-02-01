{
  description = "A very basic flake";

  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    skcms = { url = "path:libraries/skcms"; };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      skcms,
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
              owner = "libjxl";
              repo = "libjxl";
              rev = "8ce9537c989cfc7adff034556c8a4b9469e874d6";
              sha256 = "sha256-PHkk3Fe1WEoF1lJjKUsH7STcZUjr6y251g7oHAnHUME=";
            };

            buildInputs = [ pkgs.cmake pkgs.libhwy pkgs.brotli pkgs.libjpeg pkgs.libwebp skcms.packages.x86_64-linux.skcms ];
            cmakeFlags = [ ];
            nativeBuildInputs = [ ];
            buildPhase = ''
              export CC=clang CXX=clang++ PATH="$PATH:${skcms.packages.x86_64-linux.skcms.out}/libskcms.a"
              mkdir build
              cd build
              cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF ..
              cmake --build . -- -j$(nproc)
            '';
          };

        packages.default =
          with pkgs.clangStdenv;
          mkDerivation {
            pname = "jxl-video-streamer";
            version = "1.0.0";
            src = ./.;

            cmakeFlags = [ ];
            nativeBuildInputs = [ ];
            buildInputs = [  ];
            buildPhase = ''
              mkdir -p build
              cmake -S $src -B ./build -DCMAKE_BUILD_TYPE=Release
              cmake --build build
            '';
          };

        devShells.default =
          with pkgs;
          mkShell.override { stdenv = pkgs.clangStdenv; } {
            T = "${skcms.packages.x86_64-linux.skcms.out}";

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
