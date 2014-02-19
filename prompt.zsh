autoload -U colors && colors # Enable colors in prompt

# git prompt colors
ZSH_THEME_GIT_PROMPT_PREFIX="± ⟫ "
ZSH_THEME_GIT_PROMPT_SUFFIX=" ⟪${RESET}"
ZSH_THEME_GIT_PROMPT_DIRTY="${PR_RED}"
ZSH_THEME_GIT_PROMPT_CLEAN="${PR_GREEN}"

# host
function get_host() {
    echo "${PR_BLUE}%m${PR_WHITE}:${RESET}"
}

# returns pwd or ~ if in home
function get_pwd() {
   echo "${PR_YELLOW}${PWD/$HOME/~}${RESET}"
}

# returns the spacing in the terminal prompt
function get_space() {
    local zero='%([BSUbfksu]|([FB]|){*})'

    # get actual amount of blank space
    # width = columns - host - pwd - vcs
    # (( termwidth = ${COLUMNS} - ${#${(S%%)_host//$~zero/}} - ${#${(S%%)_pwd//$~zero/}} - ${#${(S%%)_vcs//$~zero/}} ))
    local termwidth=$(( termwidth = ${COLUMNS} - $1 ))

    # return the spacing
    local space=""
    for i in {1..$termwidth}; do
        space="${space} "
    done

    echo "$space"
}

# returns the svn dir
function svn_status() {
    # dirty or clean?
    local dirty="$(svn st)"
    if [ ${#dirty} != 0 ]; then
        dirty="${PR_RED}"
    else
        dirty="${PR_GREEN}"
    fi

    # get branch name and revision #
    local branch=`svn_get_branch_name`
    local revision=`svn info | awk '/^Revision:/{print $2}'`

    # echo out the status
    if [ ${#branch} != 0 ]; then
        echo "$dirty§ ⟫ $branch:$revision ⟪${RESET}"
    fi
}

# returns the git status
function git_status() {
    echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# returns the vcs status
function get_vcs_status() {
    # get status
    if [ -d '.svn' ]; then
        echo "$(svn_status)"
    elif [ -d '.git' ] || git rev-parse --git-dir > /dev/null 2>&1; then
        echo "$(git_status)"
    fi
}

# makes the prompt
function make_prompt() {
    # prompt vars
    # local zero='%([BSUbfksu]|([FB]|){*})'

    # set the vars
    local host="$(get_host)"
    local pwd="$(get_pwd)"
    local vcs="$(get_vcs_status)"
    # local len=$(( ${#${(S%%)host//$~zero/}} + ${#${(S%%)pwd//$~zero/}} + ${#${(S%%)vcs//$~zero/}} ))
    # local space="$(get_space $len)"

    # the prompt
    echo "
$host $pwd $vcs
$PR_WHITE▸$RESET "
}

#PROMPT=""

export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color [(y)es (n)o (a)bort (e)dit]? "

#RPROMPT='${PR_GREEN}$(virtualenv_info)%{$reset_color%} ${PR_RED}${ruby_version}%{$reset_color%}'
