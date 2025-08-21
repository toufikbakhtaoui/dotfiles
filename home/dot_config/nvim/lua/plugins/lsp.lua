return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp", -- For autocompletion capabilities
	},
	config = function()
		-- Setup Mason
		require("mason").setup()

		-- Setup Mason-LSPConfig
		require("mason-lspconfig").setup({
			ensure_installed = {
				"jdtls", -- Java
				"html", -- HTML
				"cssls", -- CSS
				"vue_ls", -- Vue.js
				"yamlls", -- YAML
				"jsonls", -- JSON
				"dockerls", -- Docker
				"marksman", -- Markdown
			},
			handlers = {
				function(server_name)
					local lspconfig = require("lspconfig")
					local capabilities = require("cmp_nvim_lsp").default_capabilities()

					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,
			},
		})
	end,
}
