local actions = require("diffview.actions")

require("diffview").setup({
  diff_binaries = false,
  enhanced_diff_hl = true,
  use_icons = true,
  show_help_hints = true,
  watch_index = true,
  icons = {
    folder_closed = "",
    folder_open = "",
  },
  signs = {
    fold_closed = "",
    fold_open = "",
    done = "✓",
  },
  view = {
    default = {
      layout = "diff2_horizontal",
      disable_diagnostics = false,
      winbar_info = false,
    },
    merge_tool = {
      layout = "diff3_horizontal",
      disable_diagnostics = true,
      winbar_info = true,
    },
    file_history = {
      layout = "diff2_horizontal",
      disable_diagnostics = false,
      winbar_info = false,
    },
  },
  file_panel = {
    listing_style = "tree",
    tree_options = {
      flatten_dirs = true,
      folder_statuses = "only_folded",
    },
    win_config = {
      position = "left",
      width = 35,
    },
  },
  file_history_panel = {
    log_options = {
      git = {
        single_file = {
          max_count = 256,
          follow = false,
        },
        multi_file = {
          max_count = 256,
        },
      },
    },
    win_config = {
      position = "bottom",
      height = 16,
    },
  },
  default_args = {
    DiffviewOpen = {},
    DiffviewFileHistory = {},
  },
  keymaps = {
    disable_defaults = false,
    file_panel = {
      { "n", "<Space>", actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry" } },
      { "n", "r", actions.restore_entry, { desc = "Restore entry to the state on the left side" } },
    },
  },
})
