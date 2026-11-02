vim.pack.add({
    -- Own plugins
    -- { src = "https://github.com/Tanzkalmar35/justsync.nvim" },
    { src = "https://github.com/Tanzkalmar35/ghostnotes" },

    -- Dependencies
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/kevinhwang91/promise-async" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/antoinemadec/FixCursorHold.nvim" },
    { src = "https://github.com/nvim-neotest/nvim-nio" },
    { src = "https://github.com/tpope/vim-fugitive" },

    -- QoL
    { src = "https://github.com/m4xshen/autoclose.nvim" },
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/saghen/blink.cmp",                         version = vim.version.range("^1") },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/jeangiraldoo/codedocs.nvim" },
    { src = "https://github.com/kevinhwang91/nvim-ufo" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/hedyhli/outline.nvim" },
    { src = "https://github.com/folke/trouble.nvim" },
    { src = "https://github.com/sindrets/diffview.nvim" },
    { src = "https://github.com/chomosuke/typst-preview.nvim" },

    -- Debugging
    { src = "https://github.com/mfussenegger/nvim-dap" },
    { src = "https://github.com/MironPascalCaseFan/debugmaster.nvim" },

    -- Appearence
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/rcarriga/nvim-notify" },
    { src = "https://github.com/rebelot/kanagawa.nvim" },

    -- Languages / Unit tests / Net client testing
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/lervag/vimtex" },
    { src = "https://github.com/mrcjkb/rustaceanvim" },
    { src = "https://github.com/mfussenegger/nvim-jdtls" },
    { src = "https://github.com/AlexandrosAlexiou/kotlin.nvim" },
    { src = "https://github.com/mistweaverco/kulala.nvim" },
    { src = "https://github.com/rcasia/neotest-java" },
    { src = "https://github.com/weilbith/neotest-gradle" },
    { src = "https://github.com/nvim-neotest/neotest" },
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },

    -- Notes
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    { src = "https://github.com/pysan3/pathlib.nvim" },
    { src = "https://github.com/nvim-neorg/lua-utils.nvim" },
    { src = "https://github.com/nvim-neorg/neorg" },
})

require("neotest").setup({
    adapters = {
        require("neotest-java")({
            -- picked up automatically, but explicit is fine:
            incremental_build = true, -- only recompile changed files via jdtls
            jvm_args = { "-Xmx4g" },  -- Spring context tests can be memory-hungry
        }),
        require("neotest-gradle"),
    },
})

-- ### Render markdown

require('render-markdown').setup({
    file_types = { 'markdown', 'kotlin' },
})

-- ### Neorg

require('neorg').setup {
    lazy = false,
    version = "*",
    load = {
        ["core.defaults"] = {},
        ["core.dirman"] = {
            config = {
                workspaces = {
                    neorg = "~/neorg",
                    sprintstart = "~/neorg/sprintstart/",
                    justsync = "~/neorg/justsync/"
                },
            }
        },
        ["core.concealer"] = {},
    }
}

-- ### Kotlin lsp setup
require("kotlin").setup {
    root_markers = {
        "gradlew",
        ".git",
        "settings.gradle",
        "settings.gradle.kts",
    },
    jvm_args = { "-Xmx16g" },
    inlay_hints = {
        enabled = true,
    },
    folding = { enbabled = true },
}

-- ### Trouble setup
require('trouble').setup()

-- ### VimTeX config
vim.g.vimtex_quickfix_open_on_warning = 0
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_compiler_method = 'latexmk'
vim.g.vimtex_compiler_latexmk = {
    options = {
        '-shell-escape',
        '-verbose',
        '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode',
        '-lualatex', -- Hier wird LuaLaTeX forciert
    },
}

require("outline").setup({
    symbols = {
        filter = {
            default = {
                "Class",
                "Constructor",
                "Enum",
                "Function",
                "Interface",
                "Method",
                "Module",
                "Namespace",
                "Struct",
                "Trait",
            },
        },
    },
})

require('ghostnotes').setup()
require('oil').setup()
require('mason').setup({
    ensure_installed = {
        "jdlts",
        "texlab",
    }
})
require('autoclose').setup({})
require('nvim-treesitter.configs').setup({
    ensure_installed = { "lua", "go", "rust", "java", "latex", "bibtex" },
    highlight = { enable = true }
})

require('blink.cmp').setup({
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true },
    keymap = {
        preset = "default",
        ["<C-space>"] = {},
        ["<C-p>"] = {},
        ["<Tab>"] = { "select_and_accept", "fallback" },
        ["<S-Tab>"] = {},
        ["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-n>"] = { "select_and_accept" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-b>"] = { "scroll_documentation_down", "fallback" },
        ["<C-f>"] = { "scroll_documentation_up", "fallback" },
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-h>"] = { "snippet_backward", "fallback" },
        -- ["<C-e>"] = { "hide" },
    },

    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "normal",
    },

    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        }
    },

    cmdline = {
        keymap = {
            preset = 'inherit',
            ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },
    },

    sources = { default = { "lsp" } }
})

