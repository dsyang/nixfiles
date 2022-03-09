# dsyang nix configs

Using nix for my dotfiles and programs

# Getting Started with `nix`, `nix-darwin`, and `home-manager` on apple silicon. 
Main reference: https://gist.github.com/mandrean/65108e0898629e20afe1002d8bf4f223
## 0. Clone this repo with included git 
symlink repo into ~/.config/nixpkgs
`ln -s /Users/dsyang/nixfiles /Users/dsyang/.config/nixpkgs`

setup nix path stuff in ~/.zshrc:
- point to your nix-darwin config file in the symlinked location.
`export NIX_PATH=darwin-config=$HOME/.config/nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH`
- Include for home-manager from the main reference. 
`source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh`


## 1.1 Install nix:
source: https://nix.dev/tutorials/install-nix#macos

`sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --daemon`

This installs nix in multi-user mode which will create users like _nixbld[1..32]. Important to note should you choose to uninstall nix.

## 1.2 verify `nix` installation:
`nix-shell -p nix-info --run "nix-info -m"` 
- `nix-shell` starts a shell with a particular config
- `-p nix-info` config is a `nix-info` package. 
- `--run ...` run the following prompt. Without this. `nix-shell` drops you into a repl with the package installed.

## 2. Install `home-manager`
source: https://ghedam.at/24353/tutorial-getting-started-with-home-manager-for-nix
`home-manager` is something that lets you use nix setup user-specific configs like dotfiles. 

- `nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager`
- `nix-channel --update`
- `nix-shell '<home-manager>' -A install`
- `home-manager switch` must call this to rebuild the system (until nix-darwin installed)

If/when there's a problem with $NIX_PATH not being found: 
follow comment : https://github.com/nix-community/home-manager/issues/2564#issuecomment-994960513 in appending to ~/.zshenv
`$ echo 'export NIX_PATH=${NIX_PATH:+$NIX_PATH:}$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels\n' >> ~/.zshenv `

## 2.2 verify `home-manager` installation. 
- calling `home-manager` does something.

## Cheat sheet (pre-darwin)
NOTE: as of now, `home-manager` isn't used to configure anything anymore. See the commit tagged `separate-home-manager` for when home manager was still used separately.
- `home-manager switch` to rebuild env
- `home-manager generations` to see rebuild history
- `<path to old generation>/activate` to rollback

## 3. Install `nix-darwin`
source: https://opensourcelibs.com/lib/nix-darwin
`nix-darwin` lets you configure your macos system let changing preferences in finder & more. It includes modules for configuring other nix things like `home-manager`

- `nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer`
- `./result/bin/darwin-installer`
   - (no edit, yes manage with nix-channel)
   - yes add to bashrc/zshrc/create run
`nix-shell '<darwin>' -A installer`

## 3.2 verify installation:
`darwin-rebuild switch`

if you hit `error: not linking environment.etc."nix/nix.conf" because /etc/nix/nix.conf already exists, skipping...`, remove the existing `nix.conf` created by the nix install in favor of the one created by nix-darwin:

`sudo cp /etc/nix/nix.conf /etc/nix/nix.conf-before-nix-darwin; sudo rm /etc/nix/nix.conf`


## 3.3 Cheatsheet 
- `darwin-rebuild switch` to rebuild env
- `darwin-rebuild --list-generations` to see build history
- `darwin-rebuild --rollback` to go to previous generation


# Uninstalling nix. 
https://iohk.zendesk.com/hc/en-us/articles/4415830650265-Uninstall-nix-on-MacOS
## -3. Uninstalling a nix-darwin install
## -2. Uninstalling a home-manager install
## -1. Uninstalling Nix.


# Further reading:
https://cuddly-octo-palm-tree.com/posts/2021-12-19-tyska-nix-shell/
