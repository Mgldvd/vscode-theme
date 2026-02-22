# Mgldvd Theme – Quick Dev Guide

## Edit

- Theme file: `themes/Mgldvd-color-theme.json`
- Extension config: `package.json`

## Run (development)

1. Open this project in VS Code.
2. Press `F5` (Run Extension).
3. In the new window, open Command Palette and run: `Preferences: Color Theme`.
4. Select: `Mgldvd`.

## Update theme

- Edit `themes/Mgldvd-color-theme.json`.
- In the dev window, run `Developer: Reload Window` to refresh.

## Package (optional)

```bash
npm i -g @vscode/vsce
vsce package
```

This creates a `.vsix` file you can install locally.
