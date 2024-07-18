local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  vim.notify("lualine not found!")
  return
end

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local is_dap_panel = function()
  local prefix = 'dap'
  return string.sub(vim.bo.filetype, 1, string.len(prefix)) == prefix
end

local hide_in_dap_panel = function()
  return not is_dap_panel()
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " " },
  colored = false,
  update_in_insert = false,
  always_visible = true,
  cond = hide_in_dap_panel,
}

local diff = {
  "diff",
  colored = true,
  symbols = { added = "  ", modified = " ", removed = " " },
  diff_color = {
    added = { fg = "#98be65" },
    modified = { fg = "#ecbe7b" },
    removed = { fg = "#ec5f67" },
  },
  cond = hide_in_width
}

local mode = {
  "mode",
  fmt = function(str)
    return "-- " .. str .. " --"
  end,
  cond = hide_in_dap_panel,
}


local file_name = {
  'filename',
  file_status = true, -- Displays file status (readonly status, modified status)
  path = 1, -- 0: Just the filename
  -- 1: Relative path
  -- 2: Absolute path

  shorting_target = 40, -- Shortens path to leave 40 spaces in the window
  -- for other components. (terrible name, any suggestions?)
  symbols = {
    modified = '[+]', -- Text to show when the file is modified.
    readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
    unnamed = '[No Name]', -- Text to show for unnamed buffers.
  },
}

local encoding = {
  "encoding",
  cond = hide_in_dap_panel,
}

local filetype = {
  "filetype",
  icons_enabled = false,
  icon = nil,
  cond = hide_in_dap_panel,
}

local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
  cond = hide_in_dap_panel,
}

local location = {
  "location",
  padding = 1,
}

local fileformat = {
  "fileformat",
  cond = hide_in_dap_panel,
}

-- cool function for progress
local progress = function()
  local current_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")
  -- local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
  local chars = { "██", "▇▇", "▆▆", "▅▅", "▄▄", "▃▃", "▂▂", "▁▁", "  ", }
  local line_ratio = current_line / total_lines
  local index = math.ceil(line_ratio * #chars)

  if not is_dap_panel() then
    return chars[index]
  else
    return ''
  end
end

local spaces = function()
  if not is_dap_panel() then
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  else
    return ''
  end
end

-- add gps module to get the position information
-- local gps = require("nvim-gps")

lualine.setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    -- component_separators = { left = "", right = "" },
    -- section_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { branch, diagnostics },
    lualine_b = { mode },
    lualine_c = { file_name },
    lualine_x = { diff, spaces, encoding, filetype, fileformat },
    lualine_y = { location },
    lualine_z = { progress },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { file_name },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
})
