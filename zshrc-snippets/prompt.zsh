# --- Colors & prompt (replaces oh-my-zsh + dsyang theme) ---
autoload -Uz colors && colors
autoload -Uz add-zsh-hook
setopt PROMPT_SUBST

# --- Async git prompt (signal-based) ---
typeset -g _git_prompt_result=""

_git_prompt_refresh() {
  local tmpfile="/tmp/.zsh_git_prompt_$$"
  if [[ -s "$tmpfile" ]]; then
    local line
    read -r line < "$tmpfile"
    rm -f "$tmpfile"
    local ref="${line%%:*}"
    local dirty="${line#*:}"
    if [[ -n "$ref" ]]; then
      if [[ "$dirty" == "1" ]]; then
        _git_prompt_result="%{$fg_bold[blue]%}(%{$fg_no_bold[yellow]%}%B${ref}%{$fg_bold[red]%}✗%b%{$fg_bold[blue]%})%{$reset_color%}"
      else
        _git_prompt_result="%{$fg_bold[blue]%}(%{$fg_no_bold[yellow]%}%B${ref}%b%{$fg_bold[blue]%})%{$reset_color%}"
      fi
    fi
  fi
  zle && zle reset-prompt
}

TRAPUSR1() { _git_prompt_refresh }

_git_async_precmd() {
  _git_prompt_result=""
  # Fast check: walk up to find .git without forking
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    [[ -d "$dir/.git" ]] && break
    dir="${dir:h}"
  done
  [[ "$dir" == "/" ]] && return

  local tmpfile="/tmp/.zsh_git_prompt_$$"
  local parent_pid=$$
  (
    local ref
    ref=$(command git symbolic-ref --short HEAD 2>/dev/null) || exit
    local dirty=0
    if [[ -n $(command git status --porcelain 2>/dev/null) ]]; then
      dirty=1
    fi
    echo "${ref}:${dirty}" > "$tmpfile"
    kill -USR1 $parent_pid 2>/dev/null
  ) &!
}
add-zsh-hook precmd _git_async_precmd

git_prompt_info() { echo "$_git_prompt_result"; }

if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="white"; fi
PROMPT='%{$fg[$NCOLOR]%}%B%n%b$(git_prompt_info)%{$fg[blue]%}%B❯%b%{$fg[cyan]%}λ.%{$fg[magenta]%}%B%c/%b%{$reset_color%}%(!.#.%{$fg[blue]%}%B=%b%{$reset_color%})'
RPROMPT='[%*]'

export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LS_COLORS='no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:'

# --- SSH agent (replaces oh-my-zsh ssh-agent plugin) ---
if [[ -z "$SSH_AUTH_SOCK" ]]; then
  _ssh_agent_env="$HOME/.ssh/agent_env"
  if [[ -f "$_ssh_agent_env" ]]; then
    source "$_ssh_agent_env" >/dev/null
    if ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
      eval "$(ssh-agent -s -t 5760000)" >/dev/null
      echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK; export SSH_AUTH_SOCK; SSH_AGENT_PID=$SSH_AGENT_PID; export SSH_AGENT_PID;" > "$_ssh_agent_env"
    fi
  else
    mkdir -p "$HOME/.ssh"
    eval "$(ssh-agent -s -t 5760000)" >/dev/null
    echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK; export SSH_AUTH_SOCK; SSH_AGENT_PID=$SSH_AGENT_PID; export SSH_AGENT_PID;" > "$_ssh_agent_env"
  fi
  unset _ssh_agent_env
fi
