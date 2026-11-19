alias reload_ssh_agent='killall ssh-agent; eval (ssh-agent -c)'
alias sshg='ssh-keygen -o -a 100 -t ed25519 -C commercial@dalisoft.uz'

function sshgs
    argparse f/force -- $argv
    or return 2

    if test (count $argv) -gt 1
        echo "Usage: sshgs [-f] [path]" >&2
        return 2
    end

    set -l target id_ecdsa_sk_rk
    if test (count $argv) -eq 1
        set target $argv[1]
    end

    set target (path resolve -- $target)

    if not set -q _flag_force
        if test -e "$target"; or test -e "$target.pub"
            echo "Key already exists: $target" >&2
            return 1
        end
    end

    command sh -c '
        set -eu

        target=$1
        force=$2
        dir=$(mktemp -d)
        trap '\''rm -rf -- "$dir"'\'' 0
        trap '\''exit 1'\'' 1 2 3 15

        cd "$dir"
        ssh-keygen -C "commercial@dalisoft.uz" -w /usr/lib/ssh-keychain.dylib -K -N ""

        test -f id_ecdsa_sk_rk
        test -f id_ecdsa_sk_rk.pub

        if [ "$force" = 1 ]; then
            mv -f id_ecdsa_sk_rk "$target"
            mv -f id_ecdsa_sk_rk.pub "$target.pub"
        else
            mv -n id_ecdsa_sk_rk "$target"
            mv -n id_ecdsa_sk_rk.pub "$target.pub"
        fi

        chmod 600 "$target"
        chmod 644 "$target.pub"
    ' sh "$target" (set -q _flag_force; and echo 1; or echo 0)
end
