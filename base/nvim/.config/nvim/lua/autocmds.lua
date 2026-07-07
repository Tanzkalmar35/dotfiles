local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local map = vim.keymap.set
local bs = { buffer = true, silent = true }
local brs = { buffer = true, remap = true, silent = true }

-- Highlight yanked text
local highlight_group = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ timeout = 170 })
    end,
    group = highlight_group,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        map("n", "<C-c>", "<cmd>bd<CR>", bs)
        map("n", "<Tab>", "mf", brs)
        map("n", "<S-Tab>", "mF", brs)
        map("n", "%", function()
            local dir = vim.b.netrw_curdir or vim.fn.expand("%:p:h")
            vim.ui.input({ prompt = "Enter filename: " }, function(input)
                if input and input ~= "" then
                    local filepath = dir .. "/" .. input
                    vim.cmd("!touch " .. vim.fn.shellescape(filepath))
                    vim.api.nvim_feedkeys("<C-l>", "n", false)
                end
            end)
        end, bs)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(ev)
        local ft = vim.bo[ev.buf].filetype
        local formatting = "lua vim.lsp.buf.format()"

        if ft == "lua" then
            formatting = "!stylua %"
        elseif ft == "tex" then
            formatting = "!latexindent -s -l -w %"
        elseif ft == "python" then
            formatting = "!black %"
        end

        local cmd = function()
            vim.cmd("write")
            vim.cmd("silent " .. formatting)
        end

        map("n", "<leader>fo", cmd, { buffer = ev.buf })
    end,
})

-- Diese Gruppe verhindert, dass Autocmds doppelt angelegt werden
local lsp_attach_group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_attach_group,
    callback = function(event)
        local bufnr = event.buf

        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
        map("n", "gr", vim.lsp.buf.references, "Go to References")
        map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")

        -- Logic for hover
        if vim.bo[bufnr].filetype == "rust" then
            -- Your specific Rust override
            map("n", "K", function()
                vim.cmd.RustLsp({ 'hover', 'actions' })
            end, "Rust: Hover")
        else
            -- The default for all other languages
            map("n", "K", vim.lsp.buf.hover, "Hover")
        end

        -- Logic for Code Actions
        if vim.bo[bufnr].filetype == "rust" then
            -- Your specific Rust override
            map("n", "<leader>ca", function()
                vim.cmd.RustLsp('codeAction')
            end, "Rust: Code Action")
        else
            -- The default for all other languages
            map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "http", "rest", "javascript", "lua" },
    callback = function(args)
        local kulala = require("kulala")

        kulala.setup({
            global_keymaps = false,
            global_keymaps_prefix = "<leader>R",
            kulala_keymaps_prefix = "",
        })

        vim.keymap.set("n", "<leader>Rs", kulala.run, { desc = "Send request", buffer = args.buf })
        vim.keymap.set("n", "<leader>Ra", kulala.run_all, { desc = "Send all requests", buffer = args.buf })
        vim.keymap.set("n", "<leader>Rb", kulala.scratchpad, { desc = "Open scratchpad", buffer = args.buf })
    end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    pattern = "*.kt",
    callback = function()
        -- 1. Create a custom highlight group linked to 'Keyword' (usually purple/pink)
        vim.api.nvim_set_hl(0, "KDocTags", { link = "Keyword", default = true })

        -- 2. Prevent duplicate highlights from stacking if you reopen the file
        for _, match in ipairs(vim.fn.getmatches()) do
            if match.group == "KDocTags" then
                vim.fn.matchdelete(match.id)
            end
        end

        -- 3. Paint the color directly onto the window UI
        -- \v\@[a-zA-Z]+ finds @param, @return, @throws, etc.
        vim.fn.matchadd("KDocTags", "\\v\\@[a-zA-Z]+")
    end,
})
