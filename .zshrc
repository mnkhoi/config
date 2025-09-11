export TERM="xterm-256color"
path=("$HOME/.local/bin" $path)
export path

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Aliases
alias cd="z"
alias ls="eza --git --icons=always"
alias ll="ls -la"
alias c="clear"
alias ".."="cd .."
