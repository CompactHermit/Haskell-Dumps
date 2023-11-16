{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
    pch = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {parts, ...}:
    parts.lib.mkFlake {inherit inputs;} {
      debug = true;
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      imports = with inputs; [
        treefmt-nix.flakeModule
        pch.flakeModule
        haskell-flake.flakeModule
      ];

      perSystem = {
        pkgs,
        config,
        ...
      }: {
        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            deadnix.enable = true;
            ormolu = {
              enable = true;
              package = pkgs.haskellPackages.fourmolu;
            };
            cabal-fmt.enable = true;
            hlint.enable = true;
          };
          settings = {
            formatter.ormolu = {
              options = [
                "--ghc-opt"
                "-XImportQualifiedPost"
                "--ghc-opt"
                "-XTypeApplications"
              ];
            };
          };
        };

        pre-commit = {
          check.enable = true;
          settings = {
            settings = {
              treefmt.package = config.treefmt.build.wrapper;
            };
            hooks = {
              treefmt.enable = true;
              hpack.enable = true;
            };
          };
        };

        haskellProjects.Project = {
          projectRoot = ./.;
          projectFlakeName = "Testing Haskell Support";
          packages = {};
          devShell.tools = hp: {
            inherit
              (hp)
              haskell-language-server
              ghcid
              ghci-dap
              haskell-debug-adapter
              stack
              ;
          };
          settings = {};
        };

        devShells.default = pkgs.mkShell {
          name = "Haskell Devshells";
          inputsFrom = with config; [
            treefmt.build.devShell
            pre-commit.devShell
            haskellProjects.Project.outputs.devShell
          ];
        };
      };
    };
}
