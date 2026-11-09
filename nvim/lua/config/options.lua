-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- 设置 Tab 为 4 个空格
vim.opt.shiftwidth = 4 -- 每一级缩进占用的空格数
vim.opt.tabstop = 4 -- 一个 Tab 字符占用的空格数
vim.opt.softtabstop = 4 -- 插入模式下按 Tab 键时实际插入的空格数
vim.opt.expandtab = true -- 将 Tab 键自动转换为空格
vim.opt.scrolloff = 10
vim.g.autoformat = false
