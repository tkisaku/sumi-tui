{ lib, stdenvNoCC, fetchurl, zellij }:
let
  version = "0.17.0";
  sources = {
    x86_64-linux = { platform = "linux_amd64"; hash = "sha256-kI4ybbrib7N7oB5FCeu4awgTDA9ZuBcJf/ylkjcmAAM="; };
    aarch64-linux = { platform = "linux_arm64"; hash = "sha256-WKLNKC7ivS7lC15dULUnehHon1AzPiBs2lUc+JDxtCY="; };
    x86_64-darwin = { platform = "darwin_amd64"; hash = "sha256-OVujGWTEcR+2ecWFnhe+BtPRgndwBKn4Te4GbGjyCTo="; };
    aarch64-darwin = { platform = "darwin_arm64"; hash = "sha256-V8hj3oVzL6DPB0+0EkyrYZx+tzgILem9bn2mfJLSmmY="; };
  };
  source = sources.${stdenvNoCC.hostPlatform.system}
    or (throw "cc-deck: unsupported system ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  pname = "cc-deck";
  inherit version;

  src = fetchurl {
    url = "https://github.com/cc-deck/cc-deck/releases/download/v${version}/cc-deck_${version}_${source.platform}.tar.gz";
    inherit (source) hash;
  };
  sourceRoot = ".";

  # The installer resolves its target dirs only once it finds zellij.
  nativeBuildInputs = [ zellij ];

  dontConfigure = true;
  dontBuild = true;

  # The Zellij plugin ships embedded in the CLI. Let its installer unpack it
  # into a scratch config dir (no claude on PATH, so it adds no hooks) and
  # keep only the wasm.
  installPhase = ''
    runHook preInstall
    install -Dm755 cc-deck $out/bin/cc-deck

    export HOME=$TMPDIR XDG_CACHE_HOME=$TMPDIR/cache ZELLIJ_CONFIG_DIR=$TMPDIR/zellij
    $out/bin/cc-deck config plugin install --force --skip-backup >/dev/null
    install -Dm644 $ZELLIJ_CONFIG_DIR/plugins/cc_deck.wasm $out/share/cc-deck/cc_deck.wasm
    runHook postInstall
  '';

  meta = {
    description = "Zellij sidebar for monitoring Claude Code sessions";
    homepage = "https://github.com/cc-deck/cc-deck";
    license = lib.licenses.asl20;
    mainProgram = "cc-deck";
    platforms = builtins.attrNames sources;
  };
}
