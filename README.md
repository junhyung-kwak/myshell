# myshell

Personal shell and machine bootstrap files.

## Install

```bash
./install.sh
```

The installer copies this repository to `~/.config/myshell`, updates
`~/.bashrc` once, runs the macOS bootstrap only on macOS, and installs AI
coding tools.

## macOS / MacBook setup

macOS setup is stored in `macos/`.

- `macos/setup.sh`: detects macOS and MacBook hardware, installs Homebrew casks, and applies local settings.
- `macos/Brewfile`: records GUI apps to install, including iTerm2, Karabiner-Elements, Spectacle, and Visual Studio Code.
- `macos/defaults.sh`: stores keyboard-related macOS defaults.
- `macos/karabiner/karabiner.json`: stores Karabiner key settings.
- `macos/preferences/com.apple.HIToolbox.plist`: stores macOS input source settings.
- `macos/preferences/com.apple.symbolichotkeys.plist`: stores macOS keyboard shortcut settings.
- `macos/preferences/com.divisiblebyzero.Spectacle.plist`: stores Spectacle settings.

The setup script installs Homebrew when missing, skips apps already installed
in `/Applications`, applies the settings stored in this repository, opens
Karabiner-Elements after copying config, and opens the macOS Privacy panes that
must be approved manually for keyboard remapping. If a Karabiner config already
exists on the target Mac, it is backed up before the repository config is copied.

Run it directly after editing macOS settings:

```bash
~/.config/myshell/macos/setup.sh
```

Update the repository from the current Mac's settings:

```bash
macos/export-settings.sh
```

Spectacle is kept because this setup asks for it, but it is an abandoned app and may disappear from Homebrew. If the cask is unavailable, the script continues and reports the failed item.

## AI tools

AI coding tool setup is stored in `ai/`.

- `ai/setup.sh`: installs AI coding CLIs.
- `ai/Brewfile`: records macOS Homebrew casks for Claude Code and Codex.

Run it directly:

```bash
~/.config/myshell/ai/setup.sh
```

On macOS, the setup uses the official Homebrew casks for Claude Code and Codex.
On Linux, including Ubuntu, it uses the official install scripts from Anthropic
and OpenAI. After installation, run `claude` and `codex` to authenticate each
tool.
