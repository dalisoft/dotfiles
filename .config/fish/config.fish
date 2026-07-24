###################################
######### fish-user Paths #########
###################################

## Variables
set -gx fish_greeting ""
set -gx EDITOR nvim
set -gx VISUAL nvim

# Fish paths
set -gx FISH_PATH "$HOME/.config/fish"
set -gx FISH_FUNCTIONS_PATH "$FISH_PATH/functions"

set -gx BAT_THEME ansi # bat/batcat theme
set -gx BAT_PAGER "less -R --mouse --quit-if-one-screen"
set -gx DELTA_PAGER "less -R --mouse --quit-if-one-screen"
set -gx MOZ_USE_OMTC 1 # Firefox for Linux patch
set -gx NFANCURVE_PATH "$HOME/nfancurve" # nFanCurve Linux patch

# Privacy settings
set -gx HOMEBREW_NO_ANALYTICS 1 # Homebrew disable telemetry
set -gx HOMEBREW_NO_ENV_HINTS 1 # Hide hints for cleaner logs
set -gx DO_NOT_TRACK 1 # Disable Bun.js tracking
set -gx NEXT_TELEMETRY_DISABLED 1 # Disable Next.js global tracking
set -gx HOMEBREW_NO_REQUIRE_TAP_TRUST 1 # Allow all taps be trusted
set -gx HOMEBREW_NO_ASK 1 # Allow upgrades without ask

# Ollama
set -gx OLLAMA_FLASH_ATTENTION 1
set -gx OLLAMA_KV_CACHE_TYPE q8_0
set -gx OLLAMA_KEEP_ALIVE 5m
set -gx OLLAMA_MAX_LOADED_MODELS 1
set -gx OLLAMA_NUM_PARALLEL 1
set -gx OLLAMA_MAX_QUEUE 512
set -gx OLLAMA_HOST "127.0.0.1"
set -gx OLLAMA_NOHISTORY 1

# Mosh / OS SSH fix
set -gx LANG "en_US.UTF-8"
set -gx LANGUAGE "en_US.UTF-8"
set -gx LC_ALL "en_US.UTF-8"

# Rust / Cargo
set -gx CARGO_INSTALL_ROOT "$HOME/.cargo"
set -gx CARGO_HOME "$HOME/.cargo"

# npm
set -gx NPM_CONFIG_PREFIX "$HOME/.npm-global"
set -gx NODE_PATH "$NPM_CONFIG_PREFIX/lib/node_modules"
set -gx NPM_CHECK_INSTALLER bun

# bun
set -gx BUN_INSTALL "$HOME/.bun"
set -gx BUM_INSTALL "$HOME/.bum"

# Python
set -gx PIPX_HOME "$HOME/.local/pipx"

# Go
set -gx GOPATH "$HOME/go"

# Ruby
set -gx GEM_HOME "$HOME/.gem"

# Android SDK
set -gx ANDROID_HOME "$HOME/Library/Android/sdk"
set -gx ANDROID_SDK_ROOT "$HOME/Library/Android/sdk"
set -gx ANDROID_AVD_HOME "$HOME/.android/avd"

# ********************************
# ********* Claude Code **********
# ********************************

# Bash commands
set -gx BASH_DEFAULT_TIMEOUT_MS 86400
set -gx BASH_MAX_TIMEOUT_MS 86400

# Model API connections
set -gx API_TIMEOUT_MS 3000000
set -gx CLAUDE_CODE_PROXY_RESOLVES_HOSTS true

# Updater settings
set -gx DISABLE_AUTOUPDATER 1
set -gx FORCE_AUTOUPDATE_PLUGINS false

# Privacy
set -gx CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY 1
set -gx DISABLE_FEEDBACK_COMMAND 1
set -gx DISABLE_ERROR_REPORTING 1
set -gx DISABLE_TELEMETRY 1

# IDE
set -gx CLAUDE_CODE_AUTO_CONNECT_IDE false
set -gx CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL 1
set -gx CLAUDE_CODE_IDE_SKIP_VALID_CHECK 1

