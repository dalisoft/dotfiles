function update_repos
    cd ~/Desktop
    git_rebase
end

function brew_cleanup
    brew cleanup
    brew cleanup -s
    brew cleanup --prune 0
    brew cleanup -s
end

function tool_cleanup
    npm cache clean --force
    pnpm store prune
    yarn cache clean
    bun pm cache rm --global

    python3 -m pip cache purge
    uv cache prune --force
    uv cache clean --force

    go clean -cache
end

function brew_upgrade
    brew update --verbose
    brew upgrade --formula --verbose
    brew upgrade --cask --greedy --verbose
end

function tool_upgrade
    uv tool upgrade --all
    bun update --global --interactive --recursive
end

function update_all
    brew_cleanup
    tool_cleanup

    brew_upgrade
    tool_upgrade
    # TODO: fix later
    # update_repos

    brew_cleanup
    tool_cleanup
end
