{
  description = "atoshi's dotfiles - cross-platform Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }:
    let
      # Helper to make system-specific packages
      forAllSystems = nixpkgs.lib.genAttrs [ "aarch64-darwin" "x86_64-linux" "aarch64-linux" ];
    in
    {
      # macOS configuration (nix-darwin + home-manager)
      darwinConfigurations."atoshi-mac" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./nix/hosts/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.atoshi = { ... }: {
              imports = [
                ./nix/home/common.nix
                ./nix/home/darwin.nix
              ];
            };
          }
        ];
      };

      # Linux configuration (standalone home-manager)
      homeConfigurations."atoshi-linux" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./nix/home/common.nix
          ./nix/home/linux.nix
          {
            home.username = "atoshi";
            home.homeDirectory = "/home/atoshi";
          }
        ];
      };

      # aarch64-linux (e.g., Raspberry Pi, ARM servers)
      homeConfigurations."atoshi-linux-arm" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        modules = [
          ./nix/home/common.nix
          ./nix/home/linux.nix
          {
            home.username = "atoshi";
            home.homeDirectory = "/home/atoshi";
          }
        ];
      };

      # Flake checks
      checks = forAllSystems (system: {
        # Basic check that the flake evaluates
        default = nixpkgs.legacyPackages.${system}.hello;
      });
    };
}
