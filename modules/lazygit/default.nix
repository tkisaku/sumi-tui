{ pkgs, ... }:
{
  # Install lazygit directly instead of enabling programs.lazygit: the
  # home-manager module also declares lazygit/config.yml, which collides
  # with the config file shipped below.
  home.packages = with pkgs; [
    lazygit
    commitizen
    gitflow
  ];
  xdg.configFile."lazygit/config.yml".source = ./config.yml;
}
