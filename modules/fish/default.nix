{
  imports = [
    ./aliases.nix
  ];

  programs.fish = {
    enable = true;
    functions = {
      fuzzy_complete = ''
        set -l token (commandline -t)
        set -l completions (complete -C (commandline -cp))
        set -l count (count $completions)
        if test $count -eq 0
          return
        else if test $count -eq 1
          set -l word (string split \t -- $completions[1])[1]
          commandline --current-token --replace -- (string escape -- $word)
        else
          set -l selected (printf '%s\n' $completions | fzf --height 40% --reverse -q "$token" | cut -f1)
          if test -n "$selected"
            commandline --current-token --replace -- (string escape -- $selected)
          end
        end
        commandline -f repaint
      '';
    };
    interactiveShellInit = ''
      bind \t fuzzy_complete
    '';
  };

  programs.fzf.enableFishIntegration = true;
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
