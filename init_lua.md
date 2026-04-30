
--Set LeadeR
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Basic Settings
vim.o.number = true         -- Show line numbers
vim.o.relativenumber = true -- Relative line numbers (easier jumping)
vim.o.mouse = 'a'           -- Enable mouse support
vim.o.ignorecase = true     -- Ignore case in search
vim.o.smartcase = true      -- ...unless search has capital letters
vim.o.shiftwidth = 2        -- Size of an indent
vim.o.tabstop = 2  --Tab width
vim.o.shiftwidth = 2  --indent width
vim.o.expandtab = true      -- Use spaces instead of tabs
vim.o.termguicolors = true  -- Better colors
vim.o.scrolloff = 10        -- Keep 10 line below/above cursor line
vim.o.sidescrolloff = 10    -- Keep 10 line left/right cusrsor line
vim.o.spelllang = en   -- spell check
vim.o.cmdheight = 1         --command line height
vim.o.selection = "inclusive"  --Use inclusive selection
vim.o.confirm = true  --Raise dialog in unsaved buffer
vim.o.encoding = "UTF-8" --Ut8 encoding

--Snappy escape
vim.o.updatetime = 250
vim.o.timeoutlen = 250

--How new window appear
vim.o.splitright = true
vim.o.splitbelow = true

--File handling
vim.o.undofile = true --Persistent undo

-- Set undo directory and ensure it exists
local undodir = "~/.local/share/nvim/undodir "
vim.o.undodir = vim.fn.expand(undodir)
local undodir_path = vim.fn.expand(undodir)
if vim.fn.isdirectory(undodir_path) == 0 then
  vim.fn.mkdir(undodir_path, "p")
end

--Sync clipboards
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Copy to clipboard shortcuts
vim.keymap.set('n', '<leader>cp', function()
	local path = vim.fn.expand('%:p')
	vim.fn.setreg('+', path)
	vim.notify('Copied: ' .. path)
end, { desc = 'Copy absolute path' })

vim.keymap.set('n', '<leader>cr', function()
	local path = vim.fn.expand('%')
	vim.fn.setreg('+', path)
	vim.notify('Copied: ' .. path)
end, { desc = 'Copy relative path' })

--Vim diagnostic
vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  float = { source = 'if_many' },
  jump = { float = true },
})

--Show diagnostics
vim.keymap.set('n', '<leader>q', vim.diagnostic.open_float, { desc = 'Show diagnostic' })

--Easily move between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Cursor shape per mode
vim.o.guicursor = 'n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50'

-- Restore last cursor position when reopening a file
local last_cursor_group = vim.api.nvim_create_augroup("LastCursorGroup", {})
vim.api.nvim_create_autocmd("BufReadPost", {
	group = last_cursor_group,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

--Highlights yanks
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end
})

-- Restore last cursor position when reopening file

