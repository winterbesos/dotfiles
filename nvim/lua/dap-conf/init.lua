-- local status_ok, dap = pcall(require, "dap")
-- if not status_ok then
-- 	return
-- end

local dap = require('dap')
dap.set_log_level('TRACE')
local home = vim.fn.expand("$HOME")
local local_lua_debugger_path = home .. "/vendor/local-lua-debugger-vscode"

require("nvim-dap-virtual-text").setup {
    enabled = true,                        -- enable this plugin (the default)
    enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true,               -- show stop reason when stopped for exceptions
    commented = false,                     -- prefix virtual text with comment string
    only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
    all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
    clear_on_continue = false,             -- clear virtual text on "continue" (might cause flickering when stepping)
    --- A callback that determines how a variable is displayed or whether it should be omitted
    --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
    --- @param buf number
    --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
    --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
    --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
    --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
    display_callback = function(variable, buf, stackframe, node, options)
    -- by default, strip out new line characters
      if options.virt_text_pos == 'inline' then
        return ' = ' .. variable.value:gsub("%s+", " ")
      else
        return variable.name .. ' = ' .. variable.value:gsub("%s+", " ")
      end
    end,
    -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
    virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

    -- experimental features:
    all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
                                           -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
}


dap.adapters["local-lua"] = {
  type = "executable",
  command = "node",
  args = { local_lua_debugger_path .. "/extension/debugAdapter.js"
  },
  enrich_config = function(config, on_config)
    if not config["extensionPath"] then
      local c = vim.deepcopy(config)
      -- 💀 If this is missing or wrong you'll see 
      -- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
      c.extensionPath = local_lua_debugger_path .. "/"
      on_config(c)
    else
      on_config(config)
    end
  end,
}

dap.configurations.lua = {
  {
    name = 'Current file (local-lua-dbg, lua)',
    type = 'local-lua',
    request = 'launch',
    cwd = '${workspaceFolder}',
    program = {
      lua = 'lua',
      file = '${file}',
    },
    args = {},
  },
}

dap.configurations.cpp = {
   {
      name = "Launch",
      type = "lldb",
      request = "launch",
      program = function()
         return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      externalTerminal = false,
      stopOnEntry = false,
      args = {}
   },
}


dap.adapters.lldb = {
  type = "executable",
  command = "/opt/homebrew/opt/llvm/bin/lldb-dap",
  name = "lldb"
}

dap.configurations.c = { -- 这里的配置也适用于C++
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    -- 如果需要，可以在这里设置环境变量
    -- environment = {
    --   {
    --     name = "VARNAME",
    --     value = "value"
    --   }
    -- },
    runInTerminal = false,
  },
}

dap.adapters.python = {
  type = 'executable',
  command = 'python',
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = "Launch FastAPI",
    program = function()
      return vim.fn.getcwd() .. '/main.py'
    end,
    pythonPath = function()
      return 'python'
    end,
    args = {}
  },
  {
    -- The first three options are required by nvim-dap
    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file";

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = "${file}"; -- This configuration will launch the current file if used.
    pythonPath = function()
      return 'python'
    end;
    justMyCode = true;
  },
  {
    -- The first three options are required by nvim-dap
    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file With External Code";

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = "${file}"; -- This configuration will launch the current file if used.
    pythonPath = function()
      return 'python'
    end;
    justMyCode = false;
  },
  {
    type = 'python';
    request = 'launch';
    name = "Launch file with GOT params";
    program = "${file}";
    args = {"--model-name", "srimanth-d/GOT_CPU", "--image-file", home .. "/Downloads/image.jpg", "--type", "ocr", "--device", "cpu"};
    justMyCode = false;
  },
}

require("dap-vscode-js").setup({
  node_path = 'node', -- Node.js 的路径
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }
})

