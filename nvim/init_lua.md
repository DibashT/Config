# Set LeadeR
vim.g.mapleader = " "
vim.g.maplocalleader = " "

# Basic Settings
vim.o.number = true                             -- Show line numbers
vim.o.relativenumber = true                     -- Relative line numbers (easier jumping)
vim.o.mouse = "a"                               -- Enable mouse support
vim.o.ignorecase = true                         -- Ignore case in search
vim.o.smartcase = true                          -- ...unless search has capital letters
vim.o.shiftwidth = 2                            -- Size of an indent
vim.o.tabstop = 2                               --Tab width
vim.o.smartindent = true                        --smart indentation
vim.o.expandtab = true                          -- Use spaces instead of tabs
vim.o.termguicolors = true                      -- Better colors
vim.o.scrolloff = 10                            -- Keep 10 line below/above cursor line
vim.o.sidescrolloff = 10                        -- Keep 10 line left/right cusrsor line
vim.o.wrap = false                              --Don't wrap lines
vim.o.spelllang = "en"                          -- spell check
vim.o.confirm = true                            --Raise dialog in unsaved buffer
vim.o.signcolumn = "yes"                        --Alwasy show sign column
vim.o.completeopt = "menuone,noinsert,noselect" --Completion options
-- vim.o.updatetime = 250                          -- Snapy key
vim.o.timeoutlen = 300                          --balance speed
-- vim.o.ttimeoutlen = 50                          --fast timesout sequence (ESC)
vim.o.ttimeoutlen = 1                           --fast timesout sequence (ESC)
vim.o.splitright = true                         -- Window split
vim.o.splitbelow = true
vim.o.undofile = true                           --Persistent undo
vim.o.undolevels = 10000                        --allows to safely travesre  much further
-- vim.o.selection = "inclusive"                   --Use inclusive selection
vim.o.wildmode = "longest:full,full"            --Completion mode for command-line
vim.o.wildignorecase = true                     --Case-sensitive tab completion in commands
vim.o.splitkeep =
'screen'                                        --prevents the text from jarringly shifting around when you open horizontal splits or floating windows.

--Sync clipboards with system clipboards
-- vim.schedule(function()
--   vim.o.clipboard = "unnamedplus"
-- end)
--
vim.schedule(function()
  local is_ssh = vim.env.SSH_TTY or vim.env.SSH_CONNECTION

  if is_ssh then
    vim.g.clipboard = "osc52"
    vim.opt.clipboard = ""
  else
    vim.g.clipboard = nil
    vim.opt.clipboard = "unnamedplus"
  end
end)

vim.o.swapfile = false --Disable swap file to prevent annoying errors

-- Copy to clipboard shortcuts
vim.keymap.set("n", "<leader>cp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy absolute path" })

vim.keymap.set("n", "<leader>cr", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy relative path" })

--Vim diagnostic
vim.diagnostic.config({
  underline = false,        --dont underline error
  virtual_text = false,     --show most severe error first
  severity_sort = true,     --dont show while typing
  update_in_insert = false, --nice look for floats (using ty and ruff)
  float = {
    source = "if_many",
    border = "none",
  },
  jump = { float = true },
})

--Buffer navigation
vim.keymap.set("n", "<leader>bn", "<Cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })

--Show diagnostics
vim.keymap.set("n", "<leader>q", vim.diagnostic.open_float, { desc = "Show diagnostic" })
-- Navigate diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end,
  { desc = "Go to previous error" })
vim.keymap.set("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end,
  { desc = "Go to next error" })

-- Easily move between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Better command line movements
vim.keymap.set("c", "<C-b>", "<Left>")
vim.keymap.set("c", "<C-f>", "<Right>")
vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-e>", "<End>")
vim.keymap.set("c", "<M-b>", "<S-Left>")
vim.keymap.set("c", "<M-f>", "<S-Right>")

-- Clear seacrh highlight
vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })

--Better indenting in Visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

--Better j Behaviour
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line in cursor position" })

--Quick config setting
vim.keymap.set("n", "<leader>rc", "<Cmd>e ~/.config/nvim/init.lua<CR>", { desc = "Edit config" })

-- Cursor shape per mode
vim.o.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50"

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
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ timeout = 300 })
  end,
})

