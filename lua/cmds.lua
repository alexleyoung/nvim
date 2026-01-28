--  See `:help lua-guide-autocommands`
-- nvim_create_autocmd({event}, {*opts})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'typst' },
  callback = function()
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.softtabstop = 2
    vim.opt.expandtab = true
    vim.opt.smartindent = true
    vim.opt.autoindent = true
    vim.opt.smarttab = true
  end,
})


-- mini plugins
  vim.notify(msg, vim.log.levels.INFO)
end

function Jot()
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
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    vim.fn.writefile(lines, filepath)

    vim.api.nvim_buf_delete(buf, { force = true })

    vim.notify('notes saved', vim.log.levels.INFO)
  end, { buffer = buf, noremap = true, silent = true, desc = 'save quit notes buf' })
end

function CopyPath(relative)
  local path = relative and vim.fn.expand '%' or vim.fn.expand '%:p'
  vim.fn.setreg('+', path)
  print('copied: ' .. path)
end
