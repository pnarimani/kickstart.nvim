-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- {
  --   'Civitasv/cmake-tools.nvim',
  --   event = 'VeryLazy',
  --   opts = {
  --     cmake_build_directory = function()
  --       local osys = require 'cmake-tools.osys'
  --       if osys.iswin32 then
  --         return 'build\\${variant:buildType}'
  --       end
  --       return 'build/${variant:buildType}'
  --     end,
  --
  --     cmake_soft_link_compile_commands = true, -- this will automatically make a soft link from compile commands file to project root dir
  --     cmake_compile_commands_from_lsp = true,
  --
  --     cmake_regenerate_on_save = true, -- auto generate when save CMakeLists.txt
  --     cmake_generate_options = { '-DCMAKE_EXPORT_COMPILE_COMMANDS=1' }, -- this will be passed when invoke `CMakeGenerate`
  --
  --     cmake_dap_configuration = { -- debug settings for cmake
  --       name = 'cpp',
  --       type = 'codelldb',
  --       request = 'launch',
  --       stopOnEntry = false,
  --       runInTerminal = true,
  --       console = 'integratedTerminal',
  --     },
  --   },
  -- },
  {
    'Exafunction/codeium.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      require('codeium').setup {}
    end,
  },
  -- {
  --   'rluba/jai.vim',
  -- },
  {
    'mg979/vim-visual-multi',
  },
  -- {
  --   'neoclide/coc.nvim',
  -- },
  {
    'stevearc/overseer.nvim',
    event = 'UIEnter',
    config = function()
      local overseer = require 'overseer'
      overseer.setup {}
      overseer.register_template {
        name = 'odin_run_debug',
        builder = function()
          local project_root = vim.fs.root(0, { '.gitignore' })
          return {
            cmd = { 'odin' },
            args = { 'run', 'src', '-debug', '-out:bin/debug.exe', '-collection:sokol=sokol/sokol', '-collection:libs=vendor' },
            name = 'Run',
            cwd = project_root,
            components = {
              'open_output',
              {
                'on_exit_set_status', -- Finalizes the task on exit
              },
            },
          }
        end,
        desc = 'Runs Odin Game',
      }

      overseer.register_template {
        name = 'odin_rad_dbg',
        builder = function()
          local project_root = vim.fs.root(0, { '.gitignore' })
          return {
            cmd = { 'raddbg' },
            args = { 'run', 'src', '-debug', '-out:bin/debug.exe' },
            name = 'Run',
            cwd = project_root,
            components = { 'open_output', { 'on_exit_set_status' } },
          }
        end,
        desc = 'Runs Odin Game',
      }

      overseer.register_template {
        name = 'Odin Build (Debug)',
        builder = function()
          local project_root = vim.fs.root(0, { '.gitignore' })
          return {
            cmd = { 'odin' },
            args = { 'build', 'src', '-debug', '-sanitize:address', '-out:bin/debug.exe' },
            name = 'build',
            cwd = project_root,
            components = {
              { 'on_output_quickfix', set_diagnostics = true },
              {
                'on_output_parse',
                parser = {
                  diagnostics = {
                    { 'extract', '^(.+)\\(([0-9]+):([0-9]+)\\) (.+)$', 'filename', 'lnum', 'text' },
                  },
                },
              },
              'on_result_diagnostics',
              'default',
            },
          }
        end,
        condition = {
          filter_type = { 'odin' },
        },
      }

      vim.keymap.set('n', 'B', '<CMD>OverseerRun odin_run_debug<CR>')
      vim.api.nvim_set_keymap('n', '<F7>', ':OverseerClose<CR>', { noremap = true, silent = true })

      vim.api.nvim_create_user_command('WatchRun', function()
        overseer.run_template({ name = 'Odin Build (Debug)' }, function(task)
          if task then
            task:add_component { 'restart_on_save', paths = { vim.fn.expand '%:p' } }
            local main_win = vim.api.nvim_get_current_win()
            overseer.run_action(task, 'open vsplit')
            vim.api.nvim_set_current_win(main_win)
          else
            vim.notify('WatchRun not supported for filetype ' .. vim.bo.filetype, vim.log.levels.ERROR)
          end
        end)
      end, {})
    end,
  },
  {
    'miversen33/sunglasses.nvim',
    event = 'UIEnter',
    opts = {
      filter_type = 'SHADE',
      filter_percent = 0.2,
    },
  },
}
