{ config, lib, osConfig ? { }, sumiPkgs, zjstatus, ... }:
let
  editor =
    config.home.sessionVariables.EDITOR
      or osConfig.environment.variables.EDITOR
      or "vim";
in
{
  assertions = [
    {
      assertion = lib.versions.majorMinor sumiPkgs.zellij.version == "0.45";
      message = "sumi-tui requires Zellij 0.45.x, but got ${sumiPkgs.zellij.version}";
    }
  ];

  programs.zellij = {
    enable = true;
    exitShellOnExit = true;
    package = sumiPkgs.zellij;
  };
  xdg.configFile."zellij/config.kdl".text =
    builtins.replaceStrings [ ''scrollback_editor "vim"'' ] [ ''scrollback_editor "${editor}"'' ]
      (builtins.readFile ./config.kdl);
  xdg.configFile."zellij/layouts/sumi.kdl".text =
    builtins.replaceStrings [ "@zjstatus@" ] [ "${zjstatus}" ]
      (builtins.readFile ./layouts/sumi.kdl);
}
