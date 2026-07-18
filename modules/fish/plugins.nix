{ pkgs, ... }:

{
  # Enable Fish with plugins
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf;
      }
    ];
  };
}
