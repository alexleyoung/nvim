-- See `:help vim.keymap.set()`
-- vim.keymap.set({mode}, {lhs}, {rhs}, {opts})

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.supermaven_enabled = false

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- map leader+w to save current file in normal mode
vim.keymap.set('n', '<Leader>w', ':write<CR>', { noremap = true, silent = true })

-- recenter on C-d and C-u
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- remap ^ to !
vim.keymap.set('n', '!', '^', { noremap = true })
vim.keymap.set('v', '!', '^', { noremap = true })

-- indent
vim.keymap.set('v', '<Tab>', '>gv')
vim.keymap.set('v', '<S-Tab>', '<gv')

-- dev keymaps
vim.keymap.set('n', '<Leader>xf', '<cmd>source %<CR>')
vim.keymap.set('n', '<Leader>xx', ':.lua<CR>')
vim.keymap.set('v', '<Leader>x', ':lua<CR>')

-- supermaven toggle
vim.keymap.set('n', '<Leader>sm', function()
  vim.g.supermaven_enabled = not vim.g.supermaven_enabled
  vim.cmd 'SupermavenToggle'
  local msg = vim.g.supermaven_enabled and 'Supermaven Enabled' or 'Supermaven Disabled'
  vim.notify(msg, vim.log.levels.INFO)
end, { desc = 'Toggle [S]uper[m]aven' })

local function jot()
  local filepath = vim.fn.expand '~/JOT.md'

  local buf = vim.fn.bufnr(filepath, true)

  local width = 80
  local height = 2
  local row = math.ceil((vim.o.lines - height) / 2)
  local col = math.ceil((vim.o.columns - width) / 2)

  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    border = 'rounded',
    style = 'minimal',
  }

  vim.api.nvim_open_win(buf, true, opts)

  vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = buf })
  vim.api.nvim_set_option_value('swapfile', false, { buf = buf })

  vim.keymap.set('n', 'q', function()
    -- write changes
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    vim.fn.writefile(lines, filepath)

    vim.api.nvim_buf_delete(buf, { force = true })

    vim.notify('notes saved', vim.log.levels.INFO)
  end, { buffer = buf, noremap = true, silent = true, desc = 'save quit notes buf' })
end

vim.keymap.set('n', '<leader>j', jot, { desc = 'jot notes' })

local function copyPath(relative)
  local path = relative and vim.fn.expand '%' or vim.fn.expand '%:p'
  vim.fn.setreg('+', path)
  print('copied: ' .. path)
end
-- copy path
vim.keymap.set('n', '<Leader>cp', function()
  copyPath(false)
end)
vim.keymap.set('n', '<Leader>cr', function()
  copyPath(true)
end)
