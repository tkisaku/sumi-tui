{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Better core utils
    eza # ls replacement
    bat # cat replacement
    fd # find replacement
    sd # sed replacement
    ripgrep # grep replacement
    yazi
    gtrash # rm replacement, put deleted files in system trash

    ## Modern TUI tools
    jq # JSON processor
  ];
}
