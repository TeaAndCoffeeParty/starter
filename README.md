# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Fist install command in ubuntu

```shell
sudo apt install curl xclip git clang-format-19 fzf make cmake cpplint build-essential ninja-build pkg-config
sudo apt install gcc g++ golang-go ripgrep npm sqlite3 libsqlite3-dev fd-find clangd clang-format

# lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

# Copilot.vim
1. open file to insert
2. exit insert mode
3. Copilot auth

```
