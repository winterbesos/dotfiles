local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local setup = {
  plugins = {
    marks = false, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = false, -- adds help for motions
      text_objects = false, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = false, -- bindings for folds, spelling and others prefixed with z
      g = false, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  keys = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  win = {
    border = "rounded", -- none, single, double, shadow
    -- position = "bottom", -- bottom, top
    -- margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    -- winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  filter = function(mapping)
    return true
  end,
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = { "<Space>", mode = "n" }, -- automatically setup triggers
}

local mappings = {
  { "<Space>C", "<cmd>%bd|e#<CR>", desc = "Close Other Buffers", nowait = true, remap = false },
  { "<Space>F", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args(require('telescope.themes').get_ivy())<cr>", desc = "Find Text", nowait = true, remap = false },
  { "<Space>P", "<cmd>SessionManager load_session<cr>", desc = "Projects", nowait = true, remap = false },
  { "<Space>R", group = "Replace", nowait = true, remap = false },
  { "<Space>Rf", "<cmd>lua require('spectre').open_file_search()<CR>", desc = "Replace File", nowait = true, remap = false },
  { "<Space>Rp", "<cmd>lua require('spectre').open()<CR>", desc = "Replace Project", nowait = true, remap = false },
  { "<Space>Rs", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", desc = "Search", nowait = true, remap = false },
  { "<Space>S", "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>", desc = "Find Symobls", nowait = true, remap = false },
  { "<Space>T", group = "Trouble", nowait = true, remap = false },
  { "<Space>Td", "<cmd>Trouble document_diagnostics<cr>", desc = "Document Diagnostics", nowait = true, remap = false },
  { "<Space>Tg", "<cmd>Gitsigns setloclist<cr>", desc = "Open changed hunk", nowait = true, remap = false },
  { "<Space>Tq", "<cmd>Trouble quickfix<cr>", desc = "Quick Fix", nowait = true, remap = false },
  { "<Space>Tt", "<cmd>Trouble<cr>", desc = "ToggleTrouble", nowait = true, remap = false },
  { "<Space>Tu", "<cmd>Trouble lsp_references<cr>", desc = "Usage", nowait = true, remap = false },
  { "<Space>Tw", "<cmd>Trouble workspace_diagnostics<cr>", desc = "Workspace Diagnostics", nowait = true, remap = false },
  { "<Space>a", "<cmd>Alpha<cr>", desc = "Welcome", nowait = true, remap = false },
  { "<Space>c", group = "CMake", nowait = true, remap = false },
  { "<Space>cT", "<cmd>CMake select_build_type<CR>", desc = "SelectBuildType", nowait = true, remap = false },
  { "<Space>ca", "<cmd>CMake build_all<CR>", desc = "BuildAll", nowait = true, remap = false },
  { "<Space>cb", "<cmd>CMake build<CR>", desc = "BuildTarget", nowait = true, remap = false },
  { "<Space>cc", "<cmd>CMake cancel<CR>", desc = "Cancel", nowait = true, remap = false },
  { "<Space>cd", "<cmd>CMake build_and_debug<CR>", desc = "DebugTarget", nowait = true, remap = false },
  { "<Space>cg", "<cmd>CMake configure<CR>", desc = "Configure", nowait = true, remap = false },
  { "<Space>cr", "<cmd>CMake build_and_run<CR>", desc = "Run", nowait = true, remap = false },
  { "<Space>cs", "<cmd>CMake set_target_args<CR>", desc = "SetArg", nowait = true, remap = false },
  { "<Space>ct", "<cmd>CMake select_target<CR>", desc = "SelectTarget", nowait = true, remap = false },
  { "<Space>d", group = "Debug", nowait = true, remap = false },
  { "<Space>dC", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", desc = "Conditional Breakpoint", nowait = true, remap = false },
  { "<Space>dE", "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>", desc = "Evaluate Input", nowait = true, remap = false },
  { "<Space>dR", "<cmd>lua require'dap'.run_to_cursor()<cr>", desc = "Run to Cursor", nowait = true, remap = false },
  { "<Space>dS", "<cmd>lua require'dap.ui.widgets'.scopes()<cr>", desc = "Scopes", nowait = true, remap = false },
  { "<Space>dT", "<cmd>lua require'dapui'.toggle('sidebar')<cr>", desc = "Toggle Sidebar", nowait = true, remap = false },
  { "<Space>dX", "<cmd>lua require'dap'.terminate()<cr>", desc = "Terminate", nowait = true, remap = false },
  { "<Space>db", "<cmd>lua require'dap'.step_back()<cr>", desc = "Step Back", nowait = true, remap = false },
  { "<Space>dc", "<cmd>lua require'dap'.continue()<cr>", desc = "Continue", nowait = true, remap = false },
  { "<Space>dd", "<cmd>lua require'dap'.disconnect()<cr>", desc = "Disconnect", nowait = true, remap = false },
  { "<Space>de", "<cmd>lua require'dapui'.eval()<cr>", desc = "Evaluate", nowait = true, remap = false },
  { "<Space>dg", "<cmd>lua require'dap'.session()<cr>", desc = "Get Session", nowait = true, remap = false },
  { "<Space>dh", "<cmd>lua require'dap.ui.widgets'.hover()<cr>", desc = "Hover Variables", nowait = true, remap = false },
  { "<Space>di", "<cmd>lua require'dap'.step_into()<cr>", desc = "Step Into", nowait = true, remap = false },
  { "<Space>do", "<cmd>lua require'dap'.step_over()<cr>", desc = "Step Over", nowait = true, remap = false },
  { "<Space>dp", "<cmd>lua require'dap'.pause()<cr>", desc = "Pause", nowait = true, remap = false },
  { "<Space>dq", "<cmd>lua require'dap'.close()<cr>", desc = "Quit", nowait = true, remap = false },
  { "<Space>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", desc = "Toggle Repl", nowait = true, remap = false },
  { "<Space>dt", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "Toggle Breakpoint", nowait = true, remap = false },
  { "<Space>du", "<cmd>lua require'dap'.step_out()<cr>", desc = "Step Out", nowait = true, remap = false },
  { "<Space>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer", nowait = true, remap = false },
  { "<Space>f", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "Find files", nowait = true, remap = false },
  { "<Space>g", group = "Git", nowait = true, remap = false },
  { "<Space>gN", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", desc = "Prev Hunk", nowait = true, remap = false },
  { "<Space>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer", nowait = true, remap = false },
  { "<Space>gS", "<cmd>lua require 'gitsigns'.stage_buffer()<cr>", desc = "Stage Hunk", nowait = true, remap = false },
  { "<Space>gU", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk", nowait = true, remap = false },
  { "<Space>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch", nowait = true, remap = false },
  { "<Space>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit", nowait = true, remap = false },
  { "<Space>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff", nowait = true, remap = false },
  { "<Space>gf", "<cmd>DiffviewFileHistory<CR>", desc = "File History", nowait = true, remap = false },
  { "<Space>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame", nowait = true, remap = false },
  { "<Space>gn", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", desc = "Next Hunk", nowait = true, remap = false },
  { "<Space>go", "<cmd>Telescope git_status<cr>", desc = "Open changed file", nowait = true, remap = false },
  { "<Space>gp", "<cmd>DiffviewOpen<CR>", desc = "Diff Project", nowait = true, remap = false },
  { "<Space>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk", nowait = true, remap = false },
  { "<Space>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", desc = "Stage Hunk", nowait = true, remap = false },
  { "<Space>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk", nowait = true, remap = false },
  { "<Space>h", group = "Help", nowait = true, remap = false },
  { "<Space>hC", "<cmd>Telescope commands<cr>", desc = "Commands", nowait = true, remap = false },
  { "<Space>hM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages", nowait = true, remap = false },
  { "<Space>hR", "<cmd>Telescope registers<cr>", desc = "Registers", nowait = true, remap = false },
  { "<Space>hc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme", nowait = true, remap = false },
  { "<Space>hh", "<cmd>Telescope help_tags<cr>", desc = "Find Help", nowait = true, remap = false },
  { "<Space>hk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps", nowait = true, remap = false },
  { "<Space>l", group = "LSP", nowait = true, remap = false },
  { "<Space>lI", "<cmd>LspInstallInfo<cr>", desc = "Installer Info", nowait = true, remap = false },
  { "<Space>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols", nowait = true, remap = false },
  { "<Space>lc", "<cmd>Copilot panel<cr>", desc = "Copilot Panel", nowait = true, remap = false },
  { "<Space>ld", "<cmd>Telescope lsp_document_diagnostics<cr>", desc = "Document Diagnostics", nowait = true, remap = false },
  { "<Space>lf", "<cmd>Format<cr>", desc = "Format", nowait = true, remap = false },
  { "<Space>li", "<cmd>LspInfo<cr>", desc = "Info", nowait = true, remap = false },
  { "<Space>lj", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "Next Diagnostic", nowait = true, remap = false },
  { "<Space>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic", nowait = true, remap = false },
  { "<Space>ll", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action", nowait = true, remap = false },
  { "<Space>lq", "<cmd>lua vim.diagnostic.setqflist()<cr>", desc = "Quickfix", nowait = true, remap = false },
  { "<Space>lr", "<cmd>lua vim.buf.rename()<cr>", desc = "Rename", nowait = true, remap = false },
  { "<Space>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols", nowait = true, remap = false },
  { "<Space>lw", "<cmd>Telescope lsp_workspace_diagnostics<cr>", desc = "Workspace Diagnostics", nowait = true, remap = false },
  { "<Space>o", "<cmd>SymbolsOutline<CR>", desc = "Outline", nowait = true, remap = false },
  { "<Space>p", "<cmd>Telescope projects<cr>", desc = "Projects", nowait = true, remap = false },
  { "<Space>r", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File", nowait = true, remap = false },
  { "<Space>s", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", desc = "Find Document Symbols", nowait = true, remap = false },
  { "<Space>t", group = "Test", nowait = true, remap = false },
  { "<Space>tf", "<cmd>TestFile<cr>", desc = "Test File", nowait = true, remap = false },
  { "<Space>tl", "<cmd>TestLast<cr>", desc = "Test Last", nowait = true, remap = false },
  { "<Space>tn", "<cmd>TestNearest<cr>", desc = "Test Nearest", nowait = true, remap = false },
  { "<Space>ts", "<cmd>TestSuite<cr>", desc = "Test Suite", nowait = true, remap = false },
  { "<Space>tv", "<cmd>TestVisit<cr>", desc = "Test Visit", nowait = true, remap = false },
  { "<Space>v", "<cmd>lua require('telescope').extensions.neoclip.default(require('telescope.themes').get_ivy())<cr>", desc = "Clipboard Manager", nowait = true, remap = false },
}
which_key.setup(setup)
which_key.add(mappings)

