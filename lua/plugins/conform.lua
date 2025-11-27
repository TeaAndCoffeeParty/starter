-- ~/.config/nvim/lua/plugins/conform.lua
return {
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    opts = {
      formatters_by_ft = {
        cpp = { "clang_format" },
        c = { "clang_format" },
      },
    },
  },
}
