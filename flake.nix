/*
# About
This file contains Nix code used to allow the installation of xtodoc via the experimental
flakes feature.
*/
{
  description = "Utility for generating markdown documentation from comments in code";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs {
      inherit system;
    };
  in
  let
    xtodoc = pkgs.crystal.buildCrystalPackage rec {
      pname = "xtodoc";
      version = "0.0.3";
      src = ./.;
      crystalBinaries.xtodoc = {
        src = "./xtodoc.cr";
        options = [];
      };
      format = "crystal";
      doCheck = false;
      doInstallCheck = false;
    };
    /*
    In the following section I allow xtodoc to either be installed or tested in a nix
    shell environment.
    */
    in rec {
      defaultApp = flake-utils.lib.mkApp {
        drv = defaultPackage;
      };
      defaultPackage = xtodoc;
      devShell = pkgs.mkShell {
        buildInputs = [
          xtodoc
          pkgs.hyperfine
          pkgs.linuxPackages.perf
          pkgs.valgrind
        ];
      };
  });
}
