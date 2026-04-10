-- nvim-osc52
return {
  "ojroques/nvim-osc52",
  opts = {
    max_length = 0, -- 无限制
    silent = true, -- 不显示消息（你已经有其他提示了）
    trim = false,
  },
  config = function(_, opts)
    require("osc52").setup(opts)
    -- 只注册一个 autocmd，并确保不与其他剪贴板冲突
    vim.api.nvim_create_autocmd("TextYankPost", {
      group = vim.api.nvim_create_augroup("osc52_yank", { clear = true }),
      callback = function()
        local event = vim.v.event
        if (event.operator == "y" or event.operator == "d") and event.regname == "" then
          require("osc52").copy_register("")
        end
      end,
    })
  end,
}
