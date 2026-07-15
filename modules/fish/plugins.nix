{ pkgs, ... }:

{
  # Install packages for the user
  home.packages = with pkgs; [
    grc
  ];

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
