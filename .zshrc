# Uncomment to troubleshoot zsh performance (also uncomment at the bottom)
# zmodload zsh/zprof

eval "$(starship init zsh)"

# antidote plugin manager config
[[ -r ~/.zsh/plugins/antidote/antidote.zsh ]] ||
    git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.zsh/plugins/antidote
source ~/.zsh/plugins/antidote/antidote.zsh

# plugins list, run 'rm ~/.zsh/plugins/plugins.txt' when you add plugins to refresh
# 'kind:defer' makes it so that plugins load do not block your shell
[[ -f ~/.zsh/plugins/plugins.txt ]] || cat <<EOF > ~/.zsh/plugins/plugins.txt
zsh-users/zsh-autosuggestions kind:defer
zsh-users/zsh-syntax-highlighting kind:defer
zsh-users/zsh-history-substring-search kind:defer
lukechilds/zsh-nvm kind:defer
EOF

antidote load ~/.zsh/plugins/plugins.txt

# zsh-history-substring-search configuration
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=green,bold"
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=""
if [[ "$OSTYPE" == "darwin"* ]]; then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down
else
  echo "Unknown OS: $OSTYPE"
fi

# History config
setopt histignorealldups sharehistory
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# ALIASES
alias bya="byobu attach -t"
alias byd="byobu detach"
alias byn="byobu new -s"
alias gr="grep -R -f . -e"
alias gs="git status"
alias ga="git add ."
alias gc="git commit"
alias gca="git commit --amend"
# switch to the main branch
alias gm="MAIN_BRANCH=\$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@') && git switch \$MAIN_BRANCH"
alias gg="git log --graph --oneline --all"
# fetches only the current branch from the remote to be faster and avoid noise
alias gf="git fetch --prune origin \$(git rev-parse --abbrev-ref HEAD) && git checkout FETCH_HEAD -B \$(git rev-parse --abbrev-ref HEAD)"
# create branch
alias gbc="git switch -c"
# pulls the main branch and rebases your branch on it
alias gbr="MAIN_BRANCH=\$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@') CURRENT_BRANCH=\$(git rev-parse --abbrev-ref HEAD) && git switch \$MAIN_BRANCH && gf && git switch \$CURRENT_BRANCH && git rebase \$MAIN_BRANCH"
# rebase some commits
gcr() { MAIN_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@') CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD) && git rebase --onto $MAIN_BRANCH $CURRENT_BRANCH~$1 $CURRENT_BRANCH; }
# delete branches that have been deleted from the remote
alias gbd="git fetch -p 2> /dev/null && for branch in \$(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '\$2 == \"[gone]\" {sub(\"refs/heads/\", \"\", \$1); print \$1}'); do git branch -D \$branch; done"
# force delete all branches except the main branch (dangerous, for big repos)
alias gbdf="git branch | grep -v \$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@') | xargs git branch -D"
# push the branch to the remote (with the same name) and open PR with using commit messages
alias gpu="git push -u origin \$(git rev-parse --abbrev-ref HEAD) && gh pr create -d -f"
# gitlab version
# alias gpu="git push -u origin \$(git rev-parse --abbrev-ref HEAD) && glab mr create --fill -y"
alias gpf="git push -f"

# use uv instead of plain pip
alias pip="uv pip"

# file manager (fm) alias for yazi
alias fm="yazi"

# ENV VARS
export PYTHONBREAKPOINT="ipdb.set_trace"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH="$PATH:/opt/nvim-linux64/bin"
export PATH="$PATH:/home/amaury/.cargo/bin"

# Point GOPATH to our go sources
export GOPATH="${HOME?}/go"

# Add binaries that are go install-ed to PATH
export PATH="${GOPATH?}/bin:${PATH?}"

# fix kitty over SSH
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

# Homebrew config for MacOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Add homebrew binaries to the path.
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH?}"

    # Force certain more-secure behaviours from homebrew
    export HOMEBREW_NO_INSECURE_REDIRECT=1
    export HOMEBREW_CASK_OPTS=--require-sha
    export HOMEBREW_DIR=/opt/homebrew
    export HOMEBREW_BIN=/opt/homebrew/bin

    # Prefer GNU binaries to Macintosh binaries.
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:${PATH}"
fi


export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# load additional machine-specific config if it exists
if [ -f ~/.zsh/misc.sh ]; then
    source ~/.zsh/misc.sh
fi

# Uncomment to troubleshoot zsh performance (also uncomment at the top)
# zprof

