-- ~/.config/nvim/lua/plugins/neotest.lua
return {
  {
    "nvim-neotest/neotest",
    dependencies = { "alfaix/neotest-gtest" },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      opts.adapters["neotest-gtest"] = {
        -- 1. 指定构建目录，方便发现 exe
        build_dir = "out/Debug/bin",

        -- 2. 关键：告诉插件哪些文件是测试文件
        is_test_file = function(file_path)
          -- 匹配以 tst_ 开头或 test_ 开头的 .cpp 文件
          local filename = vim.fn.fnamemodify(file_path, ":t")
          return filename:match("^tst_.*%.cpp$") or filename:match("^test_.*%.cpp$")
        end,
      }
    end,
  },
}
