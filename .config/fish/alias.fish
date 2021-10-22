# Aliases based on OS
switch (uname)
    case Darwin
        set -gx JAVA_HOME (/usr/libexec/java_home)
        set -gx DOCKER_HOST "ssh://pi4-eth"

        alias cat=bat # bat
    case Linux
        # bat
        if type -q batcat
            alias cat=batcat
        end
        if type -q bat
            alias cat=bat
        end
end

# **** Terminal stuffs ****
if type -q exa
    alias ls=exa
    alias ll="ls -hlaS --extended --git --time-style=long-iso"
end
if type -q rg
    alias grep=rg
end

# **** Programming Language ****
alias python=python3

# **** Programming Environments ***
alias use_conda='eval (brew --prefix)/Caskroom/miniforge/base/bin/conda "shell.fish" "hook" $argv | source'
alias use_node='fnm env --shell=fish | source && fnm use'
alias pyenv='source (pwd)/env/bin/activate.fish'

# **** Docker ****
alias docker_run='docker run -ti --net=bridge'
alias docker_run_tmp='docker run -ti --rm --net=bridge'

# **** Tools ****
alias speedtest="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -"
alias clean_ds='find ~/Desktop -name .DS_Store -not -path "*/node_modules/*" -delete'
alias get_storage="smartctl -a disk1s2 | rg 'Data Unit|Available|Percentage|Temperature'"

# **** SSH ****
alias reload_ssh_agent='killall ssh-agent; eval (ssh-agent -c)'
alias sshg='ssh-keygen -o -a 100 -t ed25519 -C dalisoft@mail.ru'

# **** Git ***
alias gitstat='git status --show-stash -b -uall --renames'
alias gitre='git reflog expire --expire=now --all'
alias gitra='git repack -ad'
alias gitp='git prune'
alias gitsru='git submodule update --init --recursive --remote'
alias gitsi='gitsru --rebase'
alias git_rebase='git rebase --gpg-sign=$GPG_SIGNING_KEY --committer-date-is-author-date'
alias gitsuf='gitsru --force --checkout'
alias gitf='git fetch --all --prune'
alias git_prb='gitf && git pull --rebase --committer-date-is-author-date && gitsu'

# **** GnuPG ***
alias gpg_show_keys='gpg -K --keyid-format LONG'
alias gpg_print='gpg --armor --export'
