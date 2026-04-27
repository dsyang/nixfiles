# --- Cached notion completion (saves ~180ms) ---
_notion_comp_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/notion_completion.zsh"
if [[ ! -s "$_notion_comp_cache" ]]; then
  mkdir -p "${_notion_comp_cache:h}"
  notion completion --install > "$_notion_comp_cache" 2>/dev/null
fi
source "$_notion_comp_cache" 2>/dev/null
unset _notion_comp_cache

alias -g lintcommit="./gradlew formatkotlin && git commit -a --allow-empty -m 'ran formatkotlin'"
alias -g npr="notion pr --findTask=false"


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

export PATH="/Users/dsyang/.local/bin:/Users/dsyang/.git-ai/bin:$PATH"

# --- Claude Code planning session with Ghostty theme swap ---
plan() {
  local original_dir="$PWD"
  cd /Users/dsyang/notion-next-planning || return 1
  printf '\e]133;P;config=theme=Atom One Dark\e\\'
  command claude --permission-mode plan "$@"
  local exit_code=$?
  printf '\e]133;P;config=theme=Ghost\e\\'
  cd "$original_dir"
  return $exit_code
}

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
