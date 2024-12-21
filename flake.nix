{
  nixConfig = {
    extra-substituters = "https://cache.ners.ch/haskell";
    extra-trusted-public-keys = "haskell:WskuxROW5pPy83rt3ZXnff09gvnu80yovdeKDw5Gi3o=";
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
    service-flake.url = "github:juspay/services-flake";
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
    ollama-holes-plugin = {
      url = "github:Tritlo/OllamaHoles";
      flake = false;
    };
  };
  outputs =
    inputs@{ parts, ... }:
    parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      systems = [
        "x86_64-linux"
        # "aarch64-linux"
      ];
      imports = with inputs; [
        treefmt-nix.flakeModule
        pch.flakeModule
        haskell-flake.flakeModule
      ];

      perSystem =
        {
          pkgs,
          config,
          system,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
          };
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              ormolu = {
                enable = true;
                package = pkgs.haskellPackages.fourmolu;
              };
            };
            settings = {
              formatter.ormolu = {
                ghcOpts = [
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

          haskellProjects.tester = {
            # FUCK:: THIS will take forever to boot
            basePackages = pkgs.haskell.packages.ghc98;
            projectRoot = ./.;
            projectFlakeName = "Testing Haskell Support";

            packages = {
              #Adding Ollama Holes to the repo
              ollama-holes-plugin.source = inputs.ollama-holes-plugin;
            };
            settings = {
              relude = {
                haddock = false;
                broken = false;
                jailbreak = true;
              };
              ollama-haskell = {
                haddock = false;
                broken = false;
                jailbreak = true;
                check = false;
              };
              smtlib-backends.jailbreak = true;
              smtlib-backends-process = {
                broken = false;
                check = false;
                jailbreak = true;
              };
              ollama-holes-plugin = {
                check = false;
                broken = false;
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
              # hoogle = {
              #   jailbreak = true;
              #   check = false;
              # };
              template-haskell-optics = {
                jailbreak = true;
                broken = false;
              };
            };
            devShell = {
              #hlsCheck.enable = true;
              hoogle = true;
              benchmark = true;
              tools = hp: {
                inherit (hp)
                  haskell-debug-adapter
                  cabal-fmt
                  cabal-gild
                  ghcid
                  ghcide
                  ghci-dap
                  ;
              };
              extraLibraries = hp: { inherit (hp) hspec z3; };
            };
          };
          #
          # checks = {
          #   tester-thoughtdump = inputs.weeder-nix.lib."${system}".makeWeederCheck {
          #     haskellPackages = pkgs.haskellPackages;
          #     packages = [ "tester-thoughtdump" ];
          #   };
          # };
          devShells.default = pkgs.mkShell {
            name = "Haskell Devshells";
            inputsFrom = with config; [
              treefmt.build.devShell
              pre-commit.devShell
              haskellProjects.tester.outputs.devShell
            ];
            DIRENV_LOG_FORMAT = ""; # NOTE:: Makes direnv shutup
            #LIQUID_DEV_MODE = true; # NOTE::(Hermit) Needed for z3 solver to do shits
            buildInputs = builtins.attrValues {
              inherit (pkgs)
                z3
                gdb
                cabal2nix
                pcre
                pcre2
                just
                ;
            };
          };
        };
    };
}
