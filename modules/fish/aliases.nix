{ ... }:
{
  programs.fish = {
    shellAliases = {
      # Better core utils
      cd = "z";
      cat = "bat";
      diff = "delta --diff-so-fancy --side-by-side";
      man = "BAT_THEME='default' batman";
      less = "bat";
      tt = "gtrash put";

      # File listing (eza)
      l = "eza --icons  -a --group-directories-first -1";
      ll = "eza --icons  -a --group-directories-first -1 --no-user --long";
      tree = "eza --icons --tree --group-directories-first";

      # TUI launchers
      g = "lazygit";
      y = "yazi";
    };
  };
}
