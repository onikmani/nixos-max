{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

let

  maxDeb = pkgs.fetchurl {
    url = "https://download.max.ru/linux/deb/pool/main/m/max/MAX-26.26.0.76189.deb";
    sha256 = "e31452f19e9524a54100c9ad80e2ff2c08cab1d2cfb55d2aac8f229a603d5003";
  };

  runtimePkgs = with pkgs; [
    # Basic
    glib
    zlib
    expat
    fontconfig
    freetype

    # Chromium / QtWebEngine
    nspr
    nss

    # X11
    libx11
    libxext
    libxdamage
    libxfixes
    libxrandr
    libxcomposite
    libxcursor
    libxi
    libxtst
    libxscrnsaver
    libxkbfile

    # XCB
    libxcb
    libxcb-util
    libxcb-cursor
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm

    # Input
    libxkbcommon

    # Graphics
    mesa
    libGL
    libdrm
    libgbm

    # Audio
    alsa-lib
    pulseaudio
    pipewire

    # Crypto
    libgcrypt
    libgpg-error

    # Images
    gdk-pixbuf

    # Notifications
    libnotify

    # DBus
    dbus

    # Desktop
    hicolor-icon-theme
    shared-mime-info
    gtk3
  ];

  maxApp = pkgs.stdenvNoCC.mkDerivation {
    pname = "max-app";
    version = "26.26.0";

    src = maxDeb;

    nativeBuildInputs = [
      pkgs.dpkg
    ];

    unpackPhase = ''
      mkdir unpacked
      dpkg -x "$src" unpacked
    '';

    installPhase = ''
      mkdir -p "$out/share"
      cp -r unpacked/usr/share/max "$out/share/max"
    '';

    dontStrip = true;
  };

  maxFhs = pkgs.buildFHSEnvBubblewrap {
    name = "max";

    targetPkgs = pkgs: runtimePkgs;

    multiPkgs = pkgs: runtimePkgs;

    unshareUser = false;

    extraPreBwrapCmds = ''
      mkdir -p "$HOME"
      mkdir -p "$XDG_RUNTIME_DIR"
    '';

    profile = ''
      export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath runtimePkgs}:${maxApp}/share/max/lib64:${maxApp}/share/max/bin/max-service/lib64:/usr/lib64:/usr/lib:$LD_LIBRARY_PATH"

      export QT_QPA_PLATFORM=xcb
      export QT_X11_NO_MITSHM=1

      export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
    '';

    runScript = "cd /tmp && exec ${maxApp}/share/max/bin/max";
  };

in

pkgs.stdenvNoCC.mkDerivation {
  pname = "max";
  version = "26.26.0";

  dontUnpack = true;

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/share/applications"

    ln -s ${maxFhs}/bin/max "$out/bin/max"

    cat > "$out/share/applications/max.desktop" <<EOF_DESKTOP
[Desktop Entry]
Name=MAX
Comment=MAX Messenger
Exec=$out/bin/max
Icon=${maxApp}/share/max/resources/icons/max.png
Terminal=false
Type=Application
Categories=Network;InstantMessaging;
EOF_DESKTOP
  '';
}