--https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack#update
vim.pack.add({
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  -- Dependencies are flatly listed in their required loading order
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/kdheepak/lazygit.nvim',
  'https://github.com/esmuellert/codediff.nvim',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/goolord/alpha-nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  { src = 'https://github.com/saghen/blink.cmp',             version = vim.version.range('1.x') },
  'https://github.com/nvim-lualine/lualine.nvim',
  --Mini stable --
  { src = 'https://github.com/echasnovski/mini.ai',          version = 'stable' },
  { src = 'https://github.com/echasnovski/mini.comment',     version = 'stable' },
  { src = 'https://github.com/echasnovski/mini.move',        version = 'stable' },
  { src = 'https://github.com/echasnovski/mini.surround',    version = 'stable' },
  { src = 'https://github.com/echasnovski/mini.indentscope', version = 'stable' },
  { src = 'https://github.com/echasnovski/mini.pairs',       version = 'stable' },
  { src = 'https://github.com/echasnovski/mini.bufremove',   version = 'stable' },
  { src = 'https://github.com/echasnovski/mini.notify',      version = 'stable' },
  -- Non-GitHub URLs
  'https://codeberg.org/andyg/leap.nvim.git',
  -- color scheme
  'https://github.com/rebelot/kanagawa.nvim',
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
  -- 'https://github.com/vague-theme/vague.nvim',
})

require("mason").setup()

--Kanagawa apply after 0.12
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

--Rose pine colorscheme
require("rose-pine").setup()

-- Treesitter (Neovim 0.12 Native Way)
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- Install the parsers you need
local parsers = {
  "c", "lua", "vim", "vimdoc", "query", "python", "markdown", "markdown_inline",
  "html", "css", "javascript", "typescript", "tsx",
  "json", "yaml", "toml", "xml",
  "bash", "dockerfile", "make", "regex",
  "git_config", "gitcommit", "gitignore", "git_rebase"
}
pcall(function()
  require("nvim-treesitter").install(parsers)
end)

-- Statusline (Lualine)
require("lualine").setup({
  options = {
    theme = "kanagawa",
    component_separators = "|",
    section_separators = { left = "", right = "" },
  },
})

-- Markdown
require("render-markdown").setup({})

-- Mini Plugins
require("mini.ai").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})
require("mini.indentscope").setup({})
require("mini.pairs").setup({})
require("mini.bufremove").setup({})
require("mini.notify").setup({})

--Fzf-lua
require("fzf-lua").setup({
  -- Disabled default fzf colors as per your reference snippet
  fzf_colors = true,
  -- Imported the custom ripgrep options for better search match highlighting
  grep = {
    rg_opts = table.concat({
      "--column --line-number --no-heading --color=always --smart-case --max-columns=4096",
      -- "--colors 'path:none'",
      -- "--colors 'line:none'",
      -- "--colors 'column:none'",
      -- "--colors 'match:fg:225,255,229'",
      "-e",
    }, " "),
  },
  ui_select = true,
  keymap = {
    builtin = {
      ["<C-d>"] = "preview-page-down",
      ["<C-u>"] = "preview-page-up",
    },
  },
  winopts = {
    height = 0.95, -- window height
    width = 0.90,  -- window width
  },
  files = {
    formatter = "path.filename_first",
  },
})
vim.keymap.set("n", "<leader><leader>", "<cmd>FzfLua files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { desc = "Find live grep" })
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua resume<cr>", { desc = "Resume last picker" })
vim.keymap.set("n", "<leader>,", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })

vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_finder<cr>", { desc = "Definition + References" })
vim.keymap.set("n", "grr", "<cmd>FzfLua lsp_references<cr>", { desc = "References" })
vim.keymap.set("n", "gri", "<cmd>FzfLua lsp_implementations<cr>", { desc = "Implementations" })
vim.keymap.set("n", "gra", "<cmd>FzfLua lsp_code_actions<cr>", { desc = "Code actions" })

vim.keymap.set('n', '<leader>fc', '<cmd>FzfLua colorschemes<cr>', { desc = 'Pick colorscheme' })

--Web-devicons
require("nvim-web-devicons").setup({})

--Tree_sitter
-- vim.api.nvim_create_autocmd("FileType", {
--   callback = function()
--     pcall(vim.treesitter.start)
--   end,
-- })
-- vim.cmd("syntax off")

