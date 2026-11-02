vim.diagnostic.config({ virtual_text = true })

vim.lsp.enable({
    "bashls",
    "gopls",
    "lua_ls",
    "pyright",
    "texlab",
    "ts_ls",
    "ocamllsp",
    "yamlls",
    "zls",
    "kotlin",
    "tinymist",
    -- Rust is not listed here: rustaceanvim starts rust-analyzer itself
    -- (configured via `vim.g.rustaceanvim` in lua/plugins.lua).
})
vim.diagnostic.config({ virtual_text = true })
