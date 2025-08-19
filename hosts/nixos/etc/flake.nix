{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    cursor.url = "github:omarcresp/cursor-flake/main";
  };

  outputs = { self, nixpkgs, cursor, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
	({ pkgs, ... }: {
          environment.systemPackages = [ cursor.packages.${pkgs.system}.default ];
        })
      ];
    };
  };
}