# Memory
set -gx CLAUDE_CODE_DISABLE_AUTO_MEMORY 1

# Skills
set -gx CLAUDE_CODE_DISABLE_BUNDLED_SKILLS 1

# Local AI models caching
# See link for more info
# https://unsloth.ai/docs/basics/claude-code#fixing-90-slower-inference-in-claude-code
set -gx CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC 1
set -gx CLAUDE_CODE_ATTRIBUTION_HEADER 0
set -gx CLAUDE_CODE_ENABLE_TELEMETRY 0

# Disk performance
set -gx CLAUDE_CODE_DISABLE_FILE_CHECKPOINTING 1

# TUI performance
set -gx CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN 0
set -gx CLAUDE_CODE_NO_FLICKER 1

# Model behavior
set -gx CLAUDE_CODE_DISABLE_1M_CONTEXT 1
set -gx CLAUDE_CODE_DISABLE_FAST_MODE 1
set -gx CLAUDE_CODE_ALWAYS_ENABLE_EFFORT 1

# Tool calling improvements
set -gx ENABLE_TOOL_SEARCH true

# ********************************
# ********* PATH of env **********
# ********************************

# System binaries
fish_add_path -g /bin
fish_add_path -g /sbin
fish_add_path -g /usr/bin
fish_add_path -g /usr/sbin

# Homebrew
fish_add_path -g /usr/local/bin
fish_add_path -g /usr/local/sbin
fish_add_path -g /opt/homebrew/bin
fish_add_path -g /opt/homebrew/sbin

# LLVM
fish_add_path -g "$HOMEBREW_PREFIX/opt/llvm/bin"

# Ruby
fish_add_path -g "$HOMEBREW_PREFIX/opt/ruby/bin"

# curl HTTP3
fish_add_path -g "$HOMEBREW_PREFIX/opt/curl/bin"

# SQLite (3)
fish_add_path -g "$HOMEBREW_PREFIX/opt/sqlite/bin"

# Programming language
fish_add_path -g "$HOME/.cargo/bin" # Rust
fish_add_path -g "$HOME/go/bin" # Go
fish_add_path -g "$HOME/.gem/bin" # Ruby binaries

fish_add_path -g "$HOME/.local/bin" # pipx

# npm / fnm
fish_add_path -g "$NPM_CONFIG_PREFIX/bin"
fish_add_path -g "$HOME/.fnm"

# bun
fish_add_path -g "$BUN_INSTALL/bin"
fish_add_path -g "$BUM_INSTALL/bin"

# Android SDK
fish_add_path -g "$HOMEBREW_PREFIX/opt/openjdk/bin"
fish_add_path -g "$ANDROID_HOME/emulator"
fish_add_path -g "$ANDROID_HOME/tools"
fish_add_path -g "$ANDROID_HOME/tools/bin"
fish_add_path -g "$ANDROID_HOME/platform-tools"
fish_add_path -g "$JAVA_HOME/bin" # Java

# Load aliases
source $FISH_PATH/alias.fish

# Load some functions
source $FISH_FUNCTIONS_PATH/git_utils.fish
source $FISH_FUNCTIONS_PATH/brew_utils.fish

# ********************************
# ********* shell flags **********
# ********************************

set -gx LDFLAGS "-L$HOMEBREW_PREFIX/opt/openssl@3/lib"
set -gx CPPFLAGS "-I$HOMEBREW_PREFIX/opt/openssl@3/include"
set -gx PKG_CONFIG_PATH "/$HOMEBREW_PREFIX/opt/openssl@3/lib/pkgconfig"

set -gx LDFLAGS "-L$HOMEBREW_PREFIX/opt/llvm/lib"
set -gx CPPFLAGS "-I$HOMEBREW_PREFIX/opt/llvm/include"

########## init scripts ###########

# **** starship ****
if type -q starship
    starship init fish --print-full-init | source
end

# *** fnm ***
if type -q fnm
    fnm env --shell=fish --use-on-cd | source
end
