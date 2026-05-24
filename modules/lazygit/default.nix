{ pkgs, ... }:
{
  programs.lazygit.enable = true;
  home.packages = with pkgs; [
    commitizen
    git-flow
  ];
  xdg.configFile."lazygit/config.yml".source = ./config.yml;
}
