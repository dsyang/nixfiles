###########
## nix-darwin install
###########
export NIX_PATH=darwin-config=$HOME/.config/nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
#export NIX_PATH=darwin=$HOME/.nix-defexpr/darwin:darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$NIX_PATH

###########
## nix home manager
###########
source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh