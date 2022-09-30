eval "$(notion completion --install)"

alias -g lintcommit="./gradlew formatkotlin && git commit -a --allow-empty -m 'ran formatkotlin'"

export NOTION_NO_PREPUSH=true