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

# Note: Ensure autosuggestions & syntax-highlighting are cloned to $ZSH_CUSTOM/plugins
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

setopt EXTENDED_HISTORY      
setopt INC_APPEND_HISTORY    
setopt SHARE_HISTORY         
setopt HIST_IGNORE_DUPS      
setopt HIST_REDUCE_BLANKS

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
alias zshconfig="nvim ~/.zshrc"
alias reload="source ~/.zshrc"
alias ls='ls --color=auto'
alias ..='cd ..'

# --- PYENV ---
export PYENV_ROOT="$HOME/.pyenv"

[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init -)"
