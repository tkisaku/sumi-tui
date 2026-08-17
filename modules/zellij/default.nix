{ config, ... }:
let
  editor = config.home.sessionVariables.EDITOR or "vim";
in
{
  programs.zellij = {
    enable = true;
    exitShellOnExit = true;
  };
  xdg.configFile."zellij/config.kdl".text =
    builtins.replaceStrings [ ''scrollback_editor "vim"'' ] [ ''scrollback_editor "${editor}"'' ]
      (builtins.readFile ./config.kdl);
  xdg.configFile."zellij/layouts/sumi.kdl".source = ./layouts/sumi.kdl;
}
