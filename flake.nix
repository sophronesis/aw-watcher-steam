# file: flake.nix
{
  description = "Python application packaged using poetry2nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.poetry2nix.url = "github:nix-community/poetry2nix";

  outputs = { self, nixpkgs, poetry2nix }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
      # system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      # create a custom "mkPoetryApplication" API function that under the hood uses
      # the packages and versions (python3, poetry etc.) from our pinned nixpkgs above:
      # inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication mkPoetryEnv defaultPoetryOverrides;
      # myPythonApp = mkPoetryApplication {
      #   projectDir = self; 
      #   overrides = defaultPoetryOverrides.extend
      #       (final: prev: {
      #         persist-queue = prev.persist-queue.overridePythonAttrs
      #         (
      #           old: {
      #             buildInputs = (old.buildInputs or [ ]) ++ [ prev.setuptools ];
      #           }
      #         );
      #         takethetime = prev.takethetime.overridePythonAttrs
      #         (
      #           old: {
      #             buildInputs = (old.buildInputs or [ ]) ++ [ prev.setuptools ];
      #           }
      #         );
      #       });
      # };
    in
    {
      # apps.${system}.default = {
      #   type = "app";
      #   program = "${myPythonApp}/bin/aw-watcher-steam";
      # };
      packages = forAllSystems (system: let
        inherit (poetry2nix.lib.mkPoetry2Nix { pkgs = pkgs.${system}; }) mkPoetryApplication defaultPoetryOverrides;
      in {
        default = mkPoetryApplication { projectDir = self; 
          overrides = defaultPoetryOverrides.extend
              (final: prev: {
                persist-queue = prev.persist-queue.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ prev.setuptools ];
                  }
                );
                takethetime = prev.takethetime.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ prev.setuptools ];
                  }
                );
              });
        };
      });

      devShells = forAllSystems (system: let
        inherit (poetry2nix.lib.mkPoetry2Nix { pkgs = pkgs.${system}; }) mkPoetryEnv defaultPoetryOverrides;
      in {
        default = pkgs.${system}.mkShellNoCC {
          packages = with pkgs.${system}; [
            (mkPoetryEnv { projectDir = self; 
              overrides = defaultPoetryOverrides.extend
                  (final: prev: {
                    persist-queue = prev.persist-queue.overridePythonAttrs
                    (
                      old: {
                        buildInputs = (old.buildInputs or [ ]) ++ [ prev.setuptools ];
                      }
                    );
                    takethetime = prev.takethetime.overridePythonAttrs
                    (
                      old: {
                        buildInputs = (old.buildInputs or [ ]) ++ [ prev.setuptools ];
                      }
                    );
                  });
            })
	    poetry
          ];
        };
      });
    };
}

