--Set Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Basic Settings
vim.o.number = true         -- Show line numbers
vim.o.relativenumber = true -- Relative line numbers (easier jumping)
vim.o.mouse = 'a'           -- Enable mouse support
vim.o.ignorecase = true     -- Ignore case in search
vim.o.smartcase = true      -- ...unless search has capital letters
vim.o.shiftwidth = 4        -- Size of an indent
vim.o.expandtab = true      -- Use spaces instead of tabs
vim.o.termguicolors = true  -- Better colors

--Sync clipboards
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

--Raise dialog in unsaved buffer
vim.o.confirm = true

--Snappy escape
vim.o.timeoutlen = 400

--Vim diagnostic
vim.diagnostic.config({
    severity_sort = true,
    update_in_insert = false,
    float = { source = 'if_many' },
    jump = { float = true },
})

--Show diagnostics
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show diagnostic' })

--Easily move beteween windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

--Highlights yanks
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function() vim.highlight.on_yank() end
})

--Plugins
vim.pack.add({
    'https://github.com/ibhagwan/fzf-lua',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/stevearc/oil.nvim',
    'https://github.com/kdheepak/lazygit.nvim',
    'https://github.com/esmuellert/codediff.nvim',
    'https://github.com/MeanderingProgrammer/render-markdown.nvim',
    'https://github.com/goolord/alpha-nvim',
    'https://github.com/rebelot/kanagawa.nvim',
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') }, -- pinning so rust binary dependency automatically downloads

})

--Fzf-lua
require("fzf-lua").setup({
    keymap = {
        builtin = {
            ["<C-d>"] = 'preview-page-down',
            ["<C-u>"] = 'preview-page-up',
        },
    },
})

--Kanagawa
require('kanagawa').setup({
    colors = {
        theme = {
            all = {
                ui = {
                    bg_gutter = "none"
                }
            }
        }
    }
})
vim.cmd('colorscheme kanagawa-wave')

--Markdown
require('render-markdown').setup({})

vim.keymap.set('n', '<leader><leader>', '<cmd>FzfLua files<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>/', '<cmd>FzfLua live_grep<cr>', { desc = 'Find live grep' })


--Tree_stter
vim.cmd('syntax off')
vim.api.nvim_create_autocmd('FileType', {
    callback = function() pcall(vim.treesitter.start) end,
})


--LSP
vim.lsp.enable({
    'ty',
    'ruff',
    'lua_ls',
    'ts_ls',
})
vim.o.signcolumn = 'yes'
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
-- Auto-format ("lint") on save (adapted from neovim docs :help auto-format)
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', { clear = true }),
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp.fmt', { clear = false }),
                buffer = ev.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end
    end,
})


--Blink
require('blink.cmp').setup({})

--Oil
require("oil").setup({
    view_options = {
        show_hidden = true,
    },
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

--Lazygit
vim.keymap.set('n', '<leader>g', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })

-- Codediff (vscode like diffs :))
require("codediff").setup({})

--DAP

--Neovim Homescreen Configuration
