-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- 1. 动态生成 256 种随机高饱和度颜色
local trail_hls = {}
math.randomseed(os.time()) -- 初始化随机种子

for i = 1, 256 do
  local hl_name = "RandomTrail" .. i
  -- 生成明亮的随机 Hex 颜色 (避免生成太暗的颜色跟背景撞色)
  local r = math.random(100, 255)
  local g = math.random(100, 255)
  local b = math.random(100, 255)
  local color_hex = string.format("#%02x%02x%02x", r, g, b)

  vim.api.nvim_set_hl(0, hl_name, { bg = color_hex, fg = "NONE" })
  table.insert(trail_hls, hl_name)
end

local ns_id = vim.api.nvim_create_namespace("chaos_trail")
local last_pos = nil

vim.api.nvim_create_autocmd("CursorMoved", {
  group = vim.api.nvim_create_augroup("AcmChaosTrail", { clear = true }),
  callback = function()
    local curr_pos = vim.api.nvim_win_get_cursor(0)
    local curr_buf = vim.api.nvim_get_current_buf()

    if last_pos and (last_pos[1] ~= curr_pos[1] or last_pos[2] ~= curr_pos[2]) then
      local r, c = last_pos[1] - 1, last_pos[2]

      -- 越界检查与行长度获取
      local line_content = vim.api.nvim_buf_get_lines(curr_buf, r, r + 1, false)[1]

      if line_content and #line_content >= c then
        -- 处理空行和行尾的逻辑
        local end_c = (line_content == "" or #line_content == c) and c or c + 1

        -- 随机抽取 256 色中的一种
        local random_hl = trail_hls[math.random(1, #trail_hls)]

        -- 绘制残影
        local ok, m_id = pcall(vim.api.nvim_buf_set_extmark, curr_buf, ns_id, r, c, {
          end_col = end_c,
          hl_group = random_hl,
          priority = 1000,
        })

        if ok then
          -- 想要“更长”的影子？把 500 改大即可，比如 800
          vim.defer_fn(function()
            pcall(vim.api.nvim_buf_del_extmark, curr_buf, ns_id, m_id)
          end, 200)
        end
      end
    end

    last_pos = curr_pos
  end,
})
