--Set Leader
vim.g.mapleader=' '
vim.g.maplocalleader=' '

-- Basic Settings
vim.o.number = true            -- Show line numbers
vim.o.relativenumber = true    -- Relative line numbers (easier jumping)
vim.o.mouse = 'a'              -- Enable mouse support
vim.o.ignorecase = true        -- Ignore case in search
vim.o.smartcase = true         -- ...unless search has capital letters
vim.o.shiftwidth = 4           -- Size of an indent
vim.o.expandtab = true         -- Use spaces instead of tabs
vim.o.termguicolors = true     -- Better colors

--Sync clipboards
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

--Raise dialog in unsaved buffer
vim.o.confirm = true

--Snappy escape
vim.o.timeoutlen = 500

--Vim diagnostic
vim.diagnostic.config({
    severity_sort = true,
    update_in_insert = false,
    float = {source = 'if_many'},
    jump = {float = true},
})

--Show diagnostics
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, {desc = 'Show diagnostic'})

--Easily move beteween windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

--Highlights yanks
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight-yank', {clear = true}),
    callback = function() vim.highlight.on_yank() end
})

--Plugins
vim.pack.add({
    'https://github.com/ibhagwan/fzf-lua'
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

vim.keymap.set('n', '<leader><leader>', '<cmd>FzfLua files<cr>', {desc = 'Find files'})
vim.keymap.set('n', '<leader>/', '<cmd>FzfLua live_grep<cr>', {desc = 'Find live grep'})

