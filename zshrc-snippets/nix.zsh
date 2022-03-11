###########
## nix-darwin install
###########
export NIX_PATH=darwin=$HOME/.nix-defexpr/darwin:$NIX_PATH

###########
## nix home manager
###########
source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh