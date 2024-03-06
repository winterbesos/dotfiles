local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then
	return
end

-- require("lsp.lsp-installer")
require("lsp.mason")
mason_lspconfig.setup()
require("lsp.handlers").setup()
