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
  { "<leader>mB", ":CMakeSelectBuildType<CR>", desc = "Select Build Type", icon = "🔧", mode = "n" },
  { "<leader>mP", ":CMakeSelectBuildPreset<CR>", desc = "Select Build Preset", icon = "📐", mode = "n" },

  -- ai-assistant
  { "<leader>a", group = "AI Assistant", icon = "󰭹" },
  { "<leader>ao", ":Chat<CR>", desc = "Open Chat", icon = "💬", mode = "n" },
  { "<leader>aq", ":ChatClose<CR>", desc = "Close Chat", icon = "❌", mode = "n" },
  { "<leader>al", ":ChatCurrentLine<CR>", desc = "Send Current Line", icon = "🔢", mode = "n" },
  { "<leader>af", ":ChatFile<CR>", desc = "Send Entire File", icon = "📁", mode = "n" },
  { "<leader>ah", ":ChatShowHistory<CR>", desc = "Show History", icon = "📜", mode = "n" },
  {
    "<leader>ad",
    function()
      vim.ui.input({
        prompt = "Enter folder path (default: current directory): ",
        default = ".",
        completion = "dir",
      }, function(input)
        if input ~= nil then
          local folder_path = input ~= "" and input or "."
          vim.cmd("ChatFolder " .. folder_path)
        end
      end)
    end,
    desc = "Send Folder Content (.h/.cpp)",
    icon = "📂",
    mode = "n",
  },
  {
    "<leader>ac",
    function()
      local choice = vim.fn.confirm("是否要清除聊天历史记录?", "&Yes\n&No")

      if choice == 1 then
        vim.cmd("ChatClearHistory")
        vim.notify("聊天历史记录已清除。", vim.log.levels.INFO)
      else
        -- 用户选择了 'No'，不执行任何操作
        vim.notify("清除聊天历史记录操作已取消。", vim.log.levels.INFO)
      end
    end,
    desc = "Clear History (with confirmation)", -- 建议更新描述，表明有确认
    icon = "🗑",
    mode = "n",
  },
  { "<leader>ap", ":ChatClearPrompt<CR>", desc = "Clear Prompt Context", icon = "🧹", mode = "n" },
  { "<leader>am", ":ChatSelectModel<CR>", desc = "Select AI Model", icon = "🧠", mode = "n" },
  -- Visual 模式
  { "<leader>av", ":ChatVisual<CR>", desc = "Send Visual Selection", icon = "🔍", mode = "v" },
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_cpp_keymaps", { clear = true }),
  pattern = { "c", "cpp", "cxx", "objc", "objcpp", "cuda" },
  callback = function()
    wk.add({
      { "<leader>c", group = "C++/Code", icon = "", buffer = true },
      { "<leader>cg", "<Cmd>ImplementInSource<CR>", desc = "Create Definition", mode = "n", buffer = true },
      {
        "<leader>ch",
        "<cmd>ClangdSwitchSourceHeader<cr>",
        desc = "Switch Header/Source",
        icon = "",
        mode = "n",
        buffer = true,
      },
      {
        "<leader>ca",
        function()
          vim.lsp.buf.code_action()
        end,
        desc = "Code Action",
        icon = "💡",
        mode = { "n", "v" },
        buffer = true,
      },
      {
        "<leader>ci",
        function()
          vim.lsp.buf.implementation()
        end,
        desc = "Go to Implementation",
        icon = "",
        mode = "n",
        buffer = true,
      },
      {
        "<leader>cr",
        function()
          vim.lsp.buf.rename()
        end,
        desc = "Rename Symbol",
        icon = "",
        mode = "n",
        buffer = true,
      },
      {
        "<leader>cu",
        function()
          vim.lsp.buf.references()
        end,
        desc = "Find References",
        icon = "",
        mode = "n",
        buffer = true,
      },
      {
        "<leader>ct",
        function()
          vim.lsp.buf.type_definition()
        end,
        desc = "Go to Type Definition",
        icon = "",
        mode = "n",
        buffer = true,
      },
    })
  end,
})

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
-- 在插入模式下，用 jk 退出
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
