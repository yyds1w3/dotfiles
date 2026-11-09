return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      clangd = {
        keys = {
          { "<leader>ch", false },
        },
        cmd = {
          "clangd",
          "--header-insertion=never", -- 物理禁止自动插入头文件
          "--header-insertion-decorators=0", -- 补全列表里也不要显示那个“+”号提示
          "--background-index", -- 让 clangd 在后台索引文件（可选，提高性能）
          "--clang-tidy", -- 开启代码静态检查（可选）
        },
      },
    },
  },
}
