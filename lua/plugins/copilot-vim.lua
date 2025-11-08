-- ~/.config/nvim/lua/plugins/copilot-vim.lua

return {
  "github/copilot.vim",
  -- 官方插件建议在插入模式开始时加载，或者在需要时通过命令加载
  event = "InsertEnter",
  -- 或者，如果您想手动启动，可以用 cmd = "Copilot"
}
