autoload -U colors && colors # Enable colors in prompt

# git prompt colors
ZSH_THEME_GIT_PROMPT_PREFIX="± ⟫ on "
ZSH_THEME_GIT_PROMPT_SUFFIX=" ⟪%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"

# host
function get_host() {
    echo "%m"
}

# returns pwd or ~ if in home
function get_pwd() {
   echo $(pwd | sed -e "s,^$HOME,~,")
}

# returns the svn dir
function svn_status() {
    # dirty or clean?
    local dirty="$(svn status --quiet)"
    local unversioned=$(svn status | grep --color=NEVER '^\?')
    if [[ -n "${dirty}" ]] || [[ -n "${unversioned}" ]]; then
        dirty="%{$fg[red]%}"
    else
        dirty="%{$fg[green]%}"
    fi

    # get branch name and revision #
    local branch=$(svn_get_branch_name)
    local revision=$(svn info | awk '/^Revision:/{print $2}')

    # echo out the status
    if [[ -n "${branch}" ]]; then
        echo "$dirty§ ⟫ $branch:$revision ⟪%{$reset_color%}"
    fi
}

# returns the git status
function git_status() {
    echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# returns the vcs status
function get_vcs_status() {
    # get status
    svn info 1>/dev/null 2>&1
    if [[ "$?" -eq 0 ]]; then
        echo "$(svn_status)"
    elif [ -d '.git' ] || git rev-parse --git-dir > /dev/null 2>&1; then
        echo "$(git_status)"
    fi
}

# makes the prompt
function make_prompt() {
    # set the vars
    local host="$(get_host)"
    local pwd="$(get_pwd)"

    # the prompt
    echo "
%{$fg[cyan]%}$host%{$fg[white]%}: %{$fg[yellow]%}$pwd
%{$fg[white]%}▸%{$reset_color%} "
}

export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color [(y)es (n)o (a)bort (e)dit]? "
