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

function brew_upgrade
    brew update --verbose
    brew upgrade --formula --verbose
    brew upgrade --cask --greedy --verbose
end

function update_all
    brew_upgrade
    brew_cleanup
    uv tool upgrade --all
    bun x npm-check --global --update-all
    update_repos
end
