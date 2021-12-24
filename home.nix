{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "dsyang";
  home.homeDirectory = "/Users/dsyang";

  home.packages = [
    pkgs.tmux
  ];

  # Raw configuration files

  home.file.".gitconfig".source = ./osx/gitconfig;

  home.file.".tmux.d".source = ./osx/tmux/tmux.d;
  home.file.".tmux.conf".source = ./osx/tmux/tmux.conf;
  
  home.file.".zshrc".source = ./osx/zshrc;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
