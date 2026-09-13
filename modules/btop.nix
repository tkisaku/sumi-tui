{ sumiPkgs, ... }:
{
  programs.btop = {
    enable = true;
    package = sumiPkgs.btop;

    settings = {
      color_theme = "TTY";
      theme_background = false;
      update_ms = 500;
      rounded_corners = false;
    };
  };
}