local actions = require('fzf-lua.actions')
require('fzf-lua').setup({
    winopts = { backdrop = 85 },
    keymap = {
        builtin = {
            ["<C-f>"] = "preview-page-down",
            ["<C-b>"] = "preview-page-up",
            ["<C-p>"] = "toggle-preview",
        },
        fzf = {
            ["ctrl-a"] = "toggle-all",
            ["ctrl-t"] = "first",
            ["ctrl-g"] = "last",
            ["ctrl-d"] = "half-page-down",
            ["ctrl-u"] = "half-page-up",
        }
    },
    actions = {
        files = {
            ["ctrl-q"] = actions.file_sel_to_qf,
            ["ctrl-n"] = actions.toggle_ignore,
            ["ctrl-h"] = actions.toggle_hidden,
            ["enter"]  = actions.file_edit_or_qf,
        }
    }
})

local java_aug = vim.api.nvim_create_augroup("JavaJdtls", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = java_aug,
    pattern = "java",
    callback = function()
        -- --- MANUALLY DEFINE THE PATH ---
        -- Get the path to the jdtls executable installed by Mason
        local mason_bin_path = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
        -- --- VERIFY THE PATH (for safety) ---
        -- This checks if the file actually exists before we try to use it
        if vim.fn.executable(mason_bin_path) == 0 then
            print("Error: jdtls executable not found at: " .. mason_bin_path)
            print("Make sure Mason has installed jdtls.")
            return
        end

        local jdtls = require("jdtls")
        jdtls.start_or_attach({
            -- We are now explicitly telling nvim-jdtls what command to run
            cmd = { mason_bin_path },
            root_dir = jdtls.setup.find_root({
                "pom.xml",
                "build.gradle",
                "settings.gradle",
                ".git",
            }),
            on_attach = function(client, bufnr)
                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                -- Java-specific refactoring maps
                map("n", "<leader>jo", jdtls.organize_imports, "Organize Imports")
                map("n", "<leader>jev", jdtls.extract_variable, "Extract Variable")
                map("v", "<leader>jem", "<ESC><CMD>lua require('jdtls').extract_method(true)<CR>", "Extract Method")
            end,
        })
    end,
})

-- ### nvim-ufo Configs ###

vim.o.foldcolumn = "0"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

-- UFO setup
require("ufo").setup({
    -- Tell UFO to use treesitter folds
    provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
    end
})

-- vim.opt.rtp:append("~/Desktop/git/JustSync/extensions/neovim")

-- ### JustSync config
-- require('justsync').setup()

-- ### Vim.notify

local notify = require("notify")
notify.setup({
    stages = "fade",    -- Smooth fading animation ('fade', 'slide', 'static')
    timeout = 1000,     -- Milliseconds before it disappears
    render = "minimal", -- Clean look without heavy borders
    top_down = true,    -- Set to true if you want them to stack from the top
    background_colour = "#000000",
})

vim.notify = notify

-- ### Debugging setup

local dm = require("debugmaster")
local dap = require("dap")
require("dap").set_log_level("DEBUG")

vim.keymap.set({ "n", "v" }, "<leader>td", dm.mode.toggle, { nowait = true })
vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- codelldb adapter (assumes Mason installed it)
dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
        args = { "--port", "${port}" },
    },
}

-- Rust configs
dap.configurations.rust = {
    {
        name = "Attach to process",
        type = "codelldb",
        request = "attach",
        pid = require("dap.utils").pick_process, -- no () and no wrapper
        program = function()
            local p = vim.fn.input("Path to binary: ", vim.fn.getcwd() .. "/target/debug/JustSync")
            vim.notify("Program: " .. p)
            return p
        end,
    },
}

-- Gitsigns config
require('gitsigns').setup {
    on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then
                vim.cmd.normal({ ']c', bang = true })
            else
                gitsigns.nav_hunk('next')
            end
        end)

        map('n', '[c', function()
            if vim.wo.diff then
                vim.cmd.normal({ '[c', bang = true })
            else
                gitsigns.nav_hunk('prev')
            end
        end)

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('n', '<leader>hr', gitsigns.reset_hunk)

        map('v', '<leader>hs', function()
            gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)

        map('v', '<leader>hr', function()
            gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)

        map('n', '<leader>hS', gitsigns.stage_buffer)
        map('n', '<leader>hR', gitsigns.reset_buffer)
        map('n', '<leader>hp', gitsigns.preview_hunk)
        map('n', '<leader>hi', gitsigns.preview_hunk_inline)

        map('n', '<leader>hb', function()
            gitsigns.blame_line({ full = true })
        end)

        map('n', '<leader>hd', gitsigns.diffthis)

        map('n', '<leader>hD', function()
            gitsigns.diffthis('~')
        end)

        map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
        map('n', '<leader>hq', gitsigns.setqflist)

        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
        map('n', '<leader>tw', gitsigns.toggle_word_diff)

        -- Text object
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
    end
}

-- ### Rust LSP (rustaceanvim)
-- rustaceanvim replaces nvim-lspconfig's `rust_analyzer`: it is a filetype plugin,
-- so it needs no `setup()` call and must not be enabled through `vim.lsp.enable`.
-- Setting `vim.g.rustaceanvim` here (at startup) is enough. See `:h rustaceanvim.config`.
vim.g.rustaceanvim = {
    server = {
        default_settings = {
            ['rust-analyzer'] = {
                -- Run `cargo check` in the background and report the results as
                -- diagnostics on save. (`checkOnSave` is deprecated in rust-analyzer.)
                check = {
                    command = "check", -- or "clippy" if you prefer clippy warnings
                },
            },
        },
    },
}

require("typst-preview").setup({
    open_cmd = "flatpak run app.zen_browser.zen %s",
})
