autoload -U colors && colors # Enable colors in prompt

# git prompt colors
ZSH_THEME_GIT_PROMPT_PREFIX="± ⟫ on "
ZSH_THEME_GIT_PROMPT_SUFFIX=" ⟪%{$reset_color%}"
export ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"
export ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"

# host
function get_host() {
    echo "%m"
}

# returns pwd or ~ if in home
function get_pwd() {
   pwd | sed -e "s,^${HOME},~,"
}

# returns the svn dir
function svn_status() {
    # dirty or clean? must check for both "modified" items and "unversioned"
    # items separately to correctly detect dirtiness of repos with externals
    local dirty
    local unversioned
    local color
    dirty=$(svn status --quiet)
    unversioned=$(svn status | grep --color=NEVER '^\?')

    if [[ -n "${dirty}" ]] || [[ -n "${unversioned}" ]]; then
        color="$fg[red]"
    else
        color="$fg[green]"
    fi

    # get repo information
    local info
    local repo
    local relative_path
    local revision
    info=$(svn info)
    repo=$(echo "${info}" | awk '/^Repository Root:/{ print $3; }')
    repo=$(basename "${repo}")
    relative_path=$(echo "${info}" | awk '/^Relative URL:/{ print $3; }')
    relative_path="${relative_path:2}"
    if [[ -n "${relative_path}" ]]; then
        relative_path=":${relative_path}"
    fi
    revision=$(echo "${info}" | awk '/^Revision:/{ print $2; }')

    # echo out the status
    echo "%{${color}%}§ ⟫ ${repo}${relative_path}@${revision} ⟪%{${reset_color}%}"
}

# returns the git status
function git_status() {
    echo "$(parse_git_dirty)${ZSH_THEME_GIT_PROMPT_PREFIX}$(current_branch)${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

# returns the vcs status
function get_vcs_status() {
    if in_svn; then
        svn_status
    elif [[ -d '.git' ]] || git rev-parse --git-dir >/dev/null 2>&1; then
        git_status
    fi
}

# makes the prompt
function make_prompt() {
    # set the vars
    local host
    local pwd
    host=$(get_host)
    pwd=$(get_pwd)

    # the prompt
    echo "
%{$fg[cyan]%}$host%{$fg[white]%}: %{$fg[yellow]%}$pwd
%{$fg[white]%}▸%{$reset_color%} "
}

export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color [(y)es (n)o (a)bort (e)dit]? "
