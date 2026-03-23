-- 通用 bootstrap（LazyVim 的核心）
require("config.lazy") -- 你原来的 LazyVim 启动，会加载所有插件

-- 如果运行在 VS Code 中，加载额外的适配配置
if vim.g.vscode then
  vim.notify("Running in VS Code mode", vim.log.levels.INFO)
  -- 加载 VS Code 专用的设置（比如覆盖 keymaps，禁用某些插件组件）
  require("config.vscode_neovim")
end
