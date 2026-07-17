{ config, pkgs, lib, ... }:

{
  # Point darwin to a checkout of the dsyang/nix-darwin repo

  imports = [
    <home-manager/nix-darwin>
  ];

  # Home-manager setup: my user-specific files
  users.users.dsyang = {
    name = "dsyang";
    home = "/Users/dsyang";
  };

  home-manager = {
    users.dsyang = { pkgs, home, ... }:
      {
        nixpkgs.config = {
          allowUnfree = true;
        };

        home.packages = with pkgs; [
          httpie
          tmux
          eza
          deno
          m-cli
          jq
          gh
          direnv
        ] ++ lib.optionals stdenv.isDarwin [
          cocoapods
          m-cli # useful macOS CLI commands
        ];

        # Raw configuration files
        home.file = {
          ".gitconfig".source = ./osx/gitconfig;
          ".tmux.d".source = ./osx/tmux/tmux.d;
          ".tmux.conf".source = ./osx/tmux/tmux.conf;
          ".terminfo/78/xterm-kitty".source = ./osx/xterm-kitty-terminfo;
          ".ripgreprc".source = ./osx/ripgreprc;
        };

        # This value determines the Home Manager release that your
        # configuration is compatible with. This helps avoid breakage
        # when a new Home Manager release introduces backwards
        # incompatible changes.
        #
        # You can update Home Manager without changing this value. See
        # the Home Manager release notes for a list of state version
        # changes in each release.
        home.stateVersion = "22.11";

        programs = {
          autojump.enable = true;

          gh = {
            enable = true;
            settings = {
              git_protocol = "ssh";
              prompt = "enabled";
            };
          };

          zsh = {
            enable = true;

            profileExtra = ''
              # Skip /etc/zshrc which runs redundant compinit + promptinit
              export NOSYSZSHRC=1
            '';

            completionInit = "autoload -Uz compinit && compinit -C";

            history = {
              expireDuplicatesFirst = true;
              extended = true;
              save = 1000;
              size = 1000;
            };

            localVariables = {
              HOSTNAME = "\${HOST}";
              LC_ALL = "en_US.UTF-8";
              LANG = "en_US.UTF-8";
              LC_CTYPE = "en_US.UTF-8";
              PAGER = "less";
            };

            shellAliases = {
              claude = "/Users/dsyang/.local/bin/mav";
              codex = "/Users/dsyang/.local/bin/iceman";
              ll = "ls -alh";
              freespace = "df -H";
              sftp = "rlwrap sftp";
              hg = "echo 'sapling\n' && sl";
              gsl = "git sl";
              gst = "git st";
              gad = "git add";
              gch = "git switch";
              gnew = "git switch -c";
              grei = "git rebase -i --update-refs";
              gmain = "git co main; git pull origin main; git co -";
            };

            initContent = lib.mkMerge [
              (lib.mkBefore ''
              export DISABLE_AUTO_TITLE="true"
              export COMPLETION_WAITING_DOTS="true"
              export EDITOR="vim"
              PATH="/Users/dsyang/bin:$PATH"

              # Emacs keybindings (was in /etc/zshrc which we skip via NOSYSZSHRC)
              bindkey -e

              # Set BREW_PREFIX to avoid slow `brew --prefix` call inside autojump.zsh
              export BREW_PREFIX="''${HOMEBREW_PREFIX:-/opt/homebrew}"
              '')

              (builtins.readFile ./zshrc-snippets/prompt.zsh)
              (builtins.readFile ./zshrc-snippets/homebrew.zsh)
              (builtins.readFile ./zshrc-snippets/java-android.zsh)
              (builtins.readFile ./zshrc-snippets/rust.zsh)
              (builtins.readFile ./zshrc-snippets/vscode.zsh)
              (builtins.readFile ./zshrc-snippets/nix.zsh)
              (builtins.readFile ./zshrc-snippets/ruby.zsh)
              (builtins.readFile ./zshrc-snippets/misc-functions.zsh)
              (builtins.readFile ./zshrc-snippets/notion.zsh)
              (builtins.readFile ./zshrc-snippets/nocommit.notion.zsh)
            ];
          };
          };
        };
      };

  # add touchid support to sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.vim
    pkgs.ripgrep
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin-configuration.nix
  environment.darwinConfig = "/Users/dsyang/.config/nixpkgs/darwin-configuration.nix";

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina

  # Setup macos system values
  # NOTE: things need to be at default settings (such as keyboard modifiers) for this to take effect
  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true; # System prefs will still show "Caps Lock"
    };
    primaryUser = "dsyang";
    defaults = {
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

        # custom options from dsyang/nix-darwin
        AppleShowAllFiles = true;
      };

      dock = {
        # need to `killall Dock` for new settings to apply
        autohide = true;
        expose-animation-duration = 0.1;
        expose-group-apps = false;
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

        # custom options from dsyang/nix-darwin
        ShowStatusBar = true;
        ShowPathbar = true;
        FXDefaultSearchScope = "SCcf";
        FXPreferredViewStyle = "Nlsv";
      };

      screencapture = {
        disable-shadow = true;
        location = "/Users/dsyang/Documents";
      };

      # custom options from dsyang/nix-darwin
      ActivityMonitor = {
        OpenMainWindow = true;
        IconType = 5;
        ShowCategory = 100;
        SortColumn = "CPUUsage";
        SortDirection = 0;
      };
    };
  };
}
