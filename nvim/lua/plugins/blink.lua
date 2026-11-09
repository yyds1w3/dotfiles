return {
  {
    "saghen/blink.cmp",
    opts = {
      -- 快捷键设置
      keymap = {
        preset = "none", -- 禁用所有预设，完全自定义（推荐，防止冲突）

        -- 【核心配置】
        -- 如果补全菜单可见，Tab 会确认当前的补全项并关闭菜单
        -- 如果不可见，则执行普通的 Tab 缩进
        ["<Tab>"] = { "accept", "fallback" },

        -- 使用 Ctrl + j/k 或者键盘上下键来在菜单里移动
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },

        -- 【让 Enter 回归原本功能】
        -- 将 Enter (CR) 设置为 fallback，它就只会执行换行，不再触发补全
        ["<CR>"] = { "fallback" },

        -- 其他常用快捷键（可选）
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
      },
    },
  },
}
