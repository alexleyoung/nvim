local parsers = {
  'bash',
  'c',
  'cpp',
  'diff',
  'elm',
  'html',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'query',
  'vim',
  'vimdoc',
}

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local treesitter = require 'nvim-treesitter'

    treesitter.setup()
    treesitter.install(parsers)

    local group = vim.api.nvim_create_augroup('treesitter-start', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if not lang or not vim.list_contains(parsers, lang) then
          return
        end

        if not pcall(vim.treesitter.start, args.buf, lang) then
          return
        end

        if vim.treesitter.query.get(lang, 'indents') then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
