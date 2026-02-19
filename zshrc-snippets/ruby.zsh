# --- Lazy-load rbenv (saves ~150ms) ---
_init_rbenv() {
  unfunction rbenv ruby gem irb bundle rake 2>/dev/null
  eval "$(command rbenv init - zsh)"
}
rbenv() { _init_rbenv && rbenv "$@" }
ruby() { _init_rbenv && ruby "$@" }
gem() { _init_rbenv && gem "$@" }
irb() { _init_rbenv && irb "$@" }
bundle() { _init_rbenv && bundle "$@" }
rake() { _init_rbenv && rake "$@" }
