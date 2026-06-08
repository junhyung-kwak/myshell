#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$(uname -s)" != "Darwin" ]; then
    echo "macos/export-settings.sh skipped: not macOS"
    exit 0
fi

karabiner_src="$HOME/.config/karabiner/karabiner.json"
karabiner_dst="$script_dir/karabiner/karabiner.json"

if [ -f "$karabiner_src" ]; then
    mkdir -p "$(dirname "$karabiner_dst")"
    cp "$karabiner_src" "$karabiner_dst"
    echo "Saved Karabiner config to $karabiner_dst"
else
    echo "Karabiner config not found: $karabiner_src"
fi

{
    echo "#!/usr/bin/env bash"
    echo "set -euo pipefail"
    echo

    key_repeat="$(defaults read -g KeyRepeat 2>/dev/null || true)"
    if [ -n "$key_repeat" ]; then
        echo "defaults write -g KeyRepeat -int $key_repeat"
    fi

    initial_key_repeat="$(defaults read -g InitialKeyRepeat 2>/dev/null || true)"
    if [ -n "$initial_key_repeat" ]; then
        echo "defaults write -g InitialKeyRepeat -int $initial_key_repeat"
    fi

    fn_state="$(defaults read -g com.apple.keyboard.fnState 2>/dev/null || true)"
    if [ -n "$fn_state" ]; then
        if [ "$fn_state" = "1" ]; then
            echo "defaults write -g com.apple.keyboard.fnState -bool true"
        else
            echo "defaults write -g com.apple.keyboard.fnState -bool false"
        fi
    fi

    press_and_hold="$(defaults read -g ApplePressAndHoldEnabled 2>/dev/null || true)"
    if [ -n "$press_and_hold" ]; then
        if [ "$press_and_hold" = "1" ]; then
            echo "defaults write -g ApplePressAndHoldEnabled -bool true"
        else
            echo "defaults write -g ApplePressAndHoldEnabled -bool false"
        fi
    fi
} > "$script_dir/defaults.sh"

chmod +x "$script_dir/defaults.sh"
echo "Saved keyboard defaults to $script_dir/defaults.sh"
