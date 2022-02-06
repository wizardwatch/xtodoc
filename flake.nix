{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, flake-utils, nixpkgs}:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      let
        hp = pkgs.haskellPackages;
      in rec {
        xtodoc = returnShellEnv:
        hp.developPackage {
          inherit returnShellEnv;
          name = "haskell-template";
          root = ./.;
          withHoogle = false;
          modifier = drv:
          pkgs.haskell.lib.addBuildTools drv ( with hp; [
                  # Specify your build/dev dependencies here.
                  cabal-fmt
                  cabal-install
                  ghcid
                  haskell-language-server
                  ormolu
                  pkgs.nixpkgs-fmt
                  pkgs.pandoc
                  shelly
          ]);
        };
        defaultPackage = xtodoc false;
        devShell = xtodoc true;
      }) // {
      };
}
