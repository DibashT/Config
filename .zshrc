# --- ENVIRONMENT ---
export ZSH="$HOME/.oh-my-zsh"
export EDITOR='nvim'
export VISUAL='nvim'
export TERM="xterm-ghostty"
export LANG="en_US.UTF-8"

# --- PATH (Deduplicated) ---
typeset -U path
path=(
  "$HOME/bin"
  "$HOME/.local/bin"
  "$HOME/.npm-global/bin"
  "/usr/local/bin"
  $path
)
export PATH

# ---  OH MY ZSH SETUP ---
ZSH_THEME="robbyrussell"

# Ensure autosuggestions & syntax-highlighting are cloned to $ZSH_CUSTOM/plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

 # --- HISTORY SETTINGS ---
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# Core history sharing options
setopt SHARE_HISTORY              # Share history across all sessions
setopt INC_APPEND_HISTORY         # Write immediately, don't wait for shell exit
setopt EXTENDED_HISTORY           # Record timestamp and duration

# History quality options
setopt HIST_IGNORE_DUPS           # Don't record duplicate consecutive commands
setopt HIST_IGNORE_ALL_DUPS       # Delete old duplicates when adding new
setopt HIST_FIND_NO_DUPS          # Don't show duplicates when searching
setopt HIST_EXPIRE_DUPS_FIRST     # Expire duplicates first when trimming
setopt HIST_REDUCE_BLANKS         # Remove superfluous blanks
setopt HIST_VERIFY                # Show command with history expansion before running 

# --- FZF & FD INTEGRATION ---
if command -v fzf >/dev/null; then
  source <(fzf --zsh)

  _fd_flags="--hidden --follow --strip-cwd-prefix --exclude .git --exclude node_modules --exclude .cache --exclude Library"

  export FZF_DEFAULT_COMMAND="fd $_fd_flags"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type d $_fd_flags"
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:300 {}'"
fi

# --- ALIASES ---
alias vim='nvim'
alias cat='bat'
alias zshconfig="nvim ~/.zshrc"
alias reload="source ~/.zshrc"
alias ls='ls --color=auto'
alias ..='cd ..'
# alias lvim="NVIM_APPNAME=lazyvim nvim"
lvim() {
    NVIM_APPNAME=lazyvim nvim "$@"
}

# --- PYENV ---
export PYENV_ROOT="$HOME/.pyenv"

[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init -)"
# --- PIP ALIAS ---
alias pip='python3 -m pip'
export PATH="$HOME/.npm-global/bin:$PATH"
