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
    -- === 文件浏览器 ===
    pcall(vim.keymap.del, "n", "<leader>e")
    vim.keymap.set(
      "n",
      "<leader>e",
      "<Cmd>call VSCodeNotify('workbench.action.focusSideBar')<CR>",
      { desc = "Focus Side Bar" }
    )

    -- === Git 源代码管理 ===
    pcall(vim.keymap.del, "n", "<leader>gg")
    vim.keymap.set(
      "n",
      "<leader>gg",
      "<Cmd>call VSCodeNotify('workbench.view.scm')<CR>",
      { desc = "Open Source Control", silent = true }
    )

    -- === 切换副侧边栏（聊天/输出） ===
    pcall(vim.keymap.del, "n", "<leader>ao")
    vim.keymap.set(
      "n",
      "<leader>ao",
      "<Cmd>call VSCodeNotify('workbench.action.toggleAuxiliaryBar')<CR>",
      { desc = "Toggle Secondary Side Bar" }
    )

    -- === 使用 VS Code CMake Tools 扩展的命令 ===
    vim.keymap.set("n", "<leader>mg", "<Cmd>call VSCodeNotify('cmake.configure')<CR>", { desc = "CMake Configure" })
    vim.keymap.set("n", "<leader>mb", "<Cmd>call VSCodeNotify('cmake.build')<CR>", { desc = "CMake Build" })
    vim.keymap.set(
      "n",
      "<leader>mr",
      "<Cmd>call VSCodeNotify('cmake.launchTarget')<CR>",
      { desc = "CMake Launch Target" }
    )
    vim.keymap.set("n", "<leader>mc", "<Cmd>call VSCodeNotify('cmake.clean')<CR>", { desc = "CMake Clean" })
    vim.keymap.set("n", "<leader>mt", "<Cmd>call VSCodeNotify('cmake.ctest')<CR>", { desc = "CMake Run Test" })
    vim.keymap.set(
      "n",
      "<leader>ms",
      "<Cmd>call VSCodeNotify('cmake.setBuildType')<CR>",
      { desc = "CMake Set Build Type" }
    )

    -- === 关闭当前编辑器 ===
    vim.keymap.set(
      "n",
      "<leader>bd",
      "<Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>",
      { desc = "Close active editor" }
    )

    -- === 关闭其他编辑器（标签页） ===
    vim.keymap.set(
      "n",
      "<leader>bo",
      "<Cmd>call VSCodeNotify('workbench.action.closeOtherEditors')<CR>",
      { desc = "Close other editors" }
    )

    -- === 关闭左侧所有编辑器 ===
    vim.keymap.set(
      "n",
      "<leader>bl",
      "<Cmd>call VSCodeNotify('workbench.action.closeEditorsToTheLeft')<CR>",
      { desc = "Close editors to the left" }
    )

    -- === 关闭右侧所有编辑器 ===
    vim.keymap.set(
      "n",
      "<leader>br",
      "<Cmd>call VSCodeNotify('workbench.action.closeEditorsToTheRight')<CR>",
      { desc = "Close editors to the right" }
    )
  end,
})
