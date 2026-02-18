eval "$(notion completion --install)"

alias -g lintcommit="./gradlew formatkotlin && git commit -a --allow-empty -m 'ran formatkotlin'"
alias -g npr="notion pr --findTask=false"


export NOTION_NO_PREPUSH=true
export NOTION_HOME="/Users/dsyang/notion-next"

eval "$(pyenv init -)"
eval "$(direnv hook zsh)"

export RIPGREP_CONFIG_PATH="/Users/dsyang/notion-next/.ripgreprc"

export PATH="/Users/dsyang/.local/bin:/Users/dsyang/.git-ai/bin:$PATH"

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
