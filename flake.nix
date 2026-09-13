{
  description = "墨 - minimal strokes, maximum expression";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, zjstatus, ... }: {
    homeManagerModules.default = { pkgs, ... }: {
      imports = [ ./modules ];
      _module.args.zjstatus = zjstatus.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
}
