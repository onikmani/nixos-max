{
  description = "MAX Messenger for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];

      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          });
    in
    {
      packages = forAllSystems ({ pkgs }:
        {
          default = pkgs.callPackage ./max.nix {};
          max = pkgs.callPackage ./max.nix {};
        });

      apps = forAllSystems ({ pkgs }:
        {
          default = {
            type = "app";
            program = "${self.packages.${pkgs.system}.default}/bin/max";
            meta = {
              description = "MAX Messenger for NixOS";
            };
          };

          max = {
            type = "app";
            program = "${self.packages.${pkgs.system}.max}/bin/max";
            meta = {
              description = "MAX Messenger for NixOS";
            };
          };
        });
    };
}
