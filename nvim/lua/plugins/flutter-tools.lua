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
      fvm = true,
      flutter_lookup_cmd = function()
      -- 假设你用的是 fvm 安装的 flutter
      -- fvm 会自动创建 .fvm/flutter_sdk/bin/flutter
      local flutter_sdk_path = vim.fn.expand("~") .. "/fvm/flutter_sdk/bin/flutter"
      if vim.fn.executable(flutter_sdk_path) == 1 then
        return flutter_sdk_path
      end
      return nil
    end,
    }

    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end
}
