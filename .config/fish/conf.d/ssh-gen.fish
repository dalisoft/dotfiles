alias ssh_gen_key='ssh-keygen -o -a 100 -t ed25519 -C commercial@dalisoft.uz '

function reload_ssh_agent
    ssh-add -D
    killall ssh ssh-agent
    killall gpg gpg-agent

    eval (ssh-agent -c)
    ssh-add -l
end

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

function ssh_gen_sec --argument-names app file
    set -l provider /usr/lib/ssh-keychain.dylib
    set -l mail "commercial@dalisoft.uz"
    set -l comment "commercial@dalisoft.uz"

    if test -z "$app"
        echo "App ID is required. Example: github-oss, rpi-se" >&2
        return 1
    end

    if not test -f "$provider"
        echo "Secure Enclave provider not found: $provider" >&2
        return 1
    end

    sc_auth create-ctk-identity \
        -k p-256-ne \
        -t bio \
        -E "$mail" \
        -N "$app" \
        -l "$app" \
        -C "$comment"

    env SSH_SK_PROVIDER="$provider" \
        ssh-add -q -K -S /usr/lib/ssh-keychain.dylib

    set -l fingerprints (sc_auth list-ctk-identities -t ssh -e b64 | \
        while read -l key_type fingerprint protection label rest
            if test "$label" = "$app"
                echo "$fingerprint"
            end
        end)

    set -l agent_keys (ssh-add -L)
    or return 1

    for public_key in $agent_keys
        set -l details (printf '%s\n' "$public_key" | ssh-keygen -lf -)
        set -l fields (string split -n ' ' -- "$details")

        if test (count $fields) -ge 2; and test "$fields[2]" = "$fingerprints[1]"
            set -l key_fields (string split -n ' ' -- "$public_key")
            if test (count $key_fields) -lt 2
                echo "Invalid public key returned by agent." >&2
                return 1
            end

            printf '%s %s %s\n' "$key_fields[1]" "$key_fields[2]" "$comment" >"$file.pub"
            or return 1
            chmod 600 "$file.pub"

            echo "Saved public key: $file.pub"
            return 0
        end
    end

end
