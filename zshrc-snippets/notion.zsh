eval "$(notion completion --install)"

alias -g lintcommit="./gradlew formatkotlin && git commit -a --allow-empty -m 'ran formatkotlin'"
alias -g npr="notion pr --findTask=false"


export NOTION_NO_PREPUSH=true

eval "$(pyenv init -)"