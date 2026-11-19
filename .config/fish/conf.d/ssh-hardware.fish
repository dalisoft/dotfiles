# Hardware-backed SSH configuration
# macOS: Secure Enclave
# Linux: TPM 2.0
# Windows/WSL: Existing Windows agent bridge

switch (uname -s)
    case Darwin
        # Apple's Secure Enclave SSH provider
        set -gx SSH_ENCLAVE_PROVIDER /usr/lib/ssh-keychain.dylib
        # FIDO SSH provider
        set -gx SSH_FIDO_PROVIDER "$HOMEBREW_PREFIX/opt/openssh-sk-provider/lib/sk-libfido2.dylib"

    case Linux
        # WSL: preserve the existing Windows-agent bridge
        if string match -qi '*microsoft*' (uname -r)
            # SSH_AUTH_SOCK should already point to
            # a configured WSL agent bridge.

        else if command -q ssh-tpm-agent
            # Native Linux TPM 2.0 agent
            set -l sock (ssh-tpm-agent --print-socket 2>/dev/null)

            if test -n "$sock"; and test -S "$sock"
                set -gx SSH_AUTH_SOCK $sock
            end
        end

    case '*'
        # Other platforms: preserve existing SSH agent
end
