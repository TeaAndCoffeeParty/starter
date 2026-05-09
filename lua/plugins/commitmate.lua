return {
  "ajatdarojat45/commitmate.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "CopilotC-Nvim/CopilotChat.nvim",
    "kdheepak/lazygit.nvim",
  },
  config = function()
    require("commitmate").setup({
      open_lazygit = true,
      ping_message = "CommitMate.nvim is ready 🤝",
    })
  end,
}
