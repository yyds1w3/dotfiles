return {
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        -- 核心：禁用输入时的参数签名自动弹窗
        signature = {
          enabled = false,
        },
        -- 可选：如果你觉得悬浮文档（K 键）也烦，也可以关掉
        hover = {
          enabled = false,
        },
      },
    },
  },
}
