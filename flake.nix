{
  description = "DriverCoreOS Development Flake (Python 3.13, ESP32, RPi)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        python = pkgs.python313;

        # Base Python 3.13 environment with commonly used libraries
        pythonCommon = python.withPackages (ps: with ps; [
          pyserial
          requests
          numpy
        ]);

        pythonEnv = python.withPackages (ps: with ps; [
          pyqt5
          qtpy
          qtconsole
        ]);

        # Shared CLI tools
        commonPackages = [
          python
          pythonCommon
          pkgs.git
        ];
      in {
        devShells = {
          esp32 = pkgs.mkShell {
            name = "esp32-dev";
            buildInputs = commonPackages ++ [
              pkgs.platformio
            ];
          };

          rpi = pkgs.mkShell {
            name = "rpi-dev";
            buildInputs = commonPackages ++ [
              pythonEnv
            ];
          };

          default = pkgs.mkShell {
            name = "drivercoreos-dev";
            buildInputs = commonPackages ++ [
            ];
          };
        };
      }
    );
}
