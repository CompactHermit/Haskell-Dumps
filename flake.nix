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

    # Packages::
    liquid-fixpoint = {
      url = "github:ucsd-progsys/liquid-fixpoint";
      flake = false;
    };
    Liquidhaskell = {
      url = "github:ucsd-progsys/liquidhaskell";
      flake = false;
    };
  };
  outputs =
    inputs@{ parts, ... }:
    parts.lib.mkFlake { inherit inputs; } {
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

      perSystem =
        { pkgs, config, ... }:
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt-rfc-style.enable = true;
              ormolu = {
                enable = true;
                package = pkgs.haskellPackages.fourmolu;
              };
              #hlint.enable = true;
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
                #hpack.enable = true;
              };
            };
          };

          haskellProjects.tester = {
            # FUCK:: THIS will take forever to boot
            basePackages = pkgs.haskell.packages.ghc981;
            projectRoot = ./.;
            projectFlakeName = "Testing Haskell Support";
            # packages = {
            #   liquidhaskell-boot.source = "0.9.8.1";
            #   liquidhaskell.source = "0.9.8.1";
            # };
            settings = {
              # TODO:: Make a __mkJailbreak function and just mapAttrs over it.
              relude = {
                haddock = false;
                broken = false;
                jailbreak = true;
              };
              smtlib-backends.jailbreak = true;
              smtlib-backends-process = {
                broken = false;
                check = false;
                jailbreak = true;
              };
              liquidhaskell =
                { pkgs, ... }:
                {
                  check = false;
                  broken = false;
                  jailbreak = true;
                  extraBuildTools = with pkgs; [ z3 ];
                  #This, doesnt work? Fuck
                  # custom = pkg:
                  #   pkgs.haskell.lib.overrideCabal pkg (o: {
                  #     enableLibraryProfiling = false;
                  #     buildTools = (o.buildTools or []) ++ [super.z3];
                  #   });
                };
              liquidhaskell-boot = {
                check = false;
                broken = false;
                jailbreak = true;
              };
              liquid-fixpoint = {
                check = false;
                broken = false;
                jailbreak = true;
              };
              liquid-prelude =
                { pkgs, ... }:
                {
                  check = false;
                  broken = false;
                  jailbreak = true;
                  extraBuildTools = with pkgs; [ z3 ];
                };
              liquid-vector =
                { pkgs, ... }:
                {
                  check = false;
                  broken = false;
                  jailbreak = true;
                  extraBuildTools = with pkgs; [ z3 ];
                };
              hoogle = {
                jailbreak = true;
                check = false;
              };
              template-haskell-optics = {
                jailbreak = true;
                broken = false;
              };
            };
            devShell = {
              hlsCheck.enable = true;
              hoogle = true;
              benchmark = true;
              tools = hp: {
                inherit (hp)
                  haskell-language-server
                  cabal-fmt
                  ghcid
                  ghci-dap
                  haskell-debug-adapter
                  ;
              };
              extraLibraries = hp: { inherit (hp) hspec z3; };
            };
          };

          devShells.default = pkgs.mkShell {
            name = "Haskell Devshells";
            inputsFrom = with config; [
              treefmt.build.devShell
              pre-commit.devShell
              haskellProjects.tester.outputs.devShell
            ];
            DIRENV_LOG_FORMAT = ""; # NOTE:: Makes direnv shutup
            LIQUID_DEV_MODE = true; # NOTE::(Hermit) Needed for z3 solver to do shits
            buildInputs = with pkgs; [ z3 ];
          };
        };
    };
}
