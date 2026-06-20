return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = false,
  dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
  },
  config = function()
    require("flutter-tools").setup {
      debugger = {
        enabled = true,
        run_via_dap = true,
      },
      dev_log = {
        enabled = false,
      },
      fvm = true,
      -- flutter_path = vim.fn.expand("~") .. "/fvm/default/bin/flutter",
    }

    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      -- dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      -- dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      -- dapui.close()
    end
  end
}
