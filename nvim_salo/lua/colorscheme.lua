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
