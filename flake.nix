{
  description = "墨 - minimal strokes, maximum expression";

  inputs = {
    # This revision provides Zellij 0.45.1.
    nixpkgs.url = "github:NixOS/nixpkgs/eaad089433ca2bb662274377d33df3d0e51ef28b";
    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, zjstatus, ... }: {
    homeManagerModules.default = { pkgs, ... }: {
      imports = [ ./modules ];
      _module.args.sumiPkgs =
        nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      _module.args.zjstatus = zjstatus.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
}
