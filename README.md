# dsyang nix configs

Using nix for my dotfiles and programs

## installation on macos

### 1. Install nix:
https://nix.dev/tutorials/install-nix#macos

`sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --daemon`

This installs nix in multi-user mode which will create users like _nixbld[1..32]

### 2. Install home-manager
Follow https://ghedam.at/24353/tutorial-getting-started-with-home-manager-for-nix

If/when there's a problem with $NIX_PATH not being found: 
follow comment : https://github.com/nix-community/home-manager/issues/2564#issuecomment-994960513 in appending to ~/.zshenv

### 3. Setup `home.nix`
Clone this repo and symlink to ~/.config/nixpkgs
`ln -s /Users/dsyang/nixfiles /Users/dsyang/.config/nixpkgs`

### 4. Run `home-manager` to init


## Cheat sheet

- `home-manager switch` to rebuild env
- `home-manager generations` to see rebuild history
- `<path to old generation>/activate` to rollback

