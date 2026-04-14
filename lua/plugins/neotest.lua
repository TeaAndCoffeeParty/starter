-- ~/.config/nvim/lua/plugins/neotest.lua
return {
  {
    "nvim-neotest/neotest",
    dependencies = { "alfaix/neotest-gtest" },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      opts.adapters["neotest-gtest"] = {
        is_test_file = function(file_path)
          -- 匹配以 tst_ 开头或 test_ 开头的 .cpp 文件
          local filename = vim.fn.fnamemodify(file_path, ":t")
          return filename:match("^tst_.*%.cpp$") or filename:match("^test_.*%.cpp$")
        end,
      }
      return opts
    end,
  },
}
