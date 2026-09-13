{ config, osConfig ? { }, zjstatus, ... }:
let
  editor =
    config.home.sessionVariables.EDITOR
      or osConfig.environment.variables.EDITOR
      or "vim";
in
{
  programs.zellij = {
    enable = true;
    exitShellOnExit = true;
  };
  xdg.configFile."zellij/config.kdl".text =
    builtins.replaceStrings [ ''scrollback_editor "vim"'' ] [ ''scrollback_editor "${editor}"'' ]
      (builtins.readFile ./config.kdl);
  xdg.configFile."zellij/layouts/sumi.kdl".text =
    builtins.replaceStrings [ "@zjstatus@" ] [ "${zjstatus}" ]
      (builtins.readFile ./layouts/sumi.kdl);
}
