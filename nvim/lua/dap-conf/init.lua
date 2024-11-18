-- local status_ok, dap = pcall(require, "dap")
-- if not status_ok then
-- 	return
-- end

local dap = require('dap')

dap.adapters["local-lua"] = {
  type = "executable",
  command = "node",
  args = { "/Users/salo/vendor/local-lua-debugger-vscode/extension/debugAdapter.js"
  },
  enrich_config = function(config, on_config)
    if not config["extensionPath"] then
      local c = vim.deepcopy(config)
      -- 💀 If this is missing or wrong you'll see 
      -- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
      c.extensionPath = "/Users/salo/vendor/local-lua-debugger-vscode/"
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
    args = {"--model-name", "srimanth-d/GOT_CPU", "--image-file", "/Users/salo/Downloads/image.jpg", "--type", "ocr", "--device", "cpu"};
    justMyCode = false;
  },
}


require("dapui").setup()
