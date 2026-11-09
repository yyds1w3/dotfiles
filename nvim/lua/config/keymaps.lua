-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 取命令范围对应的文本；没有给范围（:Translate）时取整个缓冲区
local function range_text(opts)
  local first, last
  if opts.range == 0 then
    first, last = 0, -1
  else
    first, last = opts.line1 - 1, opts.line2
  end
  return table.concat(vim.api.nvim_buf_get_lines(0, first, last, false), "\n")
end

local function empty(text)
  return text:match("^%s*$") ~= nil
end

-- 在下方 15 行窗口里显示只读结果
local function show_output(text)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(
    buf,
    0,
    -1,
    false,
    vim.split((text:gsub("\n+$", "")), "\n", { plain = true })
  )
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  vim.cmd("botright 15split")
  vim.api.nvim_win_set_buf(0, buf)
end

-- 翻译：非交互，结果写进分屏
vim.api.nvim_create_user_command("Translate", function(opts)
  local text = range_text(opts)
  if empty(text) then
    vim.notify("Nothing to translate", vim.log.levels.WARN)
    return
  end
  vim.notify("Translating…")
  vim.system({
    "claude",
    "-p",
    "--output-format",
    "text",
    "把下面的内容翻译成中文；保留代码、命令、专有名词不译；只输出译文：\n\n" .. text,
  }, { cwd = vim.fn.expand("~/ai/translate") }, function(res)
    vim.schedule(function()
      local out = res.stdout or ""
      if res.code ~= 0 or empty(out) then
        out = (res.stderr or "") ~= "" and res.stderr or ("claude exited with code " .. res.code)
      end
      show_output(out)
    end)
  end)
end, { range = true, desc = "Translate with AI" })

-- 导师：交互式终端，cwd 决定加载哪份 CLAUDE.md
vim.api.nvim_create_user_command("Tutor", function(opts)
  local text = range_text(opts)
  if empty(text) then
    vim.notify("Nothing to discuss", vim.log.levels.WARN)
    return
  end
  local prompt = "我在读一段英文技术材料，下面是我的选段。"
    .. "请用分层提问检验我的理解：每次只问一层，等我回答后再继续；"
    .. "不要直接讲解答案；该指出错误时不要客气。\n\n" .. text
  vim.cmd("botright new")
  local id = vim.fn.jobstart(
    { "claude", prompt },
    { term = true, cwd = vim.fn.expand("~/ai/tutor") }
  )
  if id <= 0 then
    vim.notify("Failed to start claude", vim.log.levels.ERROR)
    vim.cmd("close")
    return
  end
  vim.cmd("startinsert")
end, { range = true, desc = "Start AI tutor with selection" })

vim.keymap.set("x", "<leader>at", ":Translate<CR>", { desc = "AI translate selection" })
vim.keymap.set("x", "<leader>ae", ":Tutor<CR>", { desc = "AI tutor (interactive)" })