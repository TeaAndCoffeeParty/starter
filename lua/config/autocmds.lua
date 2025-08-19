-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.b.autoformat = true
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.autoindent = true
  end,
})

-- 创建一个专用于拼写检查的自动命令组
local augroup = vim.api.nvim_create_augroup("SmartSpellCheck", { clear = true })

-- 创建自动命令
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  group = augroup,
  pattern = "*", -- 匹配所有文件
  callback = function()
    -- 检查缓冲区是否可修改，以及不是特殊的缓冲区（如插件窗口）
    if vim.bo.modifiable and vim.bo.buftype == "" then
      -- 1. 启用本地拼写检查
      vim.opt_local.spell = true

      -- 2. 设置本地拼写检查的语言为：英语(en) 和 中日韩字符(cjk)
      vim.opt_local.spelllang = { "en", "cjk" }
    else
      vim.opt_local.spell = false
    end
  end,
})