dap.configurations.javascript = {
  {
    type = 'pwa-node', -- 调试适配器类型
    request = 'launch', -- 启动调试
    name = 'Launch file', -- 配置名称
    program = '${file}', -- 当前文件
    cwd = '${workspaceFolder}', -- 工作目录
    sourceMaps = true, -- 启用 Source Maps
    protocol = 'inspector', -- 使用 Chrome Inspector 协议
    console = 'integratedTerminal', -- 集成终端输出
  },
  {
    type = 'pwa-node',
    request = 'attach', -- 附加到正在运行的进程
    name = 'Attach to process',
    processId = require('dap.utils').pick_process, -- 提供交互式选择
    cwd = '${workspaceFolder}',
  },
  {
    type = 'pwa-chrome', -- 调试浏览器中的 JavaScript
    request = 'launch',
    name = 'Launch Chrome',
    url = 'http://localhost:3000', -- 目标地址
    webRoot = '${workspaceFolder}', -- 网站根目录
  },
}

-- 用 FVM 启动 flutter 的 debug_adapter
dap.adapters.dart = {
  type = "executable",
  command = "fvm",
  args = { "flutter", "debug_adapter" },
}


-- 常用调试配置
dap.configurations.dart = {
  {
    type = "dart",
    request = "launch",
    name = "FVM Flutter: Launch (debug)",
    cwd = "${workspaceFolder}",
    program = "${workspaceFolder}/lib/main.dart",

    -- 设备选择：先写死，后面我给你一个自动选设备的方法
    toolArgs = { "-d", "chrome" }, -- 或 emulator-5554 / iPhone / macos 等

    args = {}, -- 传给 main() 的参数
  },
  {
    type = "dart",
    request = "launch",
    name = "FVM Flutter: Launch In ASUS (debug)",
    cwd = "${workspaceFolder}",
    program = "${workspaceFolder}/lib/main.dart",

    -- 设备选择：先写死，后面我给你一个自动选设备的方法
    toolArgs = { "-d", "ASUS I003DD" }, -- 或 emulator-5554 / iPhone / macos 等
    skipFiles = {
      "**/flutter/**",
      "**/dart-sdk/**",
      "**/.pub-cache/**",
      "**/packages/**",
    },


    args = {}, -- 传给 main() 的参数
  },
  {
    type = "dart",
    request = "attach",
    name = "FVM Flutter: Attach",
    cwd = "${workspaceFolder}",
  },
  {
    type = "dart",
    request = "launch",
    name = "Flutter: Launch (debug)",
    dartSdkPath = nil,          -- 一般不需要填，PATH 能找到即可
    flutterSdkPath = nil,       -- 同上
    program = "${workspaceFolder}/lib/main.dart",
    cwd = "${workspaceFolder}",
    toolArgs = { "-d", "chrome" }, -- 改成你要跑的设备：chrome / emulator-5554 / iPhone 等
    args = {},                  -- 传给 main() 的参数
  },
  {
    type = "dart",
    request = "launch",
    name = "Flutter: Launch (profile)",
    program = "${workspaceFolder}/lib/main.dart",
    cwd = "${workspaceFolder}",
    flutterMode = "profile",
    toolArgs = { "-d", "chrome" },
  },
  {
    type = "dart",
    request = "launch",
    name = "Flutter: Launch (flavor)",
    program = "${workspaceFolder}/lib/main.dart",
    cwd = "${workspaceFolder}",
    toolArgs = {
      "--flavor", "dev",
      "-t", "lib/main_dev.dart",
      "-d", "chrome",
    },
  },
  {
    type = "dart",
    request = "attach",
    name = "Flutter: Attach",
    cwd = "${workspaceFolder}",
  },
}

require('dap-go').setup({
  dap_configurations = {
    {
      type = "go",
      name = "Debug (Build Workspace main.go)",
      request = "launch",
      program = "main.go",
      outputMode = "remote",
    },
  },
  delve = {
    path = "dlv",
    initialize_timeout_sec = 20,
    -- cwd = 'src',
  }
})

require("dapui").setup()