-- --Plugins for nvim 0.12.X onward
-- vim.pack.add({
--   'https://github.com/ibhagwan/fzf-lua',
--   'https://github.com/nvim-treesitter/nvim-treesitter',
--   'https://github.com/neovim/nvim-lspconfig',
--   'https://github.com/stevearc/oil.nvim',
--   'https://github.com/kdheepak/lazygit.nvim',
--   'https://github.com/esmuellert/codediff.nvim',
--   'https://github.com/MeanderingProgrammer/render-markdown.nvim',
--   'https://github.com/goolord/alpha-nvim',
--   'https://github.com/nvim-tree/nvim-web-devicons',
--   'https://github.com/rebelot/kanagawa.nvim',
--   { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') }, -- pinning so rust binary dependency automatically downloads
-- })

--For 0.11.7 version
-- 1. Bootstrap lazy.nvim (Modern Plugin Manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Load Plugins
require("lazy").setup({
  'ibhagwan/fzf-lua',
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  'neovim/nvim-lspconfig',
  'stevearc/oil.nvim',
  'kdheepak/lazygit.nvim',
  'esmuellert/codediff.nvim',
  'MeanderingProgrammer/render-markdown.nvim',
  'goolord/alpha-nvim',
  'nvim-tree/nvim-web-devicons', 
  'rebelot/kanagawa.nvim',
  {
    'saghen/blink.cmp', 
    version = '*', -- Use a release tag to download pre-built binaries
  }, 
 -- Cursor animations
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      smear_between_buffers            = true,
      smear_between_neighbor_lines     = true,
      scroll_buffer_space              = true,
      legacy_computing_symbols_support = false,
      stiffness                        = 0.95,
      trailing_stiffness               = 0.75,
      distance_stop_animating          = 0.5,
    },
  },
  {
  "gen740/SmoothCursor.nvim",
  config = function()
    require("smoothcursor").setup({
      type               = "exp",
      cursor             = "▷",
      speed              = 50,
      intervals          = 35,
      threshold          = 3,
      disable_float_win  = true,
      disabled_filetypes = { "help", "NvimTree" },
    })
    vim.cmd("SmoothCursorStart")  -- auto-start it
  end,
  },
  -- Mini plugins
  { "echasnovski/mini.ai",          version = "*", opts = {} },
  { "echasnovski/mini.comment",     version = "*", opts = {} },
  { "echasnovski/mini.move",        version = "*", opts = {} },
  { "echasnovski/mini.surround",    version = "*", opts = {} },
  { "echasnovski/mini.cursorword",  version = "*", opts = {} },
  { "echasnovski/mini.indentscope", version = "*", opts = {} },
  { "echasnovski/mini.pairs",       version = "*", opts = {} },
  { "echasnovski/mini.trailspace",  version = "*", opts = {} },
  { "echasnovski/mini.bufremove",   version = "*", opts = {} },
  { "echasnovski/mini.notify",      version = "*", opts = {} },
  {
    "echasnovski/mini.animate",
    version = "*",
    opts = {
      cursor = { enable = false },
      scroll = { enable = false },
      resize = { enable = true  },
      open   = { enable = true  },
      close  = { enable = true  },
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

--Fzf-lua
require("fzf-lua").setup({
  keymap = {
    builtin = {
      ["<C-d>"] = 'preview-page-down',
      ["<C-u>"] = 'preview-page-up',
    },
  }, 
  winopts = {
    height  = 0.95, -- window height
    width   = 0.90, -- window width
  },
  files = {
    formatter = 'path.filename_first',
  },
})
vim.keymap.set('n', '<leader><leader>', '<cmd>FzfLua files<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>/', '<cmd>FzfLua live_grep<cr>', { desc = 'Find live grep' })
vim.keymap.set('n', '<leader>fr', '<cmd>FzfLua resume<cr>', { desc = 'Resume last picker' })
vim.keymap.set('n', '<leader>,', '<cmd>FzfLua buffers<cr>', { desc = 'Buffers' })

-- vim.keymap.set('n', 'grr', fzf.lsp_references, { desc = 'References' })
-- vim.keymap.set('n', 'gri', fzf.lsp_implementations, { desc = 'Implementations' })
-- vim.keymap.set('n', 'gra', fzf.lsp_code_actions, { desc = 'Code actions' })

--Web-devicons
require('nvim-web-devicons').setup({})

--Tree_sitter
vim.cmd('syntax off')
vim.api.nvim_create_autocmd('FileType', {
  callback = function() pcall(vim.treesitter.start) end,
})

--LSP
vim.lsp.enable({
  'ty',
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
vim.keymap.set('n', '<leader>gb', function() vim.ui.open(vim.fn.systemlist('git remote get-url origin')[1]) end,
	{ desc = 'Open git remote' })

 -- Codediff (vscode like diffs :))
require("codediff").setup({})

--DAP

-- Fix for 'nvim .' startup: 
-- Force SmoothCursor to start when entering an Oil buffer
vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function()
    -- Small delay to ensure the UI has rendered before starting animation
    vim.defer_fn(function()
      vim.cmd("SmoothCursorStart")
    end, 50)
  end,
})

-- Optional: Ensure it starts on the Alpha dashboard too
vim.api.nvim_create_autocmd("FileType", {
  pattern = "alpha",
  callback = function()
    vim.cmd("SmoothCursorStart")
  end,
})

--Nevim home screen
local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

-- 1. Header (ASCII Art)
dashboard.section.header.val = {
    [[                               __                ]],
    [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
    [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
    [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
    [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
    [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
}

-- 2. Buttons (Mapped to your existing config)
dashboard.section.buttons.val = {
    dashboard.button("f", "󰈞  Find File", "<cmd>FzfLua files<CR>"),
    dashboard.button("n", "  New File", "<cmd>ene <BAR> startinsert <CR>"),
    dashboard.button("r", "󰄉  Recent Files", "<cmd>FzfLua oldfiles<CR>"),
    dashboard.button("g", "󰊢  Git (LazyGit)", "<cmd>LazyGit<CR>"),
    dashboard.button("s", "  Settings", "<cmd>e $MYVIMRC<CR>"),
    dashboard.button("q", "󰅚  Quit", "<cmd>qa<CR>"),
}

-- 3. Footer (Optional: dynamically shows plugin count)
local stats = require("lazy").stats()
local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"

-- 4. Apply Highlights (Kanagawa compatible)
dashboard.section.header.opts.hl = "AlphaHeader"
dashboard.section.buttons.opts.hl = "AlphaButtons"
dashboard.section.footer.opts.hl = "AlphaFooter"

alpha.setup(dashboard.opts)



