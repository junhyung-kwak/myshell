#!/usr/bin/env bash
set -euo pipefail

target_dir="$HOME/.config/myshell"
shell_rc="$HOME/.bashrc"

append_once() {
    local line="$1"
    local file="$2"

    touch "$file"
    if ! grep -Fxq "$line" "$file"; then
        echo "$line" >> "$file"
    fi
}

echo "cp to $target_dir"
mkdir -p "$target_dir"
cp -R ./* "$target_dir/"

append_once "export MYENV=$HOME/.config/myshell" "$shell_rc"
append_once "export BASH_INCLUDE=$HOME/.config/myshell/func/include.func" "$shell_rc"
append_once "source \$MYENV/bashrc" "$shell_rc"

if [ "$(uname -s)" = "Darwin" ]; then
    "$target_dir/macos/setup.sh"
fi
