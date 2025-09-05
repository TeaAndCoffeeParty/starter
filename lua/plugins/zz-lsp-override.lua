-- ~/.config/nvim/lua/plugins/zz-lsp-override.lua

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      clangd = {
        root_dir = function(fname)
          -- ---------------------------------------------------------------
          -- 自定义、更底层的根目录查找函数
          -- ---------------------------------------------------------------
          local function find_root(start_path, patterns)
            local path = start_path
            -- 循环向上查找，直到文件系统的根目录
            while path and path ~= "/" do
              for _, pattern in ipairs(patterns) do
                -- 构建要检查的文件/目录的完整路径
                local check_path = path .. "/" .. pattern
                -- 使用 Lua 的原生 io.open 来检查文件是否存在
                local f = io.open(check_path, "r")
                if f then
                  f:close()
                  -- print("--- CUSTOM FIND_ROOT SUCCESS! Found: " .. check_path .. " at root: " .. path)
                  return path -- 找到了，返回当前目录作为根目录
                end
              end
              -- 向上移动一个目录
              path = path:match("(.*/)")
              if path then
                path = path:sub(1, -2)
              end
            end
            print("--- CUSTOM FIND_ROOT FAILED. No pattern found.")
            return nil -- 循环结束都没找到
          end
          -- ---------------------------------------------------------------

          -- 获取当前文件所在的目录
          local start_dir = vim.fn.fnamemodify(fname, ":h")
          -- 开始查找
          return find_root(start_dir, { ".git", "compile_commands.json", "build/compile_commands.json" })
        end,
      },
    },
  },
}
