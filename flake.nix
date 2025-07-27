{
  description = "DriverCoreOS Development Flake (Simplified)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Python environment with shared packages
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          pyserial
        ]);

        common = with pkgs; [
          git
        ];
      in {
        devShells = {
          esp32 = pkgs.mkShell {
            name = "esp32-dev";
            buildInputs = common ++ [
              pkgs.platformio
              pythonEnv
            ];
          };

          rpi = pkgs.mkShell {
            name = "rpi-dev";
            buildInputs = common ++ [
              pythonEnv
              pkgs.pyqt5
            ];
          };

          default = pkgs.mkShell {
            name = "drivercoreos-dev";
            buildInputs = common;
          };
        };
      }
    );
}
