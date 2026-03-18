-- See `:help vim.keymap.set()`
-- vim.keymap.set({mode}, {lhs}, {rhs}, {opts})

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.supermaven_disabled = true

local map = vim.keymap.set

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- map leader+w to save current file in normal mode
map('n', '<Leader>w', ':write<CR>', { noremap = true, silent = true })

-- recenter on C-d and C-u
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

-- remap ^ to !
map('n', '!', '^', { noremap = true })
map('v', '!', '^', { noremap = true })

-- indent
map('v', '<Tab>', '>gv')
map('v', '<S-Tab>', '<gv')

-- dev keymaps
map('n', '<Leader>xf', '<cmd>source %<CR>')
map('n', '<Leader>xx', ':.lua<CR>')
map('v', '<Leader>x', ':lua<CR>')

-- jot
map('n', '<leader>j', Jot, { desc = 'jot notes' })

-- copy path
map('n', '<Leader>cp', function()
  CopyPath(false)
end)
map('n', '<Leader>cr', function()
  CopyPath(true)
end)

-- typst
map('n', '<Leader>tp', '<cmd>TypstPreview<CR>')
map('n', '<Leader>tps', '<cmd>TypstPreviewStop<CR>')

-- compile mode
map('n', '<Leader>R', ':Compile<CR>')
map('n', '<Leader>r', ':Recompile<CR>')
