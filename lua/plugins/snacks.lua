return {
  "folke/snacks.nvim",
  opts = {
    explorer = { enabled = not vim.g.vscode }, -- 仅在终端 Neovim 中启用 explorer
    -- 其他组件保持默认（如 dashboard, notifier, picker 等）
  },
}

