-- plugins/zz-lsp-override.lua
return {
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy", -- 或 "BufReadPre" 等
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      lspconfig.clangd.setup({
        cmd = { "clangd", "--background-index" },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        root_dir = function(fname)
          local root = util.root_pattern("compile_commands.json", "compile_flags.txt")(fname)
          if root then
            return root
          end
          return util.find_git_ancestor(fname)
        end,
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
        },
      })
    end,
  },
}
