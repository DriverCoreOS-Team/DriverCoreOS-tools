{
  description = "DriverCoreOS – Multi-environment development setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Define shared Python environment
        pythonDeps = ps: with ps; [ pyqt5 pyserial numpy matplotlib ];

        pythonEnv = pkgs.python3.withPackages pythonDeps;

        commonDeps = with pkgs; [
          git
        ];

        commonEnv = with pkgs; commonDeps;

      in {
        devShells = {
          # For ESP32 firmware development
          esp32 = pkgs.mkShell {
            name = "esp32-dev-shell";
            packages = with pkgs; [ commonEnv pythonEnv platformio esptool minicom ];
          };

          # For Raspberry Pi software (UI, plugins, etc.)
          rpi = pkgs.mkShell {
            name = "rpi-dev-shell";
            packages = with pkgs; [
              commonEnv
              pythonEnv
            ];
          };

          # For building and editing documentation
          docs = pkgs.mkShell {
            name = "docs-dev-shell";
            packages = with pkgs; [ commonEnv mdbook mdbook-mermaid ];
          };
        };
      });
}
