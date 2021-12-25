{ config, pkgs, ... }:

{

  imports = [
    <home-manager/nix-darwin>
    ./osx/patches/security/pam.nix
  ];

  # Home-manager setup: my user-specific files
  users.users.dsyang = {
    name = "dsyang";
    home = "/Users/dsyang";
  };

  home-manager = {
    users.dsyang = {pkgs, home, ...}: {

      home.packages = [
        pkgs.httpie
        pkgs.tmux
        pkgs.exa
      ];

      # Raw configuration files
      home.file = {
        ".gitconfig".source = ./osx/gitconfig;
        ".tmux.d".source = ./osx/tmux/tmux.d;
        ".tmux.conf".source = ./osx/tmux/tmux.conf;
        ".zshrc".source = ./osx/zshrc;
      };


      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      home.stateVersion = "22.05";
    };
  };

  # add touchid support to sudo
  security.pam.enableSudoTouchIdAuth = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.vim
      pkgs.ripgrep
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin-configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Setup macos system values
  # NOTE: things need to be at default settings (such as keyboard modifiers) for this to take effect
  system = {
    stateVersion = 4;
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    
    defaults = {
      LaunchServices.LSQuarantine = false;
      
      NSGlobalDomain = {
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;

        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;

        NSDocumentSaveNewDocumentsToCloud = false;
      };

    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
#  system.stateVersion = 4;
}
