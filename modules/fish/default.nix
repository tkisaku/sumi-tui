{
  imports = [
    ./aliases.nix
  ];

  programs.fish = {
    enable = true;
    functions = {
      fuzzy_complete = ''
        set -l cmd (commandline -o)
        set -l token (commandline -t)
        set -l selected (complete -C (commandline -cp) | fzf --height 40% --reverse -q "$token" | cut -f1)
        if test -n "$selected"
          commandline --current-token --replace -- (string escape -- $selected)
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
