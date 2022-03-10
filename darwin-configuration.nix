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

      nixpkgs.config = {
        allowUnfree = true;
      };

      home.packages = with pkgs; [
        httpie
        tmux
        exa
        deno
        m-cli
        jq
      ] ++ lib.optionals stdenv.isDarwin [
        cocoapods
        m-cli # useful macOS CLI commands
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

      programs = {

        vscode = {
          # Want to only use this to control configuration.
          # Still need to download vscode manually
          enable = true;

          userSettings = {
            "files.trimTrailingWhitespace" = true;
          };

          keybindings = [
            {
              "key" = "ctrl+x ctrl+s";
              "command" = "workbench.action.files.save";
            }
            {
              "key" = "ctrl+alt+f";
              "command" = "cursorWordPartRight";
              "when" =  "textInputFocus";
            }
            {
              "key" = "ctrl+alt+b";
              "command" = "cursorWordPartLeft";
              "when" = "textInputFocus";
            }
            {
              "key" = "ctrl+k";
              "command" = "-deleteAllRight";
              "when" = "textInputFocus && !editorReadonly";
            }
            {
              "key" = "ctrl+y";
              "command" = "editor.action.clipboardPasteAction";
            }
          ];

          extensions = (with pkgs.vscode-extensions; [
            bbenoist.nix
          ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
            # taken from the package.json
            name = "vscode-cut-all-right";
            publisher = "cou929";
            version = "0.0.1";
            # install without this value, look at error message for calculated sha256.
            sha256 = "sha256-QBYOSklu1scLjMSQ2ZWFwr2+UoJMAZIxjeFdo5d67Lg=";
          }];
        };

      };

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
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true; # System prefs will still show "Caps Lock"
    };

    defaults = {
      LaunchServices.LSQuarantine = false;

      NSGlobalDomain = {
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;

        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;

        NSDocumentSaveNewDocumentsToCloud = false;

        "com.apple.swipescrolldirection" = false;

        NSAutomaticSpellingCorrectionEnabled = false;

        AppleKeyboardUIMode = 3;

        AppleFontSmoothing = 2;
      };

      dock = {
        # need to `killall Dock` for new settings to apply
        autohide = true;
        expose-animation-duration = "0.1";
        expose-group-by-app = false;
        mru-spaces = false;
        orientation = "bottom";
        show-recents = false;
        tilesize = 48;
      };

      finder = {
        # killall Finder to apply
        AppleShowAllExtensions = true;
        CreateDesktop = false;
        _FXShowPosixPathInTitle = true;
        FXEnableExtensionChangeWarning = false;
      };

      screencapture = {
        disable-shadow = true;
        location = "/Users/dsyang/Documents";
      };

    };
  };

}
