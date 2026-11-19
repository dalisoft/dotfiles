alias reload_ssh_agent='ssh-add -D; killall ssh-agent; eval (ssh-agent -c)'
alias ssh_gen_key='ssh-keygen -o -a 100 -t ed25519 -C commercial@dalisoft.uz '

# Usage: `ssh_gen_fido github-oss ~/ssh/personal/github-oss`
function ssh_gen_fido --argument-names app file
    set -l provider "$HOMEBREW_PREFIX/opt/openssh-sk-provider/lib/sk-libfido2.dylib"

    if test -z "$app"
        echo "App ID is required. Example: github-oss, rpi-fido" >&2
        return 1
    end

    if test -z "$file"
        echo "Output file path required. Example: ~/ssh/personal/github-oss" >&2
        return 1
    end

    if not test -f "$provider"
        echo "FIDO2 provider not found: $provider" >&2
        return 1
    end

    env SSH_SK_PROVIDER="$provider" \
        ssh-keygen -o -a 100 \
        -t ed25519-sk \
        -O verify-required \
        -O "application=ssh:$app" \
        -O "user=$USER" \
        -C commercial@dalisoft.uz \
        -f "$file"
end

function ssh_gen_sec
    argparse f/force -- $argv
    or return 2

    if test (count $argv) -gt 1
        echo "Usage: ssh_gen_sec [-f] [path]" >&2
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
        ssh-keygen -w /usr/lib/ssh-keychain.dylib -K -N ""

        awk -v comment="commercial@dalisoft.uz" \
            \'{print $1, $2, comment}\' \
            id_ecdsa_sk_rk.pub > id_ecdsa_sk_rk.pub.tmp
        mv id_ecdsa_sk_rk.pub.tmp id_ecdsa_sk_rk.pub

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
