# oh my zsh
#------------------

# only source other files here
source $HOME/.zsh/vars.zsh
source $HOME/.zsh/checks.zsh
source $HOME/.zsh/colors.zsh
source $HOME/.zsh/plugins.zsh
source $HOME/.zsh/setopt.zsh
source $HOME/.zsh/exports.zsh
source $HOME/.zsh/prompt.zsh
source $HOME/.zsh/completion.zsh
source $HOME/.zsh/aliases.zsh
source $HOME/.zsh/bindkeys.zsh
source $HOME/.zsh/functions.zsh
source $HOME/.zsh/history.zsh
source $HOME/.zsh/zsh_hooks.zsh
# use for per-computer customization
if [ -f $HOME/.zsh/my.zsh ]; then
    source $HOME/.zsh/my.zsh
fi
#source  ${HOME}/.dotfiles/z/z.sh
