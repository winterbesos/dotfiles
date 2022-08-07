-- load themes config
require ("user.themes.github-nvim-theme")
-- require ("user.themes.onedark")
require ("user.themes.catppuccin")

-- cursor color: #61AFEF
local colorscheme = "catppuccin"

local status_ok, r = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

