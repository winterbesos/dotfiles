local status_ok, mason = pcall(require, "mason")
if not status_ok then
  vim.notify("mason not found!")
  return
end

mason.setup({
  -- The directory in which to install packages.
  -- install_root_dir = path.concat { vim.fn.stdpath "data", "mason" },

  -- Where Mason should put its bin location in your PATH. Can be one of:
  -- - "prepend" (default, Mason's bin location is put first in PATH)
  -- - "append" (Mason's bin location is put at the end of PATH)
  -- - "skip" (doesn't modify PATH)
  ---@type '"prepend"' | '"append"' | '"skip"'
  PATH = "prepend",

  pip = {
    -- Whether to upgrade pip to the latest version in the virtual environment before installing packages.
    upgrade_pip = false,

    -- These args will be added to `pip install` calls. Note that setting extra args might impact intended behavior
    -- and is not recommended.
    --
    -- Example: { "--proxy", "https://proxyserver" }
    install_args = {},
  },

  -- Controls to which degree logs are written to the log file. It's useful to set this to vim.log.levels.DEBUG when
  -- debugging issues with package installations.
  log_level = vim.log.levels.DEBUG,

  -- Limit for the maximum amount of packages to be installed at the same time. Once this limit is reached, any further
  -- packages that are requested to be installed will be put in a queue.
  max_concurrent_installers = 4,

  github = {
    -- The template URL to use when downloading assets from GitHub.
    -- The placeholders are the following (in order):
    -- 1. The repository (e.g. "rust-lang/rust-analyzer")
    -- 2. The release version (e.g. "v0.3.0")
    -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
    download_url_template = "https://github.com/%s/releases/download/%s/%s",
  },

  -- The provider implementations to use for resolving package metadata (latest version, available versions, etc.).
  -- Accepts multiple entries, where later entries will be used as fallback should prior providers fail.
  -- Builtin providers are:
  --   - mason.providers.registry-api (default) - uses the https://api.mason-registry.dev API
  --   - mason.providers.client                 - uses only client-side tooling to resolve metadata
  providers = {
    "mason.providers.registry-api",
  },

  ui = {
    -- Whether to automatically check for new versions when opening the :Mason window.
    check_outdated_packages_on_open = true,

    -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
    border = "none",

    icons = {
      -- The list icon to use for installed packages.
      package_installed = "◍",
      -- The list icon to use for packages that are installing, or queued for installation.
      package_pending = "◍",
      -- The list icon to use for packages that are not installed.
      package_uninstalled = "◍",
    },

    keymaps = {
      -- Keymap to expand a package
      toggle_package_expand = "<CR>",
      -- Keymap to install the package under the current cursor position
      install_package = "i",
      -- Keymap to reinstall/update the package under the current cursor position
      update_package = "u",
      -- Keymap to check for new version for the package under the current cursor position
      check_package_version = "c",
      -- Keymap to update all installed packages
      update_all_packages = "U",
      -- Keymap to check which installed packages are outdated
      check_outdated_packages = "C",
      -- Keymap to uninstall a package
      uninstall_package = "X",
      -- Keymap to cancel a package installation
      cancel_installation = "<C-c>",
      -- Keymap to apply language filter
      apply_language_filter = "<C-f>",
    },
  },
})

local util = require("lspconfig.util")
local signature = require("lsp_signature")

local signature_setup = {
  bind = true,
  hint_enable = true,
  floating_window = true,
  handler_opts = {
    border = "single"
  },
  hint_prefix = "🧠 ",
  hi_parameter = "IncSearch"
}

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()


vim.lsp.enable('basedpyright')

vim.lsp.config('gopls', {
  cmd = { "gopls" },
  filetypes = { "go", "gomod" },
  root_markers = { ".gomod" },
  -- root_dir = util.root_pattern("go.mod", ".git"),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    }
  },
  on_attach = function(client, bufnr)
    require "lsp_signature".on_attach(signature_setup, bufnr)
  end,
})
vim.lsp.enable('gopls')


vim.lsp.config('eslint', {
  root_markers = { ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", "eslint.config.js" },
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
		  vim.api.nvim_set_option_value('formatexpr', 'v:lua.vim.lsp.formatexpr()', { buf = bufnr })
    end

    -- 配置快捷键进行格式化
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>",
      { noremap = true, silent = true })
  end,
})
vim.lsp.enable('eslint')

vim.lsp.config('emmet_ls', {
  filetypes = { "html", "css", "javascriptreact", "typescriptreact", "vue" }
})
vim.lsp.enable('emmet_ls')

vim.lsp.config('volar', {
  filetypes = { 'typescript', 'javascript', 'vue' },
  root_markers = { "package.json", "tsconfig.json", ".git" },
  on_attach = function(client, bufnr)
    if client.name == "volar" then
      client.server_capabilities.documentFormattingProvider = false
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.cmd("FormatSync")
      end,
    })
  end,
  init_options = {
    typescript = {
      tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib"
    },
    vue = {
      hybridMode = false,
    },
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vim.fn.getcwd() .. "/node_modules/@vue/language-server",
        languages = { "vue" },
      },
    },
  },
})
vim.lsp.enable('volar')


