-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- load plugins
require('lazy').setup {
  { import = 'plugins' },
  { import = 'plugins.core' },
}

-- load theme
local theme_file = vim.fn.stdpath 'config' .. '/theme.txt'
if vim.fn.filereadable(theme_file) == 1 then
  local theme = vim.fn.readfile(theme_file)[1]
  if theme then
    vim.cmd('colorscheme ' .. theme)
  end
end

-- force transparency
-- vim.cmd [[
--   highlight Normal guibg=none
--   highlight NormalNC guibg=none
--   highlight SignColumn guibg=none
--   highlight LineNr guibg=none
--   highlight FoldColumn guibg=none
--   highlight VertSplit guibg=none
--
--   highlight GitSignsAdd guibg=none
--   highlight GitSignsChange guibg=none
--   highlight GitSignsDelete guibg=none
--
--   highlight NeoTreeNormal guibg=none
--   highlight NeoTreeNormalNC guibg=none
--   highlight NeoTreeEndOfBuffer guibg=none
--   highlight NeoTreeWinSeparator guibg=none
--   highlight NeoTreeFloatBorder guibg=none
-- ]]
