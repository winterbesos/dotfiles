-- ~/.config/nvim/ftplugin/java.lua

local ok, jdtls = pcall(require, "jdtls")
if not ok then
  vim.notify("nvim-jdtls not found", vim.log.levels.ERROR)
  return
end

local mason_jdtls = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
local jdtls_cmd = vim.fn.exepath("jdtls")

if jdtls_cmd == "" and vim.fn.executable(mason_jdtls) == 1 then
  jdtls_cmd = mason_jdtls
end

if jdtls_cmd == "" then
  vim.notify("jdtls executable not found. Run :MasonInstall jdtls", vim.log.levels.ERROR)
  return
end

-- 多模块项目优先用 .git 作为 root，避免 root 卡在 blue-net-order-interface / service 子模块
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

-- Lombok: 解决 @Slf4j 下 log cannot be resolved
local lombok_jar = vim.fn.stdpath("data") .. "/mason/share/jdtls/lombok.jar"

local cmd = {
  jdtls_cmd,
}

if vim.fn.filereadable(lombok_jar) == 1 then
  table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok_jar)
  table.insert(cmd, "--jvm-arg=-Xbootclasspath/a:" .. lombok_jar)
else
  vim.notify("lombok.jar not found: " .. lombok_jar, vim.log.levels.WARN)
end

table.insert(cmd, "-data")
table.insert(cmd, workspace_dir)

local config = {
  cmd = cmd,

  root_dir = root_dir,

  settings = {
    java = {
      configuration = {
        updateBuildConfiguration = "interactive",
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
    bundles = {},
  },
}

jdtls.start_or_attach(config)
