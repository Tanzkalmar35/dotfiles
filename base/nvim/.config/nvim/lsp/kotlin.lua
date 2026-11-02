---@type vim.lsp.Config
local mason_kotlin_lsp = vim.fn.stdpath("data") .. "/mason/packages/kotlin-lsp"
local intellij_server = vim.fn.glob(mason_kotlin_lsp .. "/kotlin-server-*/bin/intellij-server")

return {
    cmd = { intellij_server },
    filetypes = { 'kotlin' },
    root_markers = {
        'build.gradle.kts',
        'build.gradle',
        'settings.gradle.kts',
        'settings.gradle',
        '.git',
    },
}
