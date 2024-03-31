{
  description = "Nix flake for pyftpdlib";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    flake-utils,
    nixpkgs,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [];
      };
    in {
      # packages exported by the flake
      packages = {};

      # nix run
      apps = {};

      # nix fmt
      formatter = pkgs.alejandra;

      # nix develop -c $SHELL
      devShells.default = pkgs.mkShell {
        name = "default dev shell";

        buildInputs = with pkgs;
          [
            (python311Full.withPackages (ps:
              with ps; [
                pip
                setuptools
              ]))
            python311Packages.venvShellHook
            uv
          ]
          ++ pkgs.lib.optionals (pkgs.stdenv.isLinux) [
            pythonManylinuxPackages.manylinux1
          ];

        packages = with pkgs; [
        ];

        venvDir = ".venv";
      };
    });
  in
    outputs;
}
