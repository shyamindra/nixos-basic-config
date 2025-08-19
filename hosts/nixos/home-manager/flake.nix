{
  description = "Home Manager configuration for sid";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "sid";
      hostname = "nixos";

      overlay-cursor = final: prev: {
        cursor = prev.callPackage ./pkgs/cursor-appimage.nix { };
      };
    in {
      homeConfigurations."${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay-cursor ];
          config = { allowUnfree = true; };
        };
        modules = [
          {
            home.username = username;
            home.homeDirectory = "/home/${username}";
            home.stateVersion = "24.11";
            home.packages = [
              (
                # Expose as pkgs.cursor via overlay
                (import nixpkgs { inherit system; overlays = [ overlay-cursor ]; config = { allowUnfree = true; }; }).cursor
              )
            ];
          }
          (import ./home.nix)
        ];
      };
    };
}
