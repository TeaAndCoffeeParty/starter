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
    -- 切换主侧边栏（资源管理器）
    pcall(vim.keymap.del, "n", "<leader>e")
    vim.keymap.set(
      "n",
      "<leader>e",
      "<Cmd>call VSCodeNotify('workbench.action.focusSideBar')<CR>",
      { desc = "Focus Side Bar" }
    )

    -- 切换副侧边栏（聊天/输出）
    pcall(vim.keymap.del, "n", "<leader>ao")
    vim.keymap.set(
      "n",
      "<leader>ao",
      "<Cmd>call VSCodeNotify('workbench.action.toggleAuxiliaryBar')<CR>",
      { desc = "Toggle Secondary Side Bar" }
    )

    -- 使用 VS Code CMake Tools 扩展的命令
    vim.keymap.set("n", "<leader>mg", "<Cmd>call VSCodeNotify('cmake.configure')<CR>", { desc = "CMake Configure" })
    vim.keymap.set("n", "<leader>mb", "<Cmd>call VSCodeNotify('cmake.build')<CR>", { desc = "CMake Build" })
    vim.keymap.set("n", "<leader>mr", "<Cmd>call VSCodeNotify('cmake.run')<CR>", { desc = "CMake Run" })
    -- 其他命令可参考 VS Code CMake Tools 的命令列表（如 'cmake.clean'、'cmake.setBuildType' 等）
  end,
})
