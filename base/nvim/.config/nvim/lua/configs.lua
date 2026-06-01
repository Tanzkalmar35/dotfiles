local opt = vim.opt
opt.colorcolumn = "120" -- Highlight column 120
opt.signcolumn = "yes:1" -- Always show sign column
opt.termguicolors = true -- Enable true colors
opt.ignorecase = true -- Ignore case in search
opt.swapfile = false -- Disable swap files
opt.autoindent = true -- Enable auto indentation
opt.expandtab = true -- Use spaces instead of tabs
opt.tabstop = 4 -- Number of spaces for a tab
opt.softtabstop = 4 -- Number of spaces for a tab when editing
opt.shiftwidth = 4 -- Number of spaces for autoindent
opt.shiftround = true -- Round indent to multiple of shiftwidth
opt.listchars = "tab: ,multispace:|   ,eol:󰌑" -- Characters to show for tabs, spaces, and end of line
opt.list = true -- Show whitespace characters
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.numberwidth = 2 -- Width of the line number column
opt.wrap = false -- Disable line wrapping
opt.cursorline = true -- Highlight the current line
opt.scrolloff = 8 -- Keep 8 lines above and below the cursor
opt.inccommand = "nosplit" -- Shows the effects of a command incrementally in the buffer
opt.undodir = os.getenv('HOME') .. '/.vim/undodir' -- Directory for undo files
opt.undofile = true -- Enable persistent undo
opt.completeopt = { "menuone", "popup", "noinsert" } -- Options for completion menu
opt.winborder = "rounded" -- Use rounded borders for windows
opt.hlsearch = false -- Disable highlighting of search results

vim.g.netrw_liststyle = 1 -- Use the long listing view
vim.g.netrw_sort_by = "size" -- Sort files by file size

vim.cmd.filetype("plugin indent on") -- Enable filetype detection, plugins, and indentation
vim.cmd.colorscheme("kanagawa-dragon")

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- Fix for gitsigns and ufo column backgrounds while preserving marker colors
local transparent_groups = {
    "SignColumn",
    "FoldColumn",
    "CursorLineSign",
    "CursorLineFold",
    "GitSignsAdd",
    "GitSignsChange",
    "GitSignsDelete",
    "GitSignsTopdelete",
    "GitSignsChangedelete",
    "GitSignsUntracked",
    "DiagnosticSignError",
    "DiagnosticSignWarn",
    "DiagnosticSignInfo",
    "DiagnosticSignHint",
}

for _, group in ipairs(transparent_groups) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
    if ok then
        hl.bg = "none"
        hl.ctermbg = "none"
        vim.api.nvim_set_hl(0, group, hl)
    else
        vim.api.nvim_set_hl(0, group, { bg = "none" })
    end
end

vim.api.nvim_set_hl(0, "LineNr",       { fg = "#3d3b3b", bg = "none" })
vim.api.nvim_set_hl(0, "LineNrAbove",  { fg = "#3d3b3b", bg = "none" })
vim.api.nvim_set_hl(0, "LineNrBelow",  { fg = "#3d3b3b", bg = "none" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#a6a69c", bg = "none", bold = true })

vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = "#3d3b3b", bg = "#1f1d1d" })
vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = "#3d3b3b", bg = "#1f1d1d" })
vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { fg = "#3d3b3b", bg = "#1f1d1d" })
vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#1f1d1d", fg = "#c5c9c5" })
vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#2d4f67", fg = "#c5c9c5" })
vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#1f1d1d", fg = "#c5c9c5" })
