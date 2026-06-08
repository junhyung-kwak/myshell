#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
model="$(sysctl -n hw.model 2>/dev/null || true)"

if [ "$(uname -s)" != "Darwin" ]; then
    echo "macos/setup.sh skipped: not macOS"
    exit 0
fi

if [[ "$model" == MacBook* ]]; then
    echo "MacBook detected: $model"
else
    echo "macOS detected: $model"
fi

if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Install Homebrew first, then rerun $script_dir/setup.sh"
    exit 0
fi

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

    if ! brew install --cask "$cask"; then
        echo "Failed to install cask: $cask"
    fi
done < "$script_dir/Brewfile"

"$script_dir/defaults.sh"

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
    echo "Karabiner config already exists; not overwriting local settings."
    echo "Run $script_dir/export-settings.sh to save this Mac's current settings into the repo."
else
    cp "$karabiner_src" "$karabiner_dst"
    echo "Karabiner config installed to $karabiner_dst"
fi
echo "Some macOS and Karabiner changes may require logout or app restart."
