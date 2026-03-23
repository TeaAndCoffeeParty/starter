-- 针对 VS Code 环境的额外设置

-- 禁用或覆盖某些插件组件（例如 snacks.explorer）
-- 这里直接修改 snacks 的配置（因为它在 init.lua 中已经加载）
-- 更干净的方式是在插件定义中通过 enabled = not vim.g.vscode 来禁用，见下一步

-- 覆盖 keymaps，例如将 <leader>e 映射到 VS Code 资源管理器
-- 延迟到 VimEnter 事件，确保在所有插件加载后覆盖
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- 删除可能存在的 <leader>e 映射
    pcall(vim.keymap.del, "n", "<leader>e")
    -- 重新映射到 VS Code 命令
    vim.keymap.set(
      "n",
      "<leader>e",
      "<Cmd>call VSCodeNotify('workbench.view.explorer')<CR>",
      { desc = "Open VS Code Explorer" }
    )
  end,
})

-- 其他针对 VS Code 的映射或设置（例如禁用某些自动命令）
