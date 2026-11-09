return {
  {
    "duxlabs-dev/base46",
    lazy = false,
    priority = 1000,
  },
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      local group = vim.api.nvim_create_augroup("DraculaItalicKeywords", { clear = true })
      local function italicize_all_groups()
        local colorscheme = vim.g.colors_name or ""
        if not colorscheme:match("^dracula") and not colorscheme:match("^dms") then
          return
        end
        for name in pairs(vim.api.nvim_get_hl(0, {})) do
          local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
          if not hl.italic or (hl.cterm and not hl.cterm.italic) then
            -- default=true 会跳过已经存在的高亮组，这里需要实际更新它。
            hl.default = nil
            hl.italic = true
            if hl.cterm then
              hl.cterm.italic = true
            end
            vim.api.nvim_set_hl(0, name, hl)
          end
        end
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        pattern = { "dracula*", "dms" },
        callback = function()
          local keyword_groups = {
            cBlock = true,
            Macro = true,
            Type = true,
            Keyword = true,
            Statement = true,
            Conditional = true,
            Repeat = true,
            Label = true,
            Exception = true,
            PreProc = true,
            Include = true,
            Define = true,
            PreCondit = true,
            StorageClass = true,
            Structure = true,
            Typedef = true,
          }
          for name in pairs(vim.api.nvim_get_hl(0, {})) do
            if keyword_groups[name] or name:match("^@keyword") then
              -- 保留原有颜色和样式，只增加斜体。
              local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
              hl.italic = true
              vim.api.nvim_set_hl(0, name, hl)
            end
          end

          local extra_italic_groups = {
            "@lsp.type.class.cpp",
            "@lsp.type.namespace.cpp",
            "@lsp.type.type.cpp",
            "@lsp.type.variable.cpp",
            "@lsp.type.function.cpp",
            "@lsp.type.method.cpp",
            "@lsp.type.property.cpp",
          }
          for _, name in ipairs(extra_italic_groups) do
            local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
            hl.italic = true
            vim.api.nvim_set_hl(0, name, hl)
          end

          -- 全部高亮组统一启用斜体，保留原有颜色和其他样式。
          italicize_all_groups()
          vim.schedule(italicize_all_groups)
        end,
      })

      -- 文件类型、LSP 和延迟加载的插件可能在主题之后新增高亮组。
      local function refresh_italics()
        vim.schedule(italicize_all_groups)
      end
      vim.api.nvim_create_autocmd({ "FileType", "LspAttach", "BufWinEnter" }, {
        group = group,
        callback = refresh_italics,
      })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = { "VeryLazy", "LazyLoad" },
        callback = refresh_italics,
      })
    end,
    opts = {
      italic_comment = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dms",
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = "dms"
    end,
  },
}
-- return {
--   "catppuccin/nvim",
--   name = "catppuccin",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd([[colorscheme catppuccin]])
--   end,
-- }
