local lsp = require('lsp-zero')

lsp.setup()

require('mason').setup({
})

require('mason-lspconfig').setup({
	ensure_installed = {
		'bashls',
		'clangd',
		'cmake',
		'dockerls',
		'elmls',
		'fortls',
		'groovyls',
		'html',
		'jsonls',
		'lua_ls',
		'marksman',
		'pylsp',
		'rust_analyzer',
		'texlab',
	},
	handlers = {
		lsp.default_setup,
	},
})
