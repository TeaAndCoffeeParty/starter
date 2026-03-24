-- ~/.config/nvim/lua/config/vscode_neovim.lua

-- 只在 VSCode 环境中生效
if not vim.g.vscode then
  return
end
vim.notify("Loading VS Code specific Neovim configuration...", vim.log.levels.INFO)
vim.g.which_key_disabled = 1

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
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
    vim.keymap.set("n", "<leader>mr", "<Cmd>call VSCodeNotify('cmake.runTarget')<CR>", { desc = "CMake Run Target" })
    vim.keymap.set("n", "<leader>mc", "<Cmd>call VSCodeNotify('cmake.clean')<CR>", { desc = "CMake Clean" })
    vim.keymap.set(
      "n",
      "<leader>ms",
      "<Cmd>call VSCodeNotify('cmake.setBuildType')<CR>",
      { desc = "CMake Set Build Type" }
    )
    -- 其他命令可参考 VS Code CMake Tools 的命令列表（如 'cmake.clean'、'cmake.setBuildType' 等）
  end,
})
