#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
os_name="$(uname -s)"

load_homebrew_env() {
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
}

install_homebrew() {
    if ! command -v curl >/dev/null 2>&1; then
        echo "Homebrew not found and curl is unavailable. Install Homebrew manually, then rerun $script_dir/setup.sh"
        exit 1
    fi

    echo "Homebrew not found. Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

command_for_cask() {
    local cask="$1"

    case "$cask" in
        claude-code) echo "claude" ;;
        codex) echo "codex" ;;
    esac
}

install_macos_ai_tools() {
    load_homebrew_env

    if ! command -v brew >/dev/null 2>&1; then
        install_homebrew
        load_homebrew_env
    fi

    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew install finished, but brew is still not on PATH. Open a new terminal and rerun $script_dir/setup.sh"
        exit 1
    fi

    echo "Installing AI tools from $script_dir/Brewfile"
    while IFS= read -r line; do
        cask="${line#cask \"}"
        cask="${cask%\"}"

        [ -z "$cask" ] && continue
        [[ "$line" == cask\ * ]] || continue

        command_name="$(command_for_cask "$cask")"
        if [ -n "$command_name" ] && command -v "$command_name" >/dev/null 2>&1; then
            echo "Already installed: $cask ($command_name)"
            continue
        fi

        if brew list --cask "$cask" >/dev/null 2>&1; then
            echo "Already installed: $cask"
            continue
        fi

        if ! brew install --cask "$cask"; then
            echo "Failed to install cask: $cask"
        fi
    done < "$script_dir/Brewfile"
}

install_with_official_script() {
    local command_name="$1"
    local installer_url="$2"
    local description="$3"

    if command -v "$command_name" >/dev/null 2>&1; then
        echo "Already installed: $description ($command_name)"
        return
    fi

    if ! command -v curl >/dev/null 2>&1; then
        echo "Cannot install $description: curl is unavailable"
        return 1
    fi

    echo "Installing $description..."
    curl -fsSL "$installer_url" | sh
}

install_linux_ai_tools() {
    install_with_official_script "claude" "https://claude.ai/install.sh" "Claude Code"
    install_with_official_script "codex" "https://chatgpt.com/codex/install.sh" "Codex"
}

case "$os_name" in
    Darwin)
        install_macos_ai_tools
        ;;
    Linux)
        install_linux_ai_tools
        ;;
    *)
        echo "ai/setup.sh skipped: unsupported OS $os_name"
        exit 0
        ;;
esac

command -v claude >/dev/null 2>&1 && echo "Claude Code is available: $(command -v claude)"
command -v codex >/dev/null 2>&1 && echo "Codex is available: $(command -v codex)"
echo "Run claude and codex to authenticate after installation."
