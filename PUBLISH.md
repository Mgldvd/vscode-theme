# Publish Guide (No Credentials Setup)

This guide assumes your Marketplace credentials are **already configured** on this machine.

---

## ✅ Step 1: Build new version

```bash
mise run build
```

This command will:
- bump patch version in `package.json`
- build the VSIX package

Then commit and push:

```bash
git add package.json themes/Mgldvd-color-theme.json .vscode/settings.json
git commit -m "🔧 chore(release): bump version and package theme"
git push
```

---

## 🚀 Step 2: Publish

```bash
mise run publish
```

This command will:
- publish to VS Code Marketplace (`npx @vscode/vsce publish`)
- create git tag `v<package.json version>`
- push the tag to origin
- trigger `.github/workflows/release.yml` (GitHub Release + VSIX asset)

---

## 🧪 Optional test package (no publish)

```bash
mise run build-test
```

Output:
- `mgldvd-test.vsix`


## Get Token

- https://dev.azure.com/mgldvd/vscode