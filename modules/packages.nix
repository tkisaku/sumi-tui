{ sumiPkgs, ... }:
{
  home.packages = with sumiPkgs; [
    ## Better core utils
    eza # ls replacement
    bat # cat replacement
    fd # find replacement
    sd # sed replacement
    ripgrep # grep replacement
    yazi
    jq # JSON processor
  ];
}
