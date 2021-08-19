{ config, pkgs, ... }:

let
  cursor-theme-name = "Bibata_Turquoise";
in
{
  home.packages = [
    pkgs.editorconfig-core-c
    pkgs.jq
    pkgs.nixfmt
    pkgs.rust-analyzer
    pkgs.shellcheck
    pkgs.spotify
    pkgs.spicetify-cli
    pkgs.playerctl
    pkgs.aseprite
    pkgs.signal-desktop
    pkgs.bat
    pkgs.xdg-utils
    pkgs.krita
    pkgs.gnome.nautilus
  ];

  # wayland.windowManager.sway = {
  #   extraConfig = ''
  #     seat seat0 xcursor_theme capitaine_cursors 24
  #   '';
  # };

  gtk.enable = true;
  gtk.gtk2.extraConfig = ''
    gtk-cursor-theme-name = "${cursor-theme-name}"
    gtk-enable-primary-paste = false
  '';
  gtk.gtk3.extraConfig = {
    gtk-cursor-theme-name = cursor-theme-name;
    gtk-enable-primary-paste = false;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
