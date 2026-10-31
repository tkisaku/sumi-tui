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
    package = sumiPkgs.zellij;
  };
  xdg.configFile."zellij/config.kdl".text =
    builtins.replaceStrings [ ''scrollback_editor "vim"'' ] [ ''scrollback_editor "${editor}"'' ]
      (builtins.readFile ./config.kdl);
  xdg.configFile."zellij/layouts/sumi.kdl".text =
    builtins.replaceStrings [ "@zjstatus@" ] [ "${zjstatus}" ]
      (builtins.readFile ./layouts/sumi.kdl);

  # Zellij keys granted plugin permissions by absolute path, and the zjstatus
  # store path changes on every rebuild, so pre-grant them to skip the prompt.
  home.activation.zellijPluginPermissions = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    let
      wasm = "${zjstatus}/bin/zjstatus.wasm";
      permissions = "${config.xdg.cacheHome}/zellij/permissions.kdl";
    in
    ''
      if ! grep -qF '"${wasm}"' "${permissions}" 2>/dev/null; then
        run mkdir -p "$(dirname "${permissions}")"
        run sh -c 'printf "%s\n" "\"${wasm}\" {" "    ReadApplicationState" "    ChangeApplicationState" "    RunCommands" "}" >> "${permissions}"'
      fi
    ''
  );
}
