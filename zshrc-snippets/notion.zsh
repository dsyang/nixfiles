# --- Cached notion completion (saves ~180ms) ---
_notion_comp_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/notion_completion.zsh"
if [[ ! -s "$_notion_comp_cache" ]]; then
  mkdir -p "${_notion_comp_cache:h}"
  notion completion --install > "$_notion_comp_cache" 2>/dev/null
fi
source "$_notion_comp_cache" 2>/dev/null
unset _notion_comp_cache

alias boxy="notion boxy"


export NOTION_NO_PREPUSH=true
export NOTION_HOME="/Users/dsyang/notion-next"

# --- Lazy-load pyenv (saves ~240ms) ---
_init_pyenv() {
  unfunction pyenv python python3 pip pip3 2>/dev/null
  eval "$(command pyenv init -)"
}
pyenv() { _init_pyenv && pyenv "$@" }
python() { _init_pyenv && python "$@" }
python3() { _init_pyenv && python3 "$@" }
pip() { _init_pyenv && pip "$@" }
pip3() { _init_pyenv && pip3 "$@" }

eval "$(direnv hook zsh)"

# Lines below match the literal strings `notion install` greps for in ~/.zshrc,
# so the install script no-ops these steps instead of trying to append (which
# fails because ~/.zshrc is a read-only Nix store symlink).
export PATH="$HOME/.jenv/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/mise/shims:$PATH"
export PATH="${CARGO_HOME:-$HOME/.cargo}/bin:$PATH"
if command -v rv >/dev/null 2>&1; then eval "$(rv shell init zsh)"; fi
eval "$(jenv init -)"
# Point ripgrep at our own config (managed via ~/nixfiles/osx/ripgreprc). It
# contains the "# Added by notion install" marker, so `notion install`'s
# setup_ripgrep_config sees an existing config with the marker and returns
# silently — works regardless of which worktree we run install from.
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# >>> nomo completions >>>
if [[ -d '/Users/dsyang/.zfunc' ]]; then
        fpath=('/Users/dsyang/.zfunc' $fpath)
fi
autoload -Uz compinit
compinit
# <<< nomo completions <<<
 ### From notion android setup
export ANDROID_HOME=/Users/dsyang/Library/Android/sdk
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/latest/bin"
 ### notion android: trust remote emulator adb keys
export ADB_VENDOR_KEYS="${ADB_VENDOR_KEYS:+$ADB_VENDOR_KEYS:}$HOME/.android/notion-adbkeys"
## Dont forget to create a nocommit.notion.zsh
# export BENCHMARK_USER_ID
# export BENCHMARK_SPACE_ID
# export BENCHMARK_TOKEN_V2

## Apps
# 1pass'-
# Android Studio
# BetterTouchTool
# Chrome
# Clipy
# DaisyDisk
# DBeaver
# Dropbox?x
# Handbrake
# iStat Menus?x
# Kap
# KeyCastr?
# Mullvad VPN
# Open VPN
# Pixelmator
# Slack
# Sublime Text
# Sublime Merge
# Testflight
# VsCode
# XCode
# Zoom
