require('onedark').setup(
  {
    transparent = true,
  }
)

require('lualine').setup {
  options = {
    theme = 'tokyonight',
  },
  tabline = {
    lualine_a = {'buffers'},
  }
}
