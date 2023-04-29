# Aliases based on OS
switch (uname)
    case Darwin
        if type -q java_home
            set -gx JAVA_HOME (which java_home)
        end
        # set -gx DOCKER_HOST "ssh://pi4-eth"

        if type -q brew
            set -gx HOMEBREW_PREFIX (brew --prefix)
        end

        alias cat=bat # bat

        # **** Anti Ass ***
        alias rm='trash -F'
    case Linux
        # bat
        if type -q batcat
            alias cat=batcat
        end
        if type -q bat
            alias cat=bat
        end

        # **** Anti Ass ***
        alias rm='trash'
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
# alias python=python3
alias octave_gui='octave --force-gui'

# **** Programming Environments ***
alias use_conda='eval (brew --prefix)/Caskroom/miniforge/base/bin/conda "shell.fish" "hook" $argv | source'
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

# **** GnuPG ***
alias gpg_show_keys='gpg -K --keyid-format LONG'
alias gpg_print='gpg --armor --export'
