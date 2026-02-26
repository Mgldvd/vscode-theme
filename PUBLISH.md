# Publish Guide (No Credentials Setup)

This guide assumes your Marketplace credentials are **already configured** on this machine.

---

## 1) Sync theme colors (optional)

```bash
mise run sync-colors-dry
```

If needed:

```bash
mise run sync-colors
```

---

## 2) Build a new version

```bash
mise run build
```

This will:
- bump patch version in `package.json`
- build the VSIX package

---

## 3) Commit and push

```bash
git add package.json themes/Mgldvd-color-theme.json .vscode/settings.json
```

```bash
git commit -m "🔧 chore(release): bump version and package theme"
```

```bash
git push
```

---

## 4) Publish to VS Code Marketplace

- https://dev.azure.com/mgldvd/_usersSettings/tokens

```bash
npx @vscode/vsce publish
```

---

## Test package only (no version bump)

```bash
mise run build-test
```

Output:
- `mgldvd-test.vsix`


## Get Token

- https://dev.azure.com/mgldvd/vscode