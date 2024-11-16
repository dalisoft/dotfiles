###################################
######### fish-user Paths #########
###################################

## Variables
set -gx fish_greeting ""
set -gx TERM xterm-256color
set -gx EDITOR nvim
set -gx VISUAL nvim

# Fish paths
set -gx FISH_PATH "$HOME/.config/fish"
set -gx FISH_FUNCTIONS_PATH "$FISH_PATH/functions"

set -gx BAT_THEME ansi # bat/batcat theme
set -gx BAT_PAGER "less -R --mouse"
set -gx DELTA_PAGER "less -R --mouse"
set -gx MOZ_USE_OMTC 1 # Firefox for Linux patch
set -gx NFANCURVE_PATH "$HOME/nfancurve" # nFanCurve Linux patch

# Privacy settings
set -gx HOMEBREW_NO_ANALYTICS 1 # Homebrew disable telemetry
set -gx HOMEBREW_NO_ENV_HINTS 1 # Hide hints for cleaner logs
set -gx DO_NOT_TRACK 1 # Disable Bun.js tracking
set -gx NEXT_TELEMETRY_DISABLED 1 # Disable Next.js global tracking

# Ollama
set -gx OLLAMA_FLASH_ATTENTION 1
set -gx OLLAMA_KEEP_ALIVE 5m
set -gx OLLAMA_MAX_LOADED_MODELS 1
set -gx OLLAMA_NUM_PARALLEL 1
set -gx OLLAMA_MAX_QUEUE 128
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

# bun
set -gx BUN_INSTALL "$HOME/.bun"

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
# ********* PATH of env **********
# ********************************

# System binaries
set -gx PATH /bin $PATH
set -gx PATH /sbin $PATH
set -gx PATH /usr/bin $PATH
set -gx PATH /usr/sbin $PATH

# Programming language
set -gx PATH "$HOME/.cargo/bin" $PATH # Rust
set -gx PATH "$HOME/go/bin" $PATH # Go
set -gx PATH "$HOME/.gem/bin" $PATH # Ruby binaries

set -gx PATH "$HOME/.local/bin" $PATH # pipx

# npm / fnm
set -gx PATH "$NPM_CONFIG_PREFIX/bin" $PATH
set -gx PATH "$HOME/.fnm" $PATH

# bun
set -gx PATH $BUN_INSTALL/bin $PATH

# Android SDK
set -gx PATH "$HOMEBREW_PREFIX/opt/openjdk/bin" $PATH
set -gx PATH "$ANDROID_HOME/emulator" $PATH
set -gx PATH "$ANDROID_HOME/tools" $PATH
set -gx PATH "$ANDROID_HOME/tools/bin" $PATH
set -gx PATH "$ANDROID_HOME/platform-tools" $PATH
set -gx PATH "$JAVA_HOME/bin" $PATH # Java

# LLVM
set -gx PATH "$HOMEBREW_PREFIX/opt/llvm/bin" $PATH

# Ruby
set -gx PATH "$HOMEBREW_PREFIX/opt/ruby/bin" $PATH

# Homebrew
set -gx PATH /usr/local/bin $PATH
set -gx PATH /usr/local/sbin $PATH
set -gx PATH /opt/homebrew/bin $PATH
set -gx PATH /opt/homebrew/sbin $PATH

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

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/dalisoft/.cache/lm-studio/bin
