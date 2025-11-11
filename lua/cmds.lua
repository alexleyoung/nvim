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

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'h', 'hpp' },
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
    vim.opt.expandtab = true
    vim.opt.smartindent = true
    vim.opt.autoindent = true
    vim.opt.smarttab = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'java',
  callback = function()
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
    local workspace_dir = vim.fn.stdpath 'data' .. package.config:sub(1, 1) .. 'jdtls-workspace' .. package.config:sub(1, 1) .. project_name
    vim.fn.setreg('+ ', workspace_dir)
    local os_name = vim.loop.os_uname().sysname
    local config = {
      -- The command that starts the language server
      -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
      cmd = {
        -- 💀
        'java', -- or '/path/to/java17_or_newer/bin/java'
        -- depends on if `java` is in your $PATH env variable and if it points to the right version.

        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens',
        'java.base/java.util=ALL-UNNAMED',
        '--add-opens',
        'java.base/java.lang=ALL-UNNAMED',

        -- 💀
        '-jar',
        vim.fn.stdpath 'data'
          .. package.config:sub(1, 1)
          .. 'mason'
          .. package.config:sub(1, 1)
          .. 'packages'
          .. package.config:sub(1, 1)
          .. 'jdtls'
          .. package.config:sub(1, 1)
          .. 'plugins'
          .. package.config:sub(1, 1)
          .. 'org.eclipse.equinox.launcher_1.7.100.v20251014-1222.jar',
        -- Must point to the                                                     Change this to
        -- eclipse.jdt.ls installation                                           the actual version

        -- 💀
        '-configuration',
        vim.fn.stdpath 'data'
          .. package.config:sub(1, 1)
          .. 'mason'
          .. package.config:sub(1, 1)
          .. 'packages'
          .. package.config:sub(1, 1)
          .. 'jdtls'
          .. package.config:sub(1, 1)
          .. 'config_'
          .. (os_name == 'Windows_NT' and 'win' or os_name == 'Linux' and 'linux' or 'mac'),
        -- eclipse.jdt.ls installation            Depending on your system.

        -- 💀
        -- See `data directory configuration` section in the README
        '-data',
        workspace_dir,
      },

      -- 💀
      -- This is the default if not provided, you can remove it. Or adjust as needed.
      -- One dedicated LSP server & client will be started per unique root_dir
      root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew' },

      -- Here you can configure eclipse.jdt.ls specific settings
      -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
      -- for a list of options
      settings = {
        java = {},
      },

      -- Language server `initializationOptions`
      -- You need to extend the `bundles` with paths to jar files
      -- if you want to use additional eclipse.jdt.ls plugins.
      --
      -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
      --
      -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
      init_options = {
        bundles = {},
      },
    }
    -- print(table.concat(config.cmd, ' '))
    -- vim.fn.setreg('+', table.concat(config.cmd, ' '))
    --
    -- This starts a new client & server,
    -- or attaches to an existing client & server depending on the `root_dir`.
    require('jdtls').start_or_attach(config)
  end,
})

-- mini plugins
function SupermavenToggle()
  vim.g.supermavenEnabled = not vim.g.supermavenEnabled
  vim.cmd 'SupermavenToggle'
  local msg = vim.g.supermaveEnabled and 'Supermaven Enabled' or 'Supermaven Disabled'
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
