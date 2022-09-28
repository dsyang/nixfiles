eval "$(notion completion --install)"

alias -g lintcommit="./gradlew ktlintformat && git commit -a --allow-empty -m 'ran ktlintformat'"