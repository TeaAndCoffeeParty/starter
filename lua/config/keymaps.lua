-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- CMake Tools 快捷键
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap("n", "<leader>mg", ":CMakeGenerate<CR>", opts) -- Generate (对应 cmake ../Step1)
vim.api.nvim_set_keymap("n", "<leader>mb", ":CMakeBuild<CR>", opts) -- Build (对应 cmake --build .)
vim.api.nvim_set_keymap("n", "<leader>mr", ":CMakeRun<CR>", opts) -- Run (对应 ./Tutorial)
vim.api.nvim_set_keymap("n", "<leader>mc", ":CMakeClean<CR>", opts) -- Clean
vim.api.nvim_set_keymap("n", "<leader>mt", ":CMakeRunTest<CR>", opts) -- Run Test (ctest -R xx)
vim.api.nvim_set_keymap("n", "<leader>ms", ":CMakeSelectLaunchTarget<CR>", opts) -- Select Launch Target
vim.api.nvim_set_keymap("n", "<leader>mS", ":CMakeSelectBuildTarget<CR>", opts) -- Select Build Target

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
