{
  description = "Skcm";

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
        packages.skcms =
          with pkgs.clangStdenv;
          mkDerivation {
            pname = "skcms";
            version = "1.0.0";
            src = pkgs.fetchgit {
              url = "https://github.com/google/skcms.git";
              branchName = "mirror";
              rev = "96d9171c94b937a1b5f0293de7309ac16311b722";
              sha256 = "sha256-qQirNyh1uP4GTIwC3wh96IOFf77kJfRXCB5kd9di9ac=";
            };

            cmakeFlags = [ ];
            nativeBuildInputs = [ ];
            buildInputs = [ pkgs.bazel ];
            buildPhase = ''
              bazel build //...
            '';

            outputs = [ "out" ];
          };

      }
    );
}
