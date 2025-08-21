return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "java", "lua", "json", "yaml", "html", "css", "vue", "dockerfile", "markdown" },
			highlight = { enable = true },
			autotag = { enable = true },
		})
	end,
}
