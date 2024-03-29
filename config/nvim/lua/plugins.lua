return require('packer').startup(function(use)
  -- Plugin manager
  use 'wbthomason/packer.nvim'

  use {
      'nvim-telescope/telescope.nvim', tag = '0.1.1',
      requires = { {'nvim-lua/plenary.nvim'} },
      config = function() require('plugins.telescope') end,
  }
  -- Git shit
  use 'tpope/vim-fugitive'

  -- LSP
  use {
    'neoclide/coc.nvim', branch = 'master', run = 'yarn install --forzen-lockfile',
  }
  use {
    'suoto/hdlcc'
  }

  use 'justinmk/vim-syntax-extra'

  -- Theme
  use 'ful1e5/onedark.nvim'
  use 'folke/tokyonight.nvim'
  use 'antiagainst/vim-tablegen'
  use 'nvim-lualine/lualine.nvim'
  -- use {
  --   'lukoshkin/trailing-whitespace',
  --   config = function ()
  --     require'trailing-whitespace'.setup {
  --       patterns = { '\\s\\+$' },
  --       palette = { markdown = 'RosyBrown' },
  --       default_color = 'PaleVioletRed',
  --   }
  --   end
  -- }
end)
