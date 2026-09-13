{ sumiPkgs, ... }:
{
  programs.atuin = {
    enable = true;
    package = sumiPkgs.atuin;
    enableFishIntegration = true;
    settings = {
      enter_accept = true;
    };
  };
}
