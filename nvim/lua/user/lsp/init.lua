local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

--  vim.lsp.set_log_level("debug")
require("user.lsp.lsp-installer")
require("user.lsp.handlers").setup()
-- require("user.lsp.null-ls")
-- require("user.lsp.lsp-utils")