-- vim.lsp.config('dartls', {
--   cmd = {"fvm", "dart", "language-server", "--protocol=lsp" },
--   filetypes = { "dart" },
--   init_options = {
--     closingLabels = true,
--     outline = true,
--     flutterOutline = true,
--   },
--   on_attach = function(client, bufnr)
--     vim.api.nvim_create_autocmd("BufWritePre", {
--       buffer = bufnr,
--       callback = function()
--         vim.lsp.buf.format { async = false }
--       end,
--     })
-- 
--     -- 自定义按键绑定等
--     local buf_map = function(mode, lhs, rhs)
--       vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap=true, silent=true })
--     end
-- 
--     buf_map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
--     buf_map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
--   end
-- })
-- vim.lsp.enable('dartls')

-- config.solargraph.setup {
--   filetypes = { "ruby" },
--   init_options = {
--     formatting = true
--   },
--   cmd = { "bundle", "exec", "solargraph", "stdio" },
--   root_dir = util.root_pattern("Gemfile", ".git"),
--   settings = {
--     solargraph = {
--       diagnostics = true
--     },
--   },
--   on_attach = function(client, bufnr)
--     signature.on_attach(signature_setup, bufnr)
--   end,
-- }
-- 
-- 
-- config.clangd.setup {
--   cmd = { "clangd", "--compile-commands-dir=build", "--background-index", "--clang-tidy", "--completion-style=detailed", "--header-insertion=iwyu", "--suggest-missing-includes", "--pch-storage=memory", "--cross-file-rename", "--clang-tidy", "--header-insertion=iwyu", "--suggest-missing-includes", "--pch-storage=memory", "--cross-file-rename" },
--   filetypes = { "c", "cpp", "objc", "objcpp" },
--   root_dir = util.root_pattern(".clangd", "compile_flags.txt", ".git"),
--   init_options = {
--     clangdFileStatus = true,
--     usePlaceholders = true,
--     completeUnimported = true,
--     semanticHighlighting = true,
--   },
--   settings = {
--     ccls = {
--       completion = {
--         filterAndSort = false,
--       },
--     },
--   },
-- }
-- 
-- config.lua_ls.setup {
--   settings = {
--     Lua = {
--       runtime = {
--         version = "LuaJIT", -- Neovim 使用的 Lua 版本
--         path = vim.split(package.path, ";"),
--       },
--       diagnostics = {
--         globals = { "vim" }, -- 告诉 LSP "vim" 是全局变量，不要报错
--       },
--       workspace = {
--         library = vim.api.nvim_get_runtime_file("", true), -- 包括 neovim 的运行时文件
--         checkThirdParty = false,                           -- 避免提示你配置 luarocks 等
--       },
--       telemetry = { enable = false },
--     },
--   }
-- }
-- 
-- 
-- 
-- config.sourcekit.setup({
--   cmd = { "xcrun", "sourcekit-lsp" },
--   filetypes = { "swift", "c", "cpp", "objective-c", "objective-cpp" },
--   root_dir = util.root_pattern("*.xcodeproj", "Package.swift", ".git"),
-- })
