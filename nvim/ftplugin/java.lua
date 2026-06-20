-- ~/.config/nvim/ftplugin/java.lua

local ok, jdtls = pcall(require, "jdtls")
if not ok then
  vim.notify("nvim-jdtls not found", vim.log.levels.ERROR)
  return
end

local mason_path = vim.fn.stdpath("data") .. "/mason"
local mason_jdtls = mason_path .. "/bin/jdtls"
local jdtls_cmd = vim.fn.exepath("jdtls")

if jdtls_cmd == "" and vim.fn.executable(mason_jdtls) == 1 then
  jdtls_cmd = mason_jdtls
end

if jdtls_cmd == "" then
  vim.notify("jdtls executable not found. Run :MasonInstall jdtls", vim.log.levels.ERROR)
  return
end

-- 多模块项目优先用 .git 作为 root，避免 root 卡在子模块目录。
local root_dir = require("jdtls.setup").find_root({ ".git" })

if root_dir == nil then
  root_dir = require("jdtls.setup").find_root({
    "mvnw",
    "gradlew",
    "settings.gradle",
    "settings.gradle.kts",
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
  })
end

if root_dir == nil then
  vim.notify("jdtls root_dir not found", vim.log.levels.ERROR)
  return
end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

local cmd = {
  jdtls_cmd,
}

local lombok_jar = mason_path .. "/share/jdtls/lombok.jar"
if vim.fn.filereadable(lombok_jar) == 1 then
  table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok_jar)
  table.insert(cmd, "--jvm-arg=-Xbootclasspath/a:" .. lombok_jar)
else
  vim.notify("lombok.jar not found: " .. lombok_jar, vim.log.levels.WARN)
end

table.insert(cmd, "-data")
table.insert(cmd, workspace_dir)

local bundles = {}

local java_debug_path = mason_path .. "/packages/java-debug-adapter/extension/server/"
local java_debug_bundle = vim.fn.glob(java_debug_path .. "com.microsoft.java.debug.plugin-*.jar", true)

if java_debug_bundle ~= "" then
  table.insert(bundles, java_debug_bundle)
end

local java_test_path = mason_path .. "/packages/java-test/extension/server/"
local java_test_bundles = vim.split(vim.fn.glob(java_test_path .. "*.jar", true), "\n", { trimempty = true })

for _, bundle in ipairs(java_test_bundles) do
  table.insert(bundles, bundle)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_ok then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

local signature_setup = {
  bind = true,
  hint_enable = true,
  floating_window = true,
  handler_opts = {
    border = "single",
  },
  hint_prefix = "🧠 ",
  hi_parameter = "IncSearch",
}

local function on_attach(_, bufnr)
  local sig_ok, signature = pcall(require, "lsp_signature")
  if sig_ok then
    signature.on_attach(signature_setup, bufnr)
  end

  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
      buffer = bufnr,
      silent = true,
      desc = desc,
    })
  end

  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  map("n", "gr", vim.lsp.buf.references, "References")
  map("n", "gy", vim.lsp.buf.type_definition, "Type definition")

  map("n", "K", function()
    vim.lsp.buf.hover({ border = "rounded" })
  end, "Hover")

  map("n", "<C-k>", function()
    vim.lsp.buf.signature_help({ border = "rounded" })
  end, "Signature help")

  map("n", "<leader>jo", function()
    jdtls.organize_imports()
  end, "Java organize imports")

  map("n", "<leader>jv", function()
    jdtls.extract_variable()
  end, "Java extract variable")

  map("v", "<leader>jm", function()
    jdtls.extract_method(true)
  end, "Java extract method")

  map("n", "<leader>jt", function()
    jdtls.test_nearest_method()
  end, "Java test nearest method")

  map("n", "<leader>jT", function()
    jdtls.test_class()
  end, "Java test class")
end

local config = {
  cmd = cmd,
  root_dir = root_dir,
  capabilities = capabilities,
  on_attach = on_attach,

  settings = {
    java = {
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          -- {
          --   name = "JavaSE-17",
          --   path = "/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home",
          --   default = true,
          -- },
        },
      },
      import = {
        maven = {
          enabled = true,
        },
        gradle = {
          enabled = true,
        },
      },
      completion = {
        favoriteStaticMembers = {
          "org.junit.jupiter.api.Assertions.*",
          "org.mockito.Mockito.*",
          "org.mockito.ArgumentMatchers.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      format = {
        enabled = true,
        insertSpaces = true,
        tabSize = 2,
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      signatureHelp = {
        enabled = true,
      },
    },
  },

  init_options = {
    bundles = bundles,
  },
}

jdtls.start_or_attach(config)
