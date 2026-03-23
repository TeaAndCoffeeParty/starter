-- ~/.config/nvim/lua/config/vscode_neovim.lua

vim.notify("Loading VS Code specific Neovim configuration...", vim.log.levels.INFO)
-- 只在 VSCode 环境中生效
if not vim.g.vscode then
  return
end

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    pcall(vim.keymap.del, "n", "<leader>e")
    -- 切换侧边栏可见性（包括资源管理器）
    vim.keymap.set(
      "n",
      "<leader>e",
      "<Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>",
      { desc = "Toggle VS Code Explorer" }
    )
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    pcall(vim.keymap.del, "n", "<leader>e")
    -- 切换侧边栏可见性（包括资源管理器）
    vim.keymap.set(
      "n",
      "<leader>e",
      "<Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>",
      { desc = "Toggle VS Code Explorer" }
    )
  end,
})

