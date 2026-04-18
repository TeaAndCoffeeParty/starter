return {
  "Civitasv/cmake-tools.nvim",
  opts = function(_, opts)
    -- 其他已有的配置项（例如 cmake_runner）保持不变
    opts.cmake_runner = {
      name = "toggleterm",
      opts = {
        toggleterm = {
          direction = "float",
          close_on_exit = false,
          auto_scroll = true,
          singleton = true,
        },
      },
    }

    -- 仅在 Windows 下启用 compile_commands.json 自动复制
    if vim.fn.has("win32") == 1 then
      opts.cmake_compile_commands_options = {
        action = "copy",
        target = vim.loop.cwd(),
      }
    else
      -- 其他平台不需要此选项，可以留空或删除已有值
      opts.cmake_compile_commands_options = nil
    end

    return opts
  end,
}
