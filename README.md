```markdown
# 🧠 Local Neovim (ARM64) Installation + Custom Config

This guide walks you through installing **Neovim** locally (no `sudo`, no system-wide pollution) on an ARM64 Linux machine, and setting up a custom configuration from [kebris-c/neovim.config](https://github.com/kebris-c/neovim.config).

Useful for:
- Keeping your system clean.
- Having a portable Neovim setup.
- Pretending you're more productive than you actually are.

---

## 📦 Requirements

- ARM64 Linux system (Raspberry Pi, Pine64, etc.)
- Basic tools installed: `curl`, `tar`, `git`, `bash`
- Enough will to live to use a terminal

---

## 🔧 Installation Steps

### 1. Download and extract Neovim locally

```bash
mkdir -p ~/.local/bin
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
tar -xzf nvim-linux-arm64.tar.gz
mv nvim-linux-arm64 ~/.local/bin/nvim
rm nvim-linux-arm64.tar.gz
```

### 2. Add Neovim to your PATH

Append this to your shell config (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
export PATH="$HOME/.local/bin/nvim/bin:$PATH"
```

Then reload your shell:

```bash
source ~/.bashrc   # or ~/.zshrc or your weapon of choice
```

Test it:

```bash
nvim --version
```

---

### 3. Clone the custom Neovim config

```bash
mkdir -p ~/.config
git clone https://github.com/kebris-c/neovim.config ~/.config/nvim
```

Launch it:

```bash
nvim
```

---

## 🧼 Optional Cleanup (for minimalists)

Delete Neovim's built-in docs (they're for cowards who read instructions):

```bash
rm -rf ~/.local/bin/nvim/share/nvim/runtime/doc
```

---

## 🧠 Notes

- No root privileges are needed. You're installing it like a responsible, paranoid hacker.
- If something breaks:  
  - 1st try: Blame the config.  
  - 2nd try: Blame yourself.  
  - Final boss: Blame the stars.

---

## ☠️ Uninstalling (in case Vim wins)

```bash
rm -rf ~/.local/bin/nvim
rm -rf ~/.config/nvim
sed -i '/nvim\/bin/d' ~/.bashrc  # or your shell config
```

---

## 🧪 Optional: Use the custom `.zshrc` file

Warning: this will **overwrite** your existing `.zshrc`. A backup will be made just in case you're not a complete maniac.

```bash
curl -o ~/.zshrc.kebris https://raw.githubusercontent.com/kebris-c/neovim.config/main/zshrc
[ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.backup
mv ~/.zshrc.kebris ~/.zshrc
source ~/.zshrc
```

If everything explodes, restore with:

```bash
mv ~/.zshrc.backup ~/.zshrc && source ~/.zshrc
```

---

Happy editing, you terminal goblin. 🦑
```