-- LSP
vim.lsp.enable({
  'ty',     -- also $ uv tool install ty@latest
  'ruff',   -- also $ uv tool install ruff@latest
  'lua_ls', -- also $ brew install lua-language-server
  'ts_ls'
})
vim.keymap.set("n", "gD", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "ca", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("n", "rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

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
require('blink.cmp').setup({
  signature = {
    enabled = true,
    window = {
      show_documentation = false,
      border = "rounded",
    },
  },
})

-- Dap (debugging)
local dap = require('dap')
dap.adapters.debugpy = function(cb, config) -- also $ uv tool install debugpy@latest
  if config.request == 'attach' then
    cb({
      type = 'server',
      port = config.connect.port,
      host = config.connect.host or '127.0.0.1',
    })
  else
    cb({
      type = 'executable',
      command = 'debugpy-adapter',
    })
  end
end
dap.configurations.python = { -- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
  {
    type = 'debugpy',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    justMyCode = false,
    python = function()
      local root = vim.fs.root(0, '.venv')
      return { root and root .. '/.venv/bin/python' or 'python3' }
    end,
    cwd = function()
      return vim.fs.root(0, '.venv') or vim.fn.getcwd()
    end,
  },
  {
    type = 'debugpy',
    request = 'launch',
    name = 'Pytest current file',
    module = 'pytest',
    args = { '${file}', '-s' },
    justMyCode = false,
    python = function()
      local root = vim.fs.root(0, '.venv')
      return { root and root .. '/.venv/bin/python' or 'python3' }
    end,
    cwd = function()
      return vim.fs.root(0, '.venv') or vim.fn.getcwd()
    end,
  },
  {
    type = 'debugpy',
    request = 'launch',
    name = 'Pytest current file -k',
    module = 'pytest',
    args = function()
      local test_name = vim.fn.input('pytest -k: ')
      return { '${file}', '-s', '-k', test_name }
    end,
    justMyCode = false,
    python = function()
      local root = vim.fs.root(0, '.venv')
      return { root and root .. '/.venv/bin/python' or 'python3' }
    end,
    cwd = function()
      return vim.fs.root(0, '.venv') or vim.fn.getcwd()
    end,
  },
}
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug toggle breakpoint' })
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug continue' })
vim.keymap.set('n', '<leader>dq', dap.terminate, { desc = 'Debug terminate' })
vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Debug open REPL' })
vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'Debug run last' })
vim.keymap.set({ 'n', 'v' }, '<leader>dh', require('dap.ui.widgets').hover, { desc = 'Debug hover' })
vim.keymap.set('n', '<Down>', dap.step_over, { desc = 'Debug step over' })
vim.keymap.set('n', '<Right>', dap.step_into, { desc = 'Debug step into' })
vim.keymap.set('n', '<Left>', dap.step_out, { desc = 'Debug step out' })
vim.keymap.set('n', '<Up>', dap.restart_frame, { desc = 'Debug restart frame' })

