-- DeepSeek plugin example

return {
  "TeaAndCoffeeParty/ai-assistant.nvim",
  opts = {
    enabled = true,
    window = { width = 0.6, height = 0.8, split_ratio = 0.2 },
    select_model = "google_gemini", -- model list "google_gemini", "aliyun_qwen", "deepseek"
    timeout = 80000,
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function(_, opts)
    require("ai-assistant").setup(opts)
  end,
}
