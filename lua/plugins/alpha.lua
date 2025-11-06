-- https://github.com/nxtkofi/LightningNvim/blob/master/lua/custom/plugins/alpha.lua
return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    _Gopts = {
      position = 'center',
      hl = 'Type',
      wrap = 'overflow',
    }

    local function get_all_files_in_dir(dir)
      local files = {}
      local scan = vim.fn.globpath(dir, '**/*.lua', true, true)
      for _, file in ipairs(scan) do
        table.insert(files, file)
      end
      return files
    end

    local function load_random_header()
      math.randomseed(os.time())
      local header_folder = vim.fn.stdpath 'config' .. '/lua/plugins/headers/'
      local files = get_all_files_in_dir(header_folder)

      if #files == 0 then
        return nil
      end

      local random_file = files[math.random(#files)]
      local relative_path = random_file:sub(#header_folder + 1)
      print(relative_path)
      local module_name = 'plugins.headers.' .. relative_path:gsub('/', '.'):gsub('\\', '.'):gsub('%.lua$', '')

      package.loaded[module_name] = nil

      local ok, module = pcall(require, module_name)
      print(ok, module)
      if ok and module.header then
        print('returning header: ', module.header)
        return module.header
      else
        print('Failed to load header: ' .. module_name)
        return nil
      end
    end

    local function change_header()
      local new_header = load_random_header()
      if new_header then
        dashboard.config.layout[2] = new_header
        require('alpha').redraw()
      else
        print 'No images inside headers folder.'
      end
    end

    local header = load_random_header()
    if header then
      dashboard.config.layout[2] = header
      require('alpha').redraw()
    else
      print 'No images inside headers folder.'
    end

    dashboard.section.buttons.val = {
      dashboard.button('r', 'randomize image', function()
        change_header()
      end),
    }

    dashboard.config.layout = {
      -- { type = 'padding', val = 70 },
      header,
      -- { type = 'padding', val = 5 },
      -- dashboard.section.buttons,
      -- dashboard.section.footer,
    }

    -- vim.api.nvim_create_autocmd('User', {
    --   pattern = 'LazyVimStarted',
    --   desc = 'Add Alpha dashboard footer',
    --   once = true,
    --   callback = function()
    --     local stats = require('lazy').stats()
    --     local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
    --     dashboard.section.footer.val = { ' ', ' ', ' ', ' Loaded ' .. stats.count .. ' plugins  in ' .. ms .. ' ms ' }
    --     dashboard.section.header.opts.hl = 'DashboardFooter'
    --     pcall(vim.cmd.AlphaRedraw)
    --   end,
    -- })

    dashboard.opts.opts.noautocmd = true
    alpha.setup(dashboard.opts)
  end,
}