--Oil
require("oil").setup({
  delete_to_trash = true,
  columns = {
    "icon",
    "mtime",
  },
  view_options = {
    show_hidden = true,
    sort = {
      { "type",  "asc" },
      { "mtime", "desc" },
    }
  },
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"
-- For note taking
local wiki = vim.fn.expand("~/git/wiki")

-- Open wiki index
vim.keymap.set("n", "<leader>ww", "<cmd>edit " .. wiki .. "/index.md<CR>:lcd %:p:h<CR>", { desc = "Open wiki index" })

-- Browse wiki with oil
vim.keymap.set("n", "<leader>wo", "<cmd>Oil " .. wiki .. "<CR>", { desc = "Browse wiki" })

-- New note
vim.keymap.set("n", "<leader>wn", function()
  local name = vim.fn.input("Note name: ")
  if name ~= "" then
    vim.cmd("edit " .. wiki .. "/" .. name .. ".md")
    vim.cmd("lcd %:p:h")
  end
end, { desc = "New note" })

-- Search notes (fzf-lua live grep scoped to wiki)
vim.keymap.set("n", "<leader>wg", function()
  require("fzf-lua").live_grep({ cwd = wiki })
end, { desc = "Grep wiki" })

-- Find note by filename
vim.keymap.set("n", "<leader>wf", function()
  require("fzf-lua").files({ cwd = wiki })
end, { desc = "Find wiki file" })

-- vim.keymap.set("n", "<leader>ws", function()
--   vim.cmd("!cd " .. vim.fn.expand("~/git/wiki") .. " && git add . && git commit -m 'update' && git push")
-- end, { desc = "Sync wiki" })
vim.keymap.set("n", "<leader>ws", function()
  vim.fn.jobstart(
    "cd " .. vim.fn.expand("~/git/wiki") .. " && git add . && git commit -m 'update' && git push",
    {
      on_exit = function(_, code)
        if code == 0 then
          vim.notify("Wiki synced", vim.log.levels.INFO)
        else
          vim.notify("Wiki sync failed", vim.log.levels.ERROR)
        end
      end,
    }
  )
end, { desc = "Sync wiki" })

-- Lazygit.nvim
local function git_line_history(start_line, end_line)
  start_line, end_line = math.min(start_line, end_line), math.max(start_line, end_line)
  local range = start_line .. ',' .. end_line .. ':' .. vim.fn.expand('%:t')
  local command = { 'git', '-C', vim.fn.expand('%:p:h'), '--no-pager', 'log', '-L', range }
  local output = vim.fn.systemlist(command)
  local command_text = vim.fn.join(vim.tbl_map(vim.fn.shellescape, command), ' ')

  vim.cmd('vnew')
  vim.bo.buftype = 'nofile'
  vim.bo.filetype = 'diff'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.list_extend({ command_text, '' }, output))
  vim.bo.modified = false
end

vim.keymap.set('n', '<leader>g', '<cmd>LazyGit<cr>', { desc = 'Lazygit' })
vim.keymap.set('n', '<leader>gb', function() vim.ui.open(vim.fn.systemlist('git remote get-url origin')[1]) end,
  { desc = 'Open git remote' })
vim.keymap.set('n', '<leader>gl', function()
  git_line_history(vim.fn.line('.'), vim.fn.line('.'))
end, { desc = 'Git line history' })
vim.keymap.set('v', '<leader>gl', function()
  git_line_history(vim.fn.line('v'), vim.fn.line('.'))
end, { desc = 'Git line history' })

--Lazygit
vim.keymap.set("n", "<leader>g", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
vim.keymap.set("n", "<leader>gb", function()
  vim.ui.open(vim.fn.systemlist("git remote get-url origin")[1])
end, { desc = "Open git remote" })

-- Codediff (vscode like diffs :))
require("codediff").setup({})
vim.keymap.set('n', '<leader>ru', '<cmd>CodeDiff<cr>', { desc = 'Code diff not staged' })
vim.keymap.set('n', '<leader>rm', '<cmd>CodeDiff main<cr>', { desc = 'Code diff main' })
vim.keymap.set('n', '<leader>rh', '<cmd>CodeDiff HEAD~1<cr>', { desc = 'Code diff previous commit' })

-- Neovim home screen
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Header (ASCII Art)
dashboard.section.header.val = {
  [[                                __                ]],
  [[ ___     ___    ___    __  __ /\_\    ___ ___    ]],
  [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
  [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
  [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
  [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
}

-- Buttons
dashboard.section.buttons.val = {
  dashboard.button("f", "󰈞  Find File", "<cmd>FzfLua files<CR>"),
  dashboard.button("n", "  New File", "<cmd>ene <BAR> startinsert <CR>"),
  dashboard.button("r", "󰄉  Recent Files", "<cmd>FzfLua oldfiles<CR>"),
  dashboard.button("g", "󰊢  Git (LazyGit)", "<cmd>LazyGit<CR>"),
  dashboard.button("s", "  Settings", "<cmd>e $MYVIMRC<CR>"),
  dashboard.button("q", "󰅚  Quit", "<cmd>qa<CR>"),
}

-- Footer (Fixed for Neovim 0.12 native package manager)
local count = #vim.pack.get()
-- Native calculation of total elapsed milliseconds since binary startup
local ms = math.floor(vim.fn.reltimefloat(vim.fn.reltime()) * 1000)
dashboard.section.footer.val = "⚡ Neovim loaded " .. count .. " packages in " .. ms .. "ms"

-- Highlights (Kanagawa compatible)
dashboard.section.header.opts.hl = "AlphaHeader"
dashboard.section.buttons.opts.hl = "AlphaButtons"
dashboard.section.footer.opts.hl = "AlphaFooter"

alpha.setup(dashboard.opts)

-- Leap.nvim configuration
require("leap").opts.safe_labels = {} -- Jump immediately to single matches
require("leap").opts.labels =
-- { "a", "s", "d", "f", "g", "h", "j", "k", "l", "q", "w", "e", "r", "t", "y", "u", "i", "o", "p" }
{ "a", "s", "d", "f", "g", "h", "j", "k", "l", ";" }

-- Basic bidirectional leap motions
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")

-- Usage: gs{leap}yap yanks a paragraph at the leap target
vim.keymap.set({ "n", "o" }, "gs", "<Plug>(leap-remote)")
vim.keymap.set({ "n", "o" }, "gS", "<Plug>(leap-remote-linewise)")

-- Usage: van{label} or vannny to select treesitter nodes
vim.keymap.set({ "x", "o" }, "an", function()
  require("leap.treesitter").select({
    opts = require("leap.user").with_traversal_keys("n", "N"),
  })
end)

-- Optional: Automatic paste after remote yank
vim.api.nvim_create_autocmd("User", {
  pattern = "RemoteOperationDone",
  group = vim.api.nvim_create_augroup("LeapRemote", {}),
  callback = function(event)
    if vim.v.operator == "y" and event.data.register == '"' then
      vim.cmd("normal! p")
    end
  end,
})

-- Reduce visual noise
vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
