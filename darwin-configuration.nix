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
              gmain = "git co main; git pull origin main";
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
#              (builtins.readFile ./zshrc-snippets/flutter.zsh)
#              (builtins.readFile ./zshrc-snippets/ocaml.zsh)
              (builtins.readFile ./zshrc-snippets/vscode.zsh)
              (builtins.readFile ./zshrc-snippets/nix.zsh)
              (builtins.readFile ./zshrc-snippets/ruby.zsh)
              (builtins.readFile ./zshrc-snippets/misc-functions.zsh)
              (builtins.readFile ./zshrc-snippets/notion.zsh)
              (builtins.readFile ./zshrc-snippets/nocommit.notion.zsh)
            ];
          };

          /*vscode = {
            # Want to only use this to control configuration.
            # Still need to download vscode manually
            enable = true;
            profiles = {
              default = {
                userSettings = {
                  "[typescript]" = {
                    "editor.defaultFormatter" = "esbenp.prettier-vscode";
                    "editor.formatOnSave" = true;
                  };
                  "[typescriptreact]" = {
                    "editor.defaultFormatter" = "esbenp.prettier-vscode";
                    "editor.formatOnSave" = true;
                  };
                  "[json]" = {
                    "editor.defaultFormatter" = "esbenp.prettier-vscode";
                  };
                  "files.trimTrailingWhitespace" = true;
                  "typescript.tsdk" = "./node_modules/typescript/lib";
                };

                keybindings = [
                  {
                    "key" = "ctrl+x 2";
                    "command" = "workbench.action.splitEditorDown";
                  }
                  {
                    "key" = "ctrl+x 3";
                    "command" = "workbench.action.splitEditorRight";
                  }
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
                  {
                    "key" =  "ctrl+x space";
                    "command" =  "workbench.action.gotoLine";
                  }
                ];
                extensions = (with pkgs.vscode-extensions; [
                  bbenoist.nix
                ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
                  {
                    # taken from the package.json
                    name = "vscode-cut-all-right";
                    publisher = "cou929";
                    version = "0.0.1";
                    # install without this value, look at error message for calculated sha256.
                    sha256 = "sha256-QBYOSklu1scLjMSQ2ZWFwr2+UoJMAZIxjeFdo5d67Lg=";
                  }
                  {
                    # taken from the marketplace unique id: <publisher>.<name>
                    name = "remote-ssh-edit";
                    publisher = "ms-vscode-remote";
                    version = "0.76.1"; #taken from marketplace UI
                    # install without this value, look at error message for calculated sha256.
                    sha256 = "sha256-VOl6l/4OXe7R+TznAKRgr8XU+CDp18qWC3y+K2bdC28=";
                  }
                  {
                    # taken from the marketplace unique id: <publisher>.<name>
                    name = "remote-ssh";
                    publisher = "ms-vscode-remote";
                    version = "0.76.1"; #taken from marketplace UI
                    # install without this value, look at error message for calculated sha256.
                    sha256 = "sha256-iLgGkf9hx75whXI+kmkmiGw3fnkEGp37Ae7GMdAz0+Y=";
                  }
                  {
                    # taken from the marketplace unique id: <publisher>.<name>
                    name = "prettier-vscode";
                    publisher = "esbenp";
                    version = "9.3.0"; #taken from marketplace UI
                    # install without this value, look at error message for calculated sha256.
                    sha256 = "sha256-hJgPjWf7a8+ltjmXTK8U/MwqgIZqBjmcCfHsAk2G3PA=";
                  }
                  {
                    # taken from the marketplace unique id: <publisher>.<name>
                    name = "kotlin";
                    publisher = "mathiasfrohlich";
                    version = "1.7.1"; #taken from marketplace UI
                    # install without this value, look at error message for calculated sha256.
                    sha256 = "sha256-MuAlX6cdYMLYRX2sLnaxWzdNPcZ4G0Fdf04fmnzQKH4=";
                  }
                  {
                    # taken from the marketplace unique id: <publisher>.<name>
                    name = "terraform";
                    publisher = "hashicorp";
                    version = "2.20.0"; #taken from marketplace UI
                    # install without this value, look at error message for calculated sha256.
                    sha256 = "sha256-ezMIX7m03y0dhoRLt7xs3zzif2LST3RVQmuUyBKh85s=";
                  }
                  {
                    # taken from the marketplace unique id: <publisher>.<name>
                    name = "gitlens";
                    publisher = "eamodio";
                    version = "12.0.4"; #taken from marketplace UI
                    # install without this value, look at error message for calculated sha256.
                    sha256 = "sha256-T39laV6yWu0yKtTT2dmVOriawkrsmE4YqpidWG7OPOg=";
                  }
                  {
                    # taken from the marketplace unique id: <publisher>.<name>
                    name = "vscode-pull-request-github";
                    publisher = "github";
                    version = "0.38.1"; #taken from marketplace UI
                    # install without this value, look at error message for calculated sha256.
                    sha256 = "sha256-opR+y818jrdyGGh61swbo0FWKJJCJzn6594km4B76d0=";
                  }
                  {
                    # taken from the marketplace unique id: <publisher>.<name>
                    name = "code-spell-checker";
                    publisher = "streetsidesoftware";
                    version = "2.1.7"; #taken from marketplace UI
                    # install without this value, look at error message for calculated sha256.
                    sha256 = "sha256-C0jYDIDBK1JH8eFaFmCUilBXCbU5y2TRF3OZAw9ijoY=";
                  }
                  {
                    # taken from the marketplace unique id: <publisher>.<name>
                    name = "shellcheck";
                    publisher = "timonwong";
                    version = "0.18.9"; #taken from marketplace UI
                    # install without this value, look at error message for calculated sha256.
                    sha256 = "sha256-D7lRMmmDgAHKPVyZMC06zNef8UtrgNEE+m0mTbIuc1A=";
                  }
                  {
                    # taken from the marketplace unique id: <publisher>.<name>
                    name = "vscode-fileutils";
                    publisher = "sleistner";
                    version = "3.5.0"; #taken from marketplace UI
                    # install without this value, look at error message for calculated sha256.
                    sha256 = "sha256-ulsa8nGNoFRUMVFXN00c9JvF2WeorAhbiCOLAJULVvo=";
                  }
                  {
                    # taken from the marketplace unique id: <publisher>.<name>
                    name = "vscode-eslint";
                    publisher = "dbaeumer";
                    version = "2.2.2"; #taken from marketplace UI
                    # install without this value, look at error message for calculated sha256.
                    sha256 = "sha256-llalyQXl+k/ugZq+Ti9mApHRqAGu6QyoMP51GtZnRJ4=";
                  }
                  {
                    # taken from the marketplace unique id: <publisher>.<name>
                    name = "vscode-docker";
                    publisher = "ms-azuretools";
                    version = "1.20.0"; #taken from marketplace UI
                    # install without this value, look at error message for calculated sha256.
                    sha256 = "sha256-i3gYTP76YEDItG2oXR9pEXuGv0qmyf1Xv6HQvDBEOyg=";
                  }
                  {
                    # taken from the marketplace unique id: <publisher>.<name>
                    name = "path-autocomplete";
                    publisher = "ionutvmi";
                    version = "1.19.1"; #taken from marketplace UI
                    # install without this value, look at error message for calculated sha256.
                    sha256 = "sha256-0hnmCnGgcflA8zFQvaE6iB8eWZIBJZH2plUr40Avtdk=";
                  }
                ];
              };
              };
            };*/
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

  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

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
      # LaunchServices.LSQuarantine = false;

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
