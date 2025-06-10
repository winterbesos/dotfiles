local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local Terminal = require("toggleterm.terminal").Terminal

local M = {}

M.run_shell_scripts = function()
  local cwd = vim.fn.getcwd()
  local script_dir = cwd .. "/scripts"

  local output = vim.fn.glob(script_dir .. "/*.sh", false, true) -- 获取脚本路径数组

  if vim.tbl_isempty(output) then
    print("No scripts found in " .. script_dir)
    return
  end

  pickers.new({}, {
    prompt_title = "Run Shell Script",
    finder = finders.new_table {
      results = output,
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      actions.select_default:replace(function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if selection then
          local script = selection[1]
          local term = require("toggleterm.terminal").Terminal:new({
            cmd = "bash " .. vim.fn.fnameescape(script),
            direction = "float",
            close_on_exit = true,
            hidden = true,
          })
          term:toggle()
        end
      end)
      return true
    end,
  }):find()
end

return M
