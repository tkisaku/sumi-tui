{ ... }:
{
  programs.helix = {
    enable = true;

    defaultEditor = true;
    settings = {
      editor = {
        true-color = true;
        clipboard-provider = "termcode";
        auto-save.after-delay.enable = true;
        cursor-shape.insert = "bar";
      };
      theme = "tokyonight_storm";
    };

  };

  xdg.configFile."helix/languages.toml".text = ''
    [[language]]
    name = "nix"
    auto-format = true
    [language.formatter]
    command = "nixfmt"

    [[language]]
    name = "c"
    auto-format = true
    [[language]]
    name = "typescript"
    roots = ["deno.json", "deno.jsonc"]
    file-types = ["ts", "tsx"]
    auto-format = true
    language-servers = ["deno"]

    [[language]]
    name = "javascript"
    roots = ["deno.json", "deno.jsonc"]
    file-types = ["js", "jsx"]
    auto-format = true
    language-servers = ["deno"]

    [[language]]
    name = "json"
    roots = ["deno.json", "deno.jsonc"]
    language-servers = ["deno"]

    [language-server.deno]
    command = "deno"
    args = ["lsp"]

    [language-server.deno.config.deno]
    enable = true

    [[language]]
    name = "markdown"
    formatter = { command = "deno", args = ["fmt", "--ext", "md", "-"]}
  '';
}
