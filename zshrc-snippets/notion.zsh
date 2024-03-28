eval "$(notion completion --install)"

alias -g lintcommit="./gradlew formatkotlin && git commit -a --allow-empty -m 'ran formatkotlin'"
alias -g npr="notion pr --findTask=false"


export NOTION_NO_PREPUSH=true
export NOTION_HOME="/Users/dsyang/notion-next"

eval "$(pyenv init -)"
eval "$(direnv hook zsh)"

source $NOTION_HOME/.notionpr/mobile-team-pr-aliases.sh

## Dont forget to create a nocommit.notion.zsh
# export BENCHMARK_USER_ID
# export BENCHMARK_SPACE_ID
# export BENCHMARK_TOKEN_V2
