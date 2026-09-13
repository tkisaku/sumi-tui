{ sumiPkgs, ... }:
{
  programs.lazydocker = {
    enable = true;
    package = sumiPkgs.lazydocker;
  };
}
