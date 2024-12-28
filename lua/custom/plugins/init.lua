-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'Civitasv/cmake-tools.nvim',
    opts = {
      cmake_build_directory = function()
        local osys = require 'cmake-tools.osys'
        if osys.iswin32 then
          return 'build\\${variant:buildType}'
        end
        return 'build/${variant:buildType}'
      end,

      cmake_soft_link_compile_commands = true, -- this will automatically make a soft link from compile commands file to project root dir
      cmake_compile_commands_from_lsp = true,

      cmake_regenerate_on_save = true, -- auto generate when save CMakeLists.txt
      cmake_generate_options = { '-DCMAKE_EXPORT_COMPILE_COMMANDS=1' }, -- this will be passed when invoke `CMakeGenerate`

      cmake_dap_configuration = { -- debug settings for cmake
        name = 'cpp',
        type = 'codelldb',
        request = 'launch',
        stopOnEntry = false,
        runInTerminal = true,
        console = 'integratedTerminal',
      },
    },
  },
  {
    'Exafunction/codeium.vim',
    event = 'BufEnter',
  },
}
