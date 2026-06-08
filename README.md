# myshell

Personal shell and machine bootstrap files.

## Install

```bash
./install.sh
```

The installer copies this repository to `~/.config/myshell`, updates
`~/.bashrc` once, and runs the macOS bootstrap only on macOS.

## macOS / MacBook setup

macOS setup is stored in `macos/`.

- `macos/setup.sh`: detects macOS and MacBook hardware, installs Homebrew casks, and applies local settings.
- `macos/Brewfile`: records GUI apps to install, including iTerm2, Karabiner-Elements, Spectacle, and Visual Studio Code.
- `macos/defaults.sh`: stores keyboard-related macOS defaults.
- `macos/karabiner/karabiner.json`: stores Karabiner key settings.

Run it directly after editing macOS settings:

```bash
~/.config/myshell/macos/setup.sh
```

Save this Mac's current settings back into the repo:

```bash
macos/export-settings.sh
```

Spectacle is kept because this setup asks for it, but it is an abandoned app and may disappear from Homebrew. If the cask is unavailable, the script continues and reports the failed item.
