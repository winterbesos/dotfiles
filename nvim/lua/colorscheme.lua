-- load themes config
require ("themes.github-nvim-theme")
require ("themes.catppuccin")

-- cursor color: #61AFEF
local colorscheme = "catppuccin"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

-- vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
--   callback = function()
--     vim.cmd [[ setlocal winhighlight=Normal:NormalActive,NormalNC:NormalInactive ]]
--   end
-- })
-- 
-- vim.api.nvim_create_autocmd("WinLeave", {
--   callback = function()
--     vim.cmd [[ setlocal winhighlight=Normal:NormalInactive,NormalNC:NormalInactive ]]
--   end
-- })
-- 
-- vim.api.nvim_set_hl(0, "NormalActive", { bg = "#1e1e2e" })   -- 当前窗口背景
-- vim.api.nvim_set_hl(0, "NormalInactive", { bg = "#444444" }) -- 非活动窗口背景
