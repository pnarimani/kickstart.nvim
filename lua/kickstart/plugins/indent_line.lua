return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      indent = { highlight = {
        'CursorColumn',
        'Whitespace',
      }, char = '' },
      whitespace = {
        highlight = {
          'CursorColumn',
          'Whitespace',
        },
        remove_blankline_trail = false,
      },
      scope = { enabled = false },
    },
  },
}
