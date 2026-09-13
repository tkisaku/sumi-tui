{ sumiPkgs, ... }:
{
  programs.lazygit = {
    enable = true;
    package = sumiPkgs.lazygit;
  };
  home.packages = with sumiPkgs; [
    commitizen
    gitflow
  ];
  xdg.configFile."lazygit/config.yml".source = ./config.yml;
}
