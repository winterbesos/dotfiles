export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export LC_ALL=en_US.UTF-8

# Functions
source ~/.shell/functions.sh

# Allow local customizations in the ~/.shell_local_before file
if [ -f ~/.shell_local_before ]; then
    source ~/.shell_local_before
fi

# Allow local customizations in the ~/.zshrc_local_before file
if [ -f ~/.zshrc_local_before ]; then
    source ~/.zshrc_local_before
fi

# External plugins (initialized before)
source ~/.zsh/plugins_before.zsh

## Settings
source ~/.zsh/settings.zsh

# Custom prompt
source ~/.zsh/prompt.zsh

# External plugins (initialized after)
source ~/.zsh/plugins_after.zsh

# Bootstrap
source ~/.shell/bootstrap.sh

# External settings
source ~/.shell/external.sh

# Aliases
source ~/.shell/aliases.sh

# language enviroment
source ~/.shell/language.sh

# auto commands
source ~/.shell/autocommands.sh

# fzf configs
source ~/.shell/fzf-completion.zsh


# Allow local customizations in the ~/.shell_local_after file
if [ -f ~/.shell_local_after ]; then
    source ~/.shell_local_after
fi

# Allow local customizations in the ~/.zshrc_local_after file
if [ -f ~/.zshrc_local_after ]; then
    source ~/.zshrc_local_after
fi

# Allow private customizations (not checked in to version control)
if [ -f ~/.shell_private ]; then
    source ~/.shell_private
fi

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && . "$HOME/.dart-cli-completion/zsh-config.zsh" || true
## [/Completion]

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# kitty shell integration
if [[ -n "$KITTY_INSTALLATION_DIR" ]]; then
  export KITTY_SHELL_INTEGRATION="enabled"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi

logcolor() {
  perl -pe '
  s/\b(INFO)\b/\e[32m$1\e[0m/g;
  s/\b(WARN)\b/\e[33m$1\e[0m/g;
  s/\b(ERROR)\b/\e[31;1m$1\e[0m/g;
  s/\b(DEBUG)\b/\e[96;1m$1\e[0m/g;
  s/(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d+)/\e[36m$1\e[0m/g;
  s/([a-zA-Z0-9_.-]+\[[0-9.]+\])/\e[35m$1\e[0m/g;
  s/(Request [a-f0-9-]+)/\e[34;1m$1\e[0m/g;
  s/(\[(GET|POST|PUT|DELETE|PATCH)\])/\e[33;1m$1\e[0m/g;
  s/(\[[0-9]{3}\])/\e[32;1m$1\e[0m/g;
  s/(Response:)/\e[36;1m$1\e[0m/g;
  s/(Body:)/\e[90m$1\e[0m/g;
  '
}

