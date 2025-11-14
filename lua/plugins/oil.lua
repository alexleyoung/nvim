vim.keymap.set('n', '<leader>e', ':Oil --float<CR>')
return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    use_default_keymaps = false,
    skip_confirm_for_simple_edits = true,
    keymaps = {
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<C-w>s'] = { 'actions.select', opts = { vertical = true } },
      ['<C-w>h'] = { 'actions.select', opts = { horizontal = true } },
      ['<C-t>'] = { 'actions.select', opts = { tab = true } },
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = { 'actions.close', mode = 'n' },
      ['q'] = { 'ctions.close', mode = 'n' },
      ['<C-h>'] = { 'actions.parent', mode = 'n' },
      ['<C-l>'] = 'actions.select',
      ['<CR>'] = 'actions.select',
      ['_'] = { 'actions.open_cwd', mode = 'n' },
      ['`'] = { 'actions.cd', mode = 'n' },
      ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
      ['gs'] = { 'actions.change_sort', mode = 'n' },
      ['gx'] = 'actions.open_external',
      ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
      ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
    },
    view_options = {
      show_hidden = true,
    },
    float = {
      width = 0.8,
      height = 0.8,
      border = 'rounded',
      winblend = 0,
      highlights = {
        default = 'OilNormal',
        selected = 'OilSelected',
        border = 'OilBorder',
        float = 'OilFloat',
        title = 'OilTitle',
        title_icon = 'OilTitleIcon',
        title_action = 'OilTitleAction',
        item = 'OilItem',
        item_icon = 'OilItemIcon',
        item_action = 'OilItemAction',
        item_visible = 'OilItemVisible',
        item_hidden = 'OilItemHidden',
        item_open = 'OilItemOpen',
        item_empty = 'OilItemEmpty',
        item_current = 'OilItemCurrent',
      },
    },
  },
  -- Optional dependencies
  -- dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}
