{ config, lib, osConfig ? { }, sumiPkgs, zjstatus, ... }:
let
  editor =
    config.home.sessionVariables.EDITOR
      or osConfig.environment.variables.EDITOR
      or "vim";

  ccDeck = sumiPkgs.callPackage ./cc-deck.nix { };
  # Served from a fixed path so its permission grant survives rebuilds; it is
  # also where the cc-deck CLI expects the plugin.
  ccDeckWasm = "${config.xdg.configHome}/zellij/plugins/cc_deck.wasm";
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
  home.packages = [ ccDeck ];

  xdg.configFile."zellij/config.kdl".text =
    builtins.replaceStrings
      [ ''scrollback_editor "vim"'' "@ccDeckWasm@" ]
      [ ''scrollback_editor "${editor}"'' ccDeckWasm ]
      (builtins.readFile ./config.kdl);
  xdg.configFile."zellij/layouts/sumi.kdl".text =
    builtins.replaceStrings [ "@zjstatus@" "@ccDeckWasm@" ] [ "${zjstatus}" ccDeckWasm ]
      (builtins.readFile ./layouts/sumi.kdl);
  xdg.configFile."zellij/plugins/cc_deck.wasm".source = "${ccDeck}/share/cc-deck/cc_deck.wasm";

  # Zellij keys granted plugin permissions by absolute path, and the zjstatus
  # store path changes on every rebuild, so pre-grant them to skip the prompt.
  # cc-deck's controller runs in the background and cannot show the prompt at
  # all, so it only starts with a cached grant.
  home.activation.zellijPluginPermissions = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    let
      permissions = "${config.xdg.cacheHome}/zellij/permissions.kdl";
      grant = sumiPkgs.writeShellScript "zellij-grant-plugin" ''
        set -eu
        file=$1 wasm=$2
        shift 2
        mkdir -p "$(dirname "$file")"
        touch "$file"
        {
          ${sumiPkgs.gawk}/bin/awk -v key="\"$wasm\" {" \
            '$0 == key { skip = 1; next } skip && $0 == "}" { skip = 0; next } !skip' "$file"
          printf '"%s" {\n' "$wasm"
          printf '    %s\n' "$@"
          printf '}\n'
        } > "$file.tmp"
        mv "$file.tmp" "$file"
      '';
    in
    ''
      run ${grant} "${permissions}" "${zjstatus}/bin/zjstatus.wasm" \
        ReadApplicationState ChangeApplicationState RunCommands
      run ${grant} "${permissions}" "${ccDeckWasm}" \
        ReadApplicationState ChangeApplicationState RunCommands ReadCliPipes \
        MessageAndLaunchOtherPlugins Reconfigure WriteToStdin
    ''
  );

  # cc-deck learns about Claude Code sessions from hooks that forward events to
  # the plugin. ~/.claude/settings.json is edited in place by Claude Code, so
  # merge the hooks in (as `cc-deck config plugin install` would) rather than
  # owning the file.
  home.activation.ccDeckClaudeHooks = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    let
      settings = "${config.home.homeDirectory}/.claude/settings.json";
      merge = sumiPkgs.writeShellScript "cc-deck-claude-hooks" ''
        set -eu
        file=$1
        if [ -L "$file" ]; then
          echo "cc-deck: $file is a symlink, not adding hooks" >&2
          exit 0
        fi
        mkdir -p "$(dirname "$file")"
        [ -s "$file" ] || echo '{}' > "$file"
        ${sumiPkgs.jq}/bin/jq --indent 2 '
          def ccdeck: any(.hooks[]?; .command | startswith("cc-deck hook"));
          (.hooks // {} | map_values(map(select(ccdeck | not)) | select(length > 0))) as $hooks
          | .hooks = reduce (
              "SessionStart", "PostToolUse", "PostToolUseFailure", "UserPromptSubmit",
              "PermissionRequest", "Notification", "Stop", "SubagentStop",
              "SubagentStart", "SessionEnd"
            ) as $event ($hooks;
              .[$event] += [
                (if $event == "PermissionRequest" or $event == "Notification"
                 then { matcher: "" } else { } end)
                + { hooks: [ { type: "command", command: "cc-deck hook --agent claude --pane-id \"$ZELLIJ_PANE_ID\"" } ] }
              ])
        ' "$file" > "$file.tmp"
        if cmp -s "$file" "$file.tmp"; then
          rm "$file.tmp"
        else
          mv "$file.tmp" "$file"
        fi
      '';
    in
    ''
      run ${merge} "${settings}"
    ''
  );
}
