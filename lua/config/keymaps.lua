-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ✅ 使用 add() 手动添加映射，并精确控制 icon
local wk = require("which-key")
wk.add({
  { "<leader>m", group = "CMake", icon = "" }, -- 设置分组图标

  { "<leader>mg", ":CMakeGenerate<CR>", desc = "Generate", icon = "🛠", mode = "n" },
  { "<leader>mb", ":CMakeBuild<CR>", desc = "Build", icon = "📦", mode = "n" },
  { "<leader>mr", ":CMakeRun<CR>", desc = "Run", icon = "🚀", mode = "n" },
  { "<leader>mc", ":CMakeClean<CR>", desc = "Clean", icon = "🗑", mode = "n" },
  { "<leader>mt", ":CMakeRunTest<CR>", desc = "Test", icon = "🧪", mode = "n" },
  { "<leader>ms", ":CMakeSelectLaunchTarget<CR>", desc = "Launch Target", icon = "🎯", mode = "n" },
  { "<leader>mS", ":CMakeSelectBuildTarget<CR>", desc = "Build Target", icon = "⚙ ", mode = "n" },
})

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- 在插入模式下，用 jk 退出
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
