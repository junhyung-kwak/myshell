#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
model="$(sysctl -n hw.model 2>/dev/null || true)"
hitoolbox_plist="$script_dir/preferences/com.apple.HIToolbox.plist"
symbolichotkeys_plist="$script_dir/preferences/com.apple.symbolichotkeys.plist"
spectacle_plist="$script_dir/preferences/com.divisiblebyzero.Spectacle.plist"

if [ "$(uname -s)" != "Darwin" ]; then
    echo "macos/setup.sh skipped: not macOS"
    exit 0
fi

if [[ "$model" == MacBook* ]]; then
    echo "MacBook detected: $model"
else
    echo "macOS detected: $model"
fi

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

load_homebrew_env

if ! command -v brew >/dev/null 2>&1; then
    install_homebrew
    load_homebrew_env
fi

if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew install finished, but brew is still not on PATH. Open a new terminal and rerun $script_dir/setup.sh"
    exit 1
fi

app_path_for_cask() {
    local cask="$1"

    case "$cask" in
        iterm2) echo "/Applications/iTerm.app" ;;
        karabiner-elements) echo "/Applications/Karabiner-Elements.app" ;;
        spectacle) echo "/Applications/Spectacle.app" ;;
        visual-studio-code) echo "/Applications/Visual Studio Code.app" ;;
    esac
}

import_preference_domain() {
    local domain="$1"
    local plist="$2"
    local description="$3"

    if [ -f "$plist" ]; then
        defaults import "$domain" "$plist"
        echo "Imported $description from $plist"
    else
        echo "$description not found: $plist"
    fi
}

echo "Installing macOS apps from $script_dir/Brewfile"
while IFS= read -r line; do
    cask="${line#cask \"}"
    cask="${cask%\"}"

    [ -z "$cask" ] && continue
    [[ "$line" == cask\ * ]] || continue

    if brew list --cask "$cask" >/dev/null 2>&1; then
        echo "Already installed: $cask"
        continue
    fi

    app_path="$(app_path_for_cask "$cask")"
    if [ -n "$app_path" ] && [ -d "$app_path" ]; then
        echo "Already installed outside Homebrew: $cask ($app_path)"
        continue
    fi

    if ! brew install --cask "$cask"; then
        echo "Failed to install cask: $cask"
    fi
done < "$script_dir/Brewfile"

"$script_dir/defaults.sh"

import_preference_domain com.apple.HIToolbox "$hitoolbox_plist" "input source settings"
import_preference_domain com.apple.symbolichotkeys "$symbolichotkeys_plist" "keyboard shortcut settings"
import_preference_domain com.divisiblebyzero.Spectacle "$spectacle_plist" "Spectacle settings"

if [ -d "/Applications/Visual Studio Code.app" ]; then
    code_bin="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
    if [ -x "$code_bin" ] && ! command -v code >/dev/null 2>&1; then
        if ln -s "$code_bin" /usr/local/bin/code 2>/dev/null; then
            echo "VS Code command installed: code"
        else
            echo "VS Code installed. To enable the code command, run:"
            echo "  sudo ln -s \"$code_bin\" /usr/local/bin/code"
        fi
    fi
fi

karabiner_dst="$HOME/.config/karabiner/karabiner.json"
karabiner_src="$script_dir/karabiner/karabiner.json"

mkdir -p "$(dirname "$karabiner_dst")"
if [ -f "$karabiner_dst" ] && ! cmp -s "$karabiner_src" "$karabiner_dst"; then
    backup="$karabiner_dst.backup.$(date +%Y%m%d%H%M%S)"
    cp "$karabiner_dst" "$backup"
    echo "Backed up existing Karabiner config to $backup"
fi
cp "$karabiner_src" "$karabiner_dst"
echo "Karabiner config installed to $karabiner_dst"

if open -a "Karabiner-Elements" 2>/dev/null; then
    echo "Opened Karabiner-Elements."
else
    echo "Karabiner-Elements is not available to open."
fi

open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility" 2>/dev/null || true
open "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent" 2>/dev/null || true
echo "Opened macOS Privacy settings for Karabiner permissions."
echo "Some macOS and Karabiner changes may require logout or app restart."
