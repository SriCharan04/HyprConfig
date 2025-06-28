-- ~/.config/nvim/lua/plugins/colorizer.lua
return {
  'norcalli/nvim-colorizer.lua',
  -- load when you open any file (or restrict to BufReadPost)
  event = 'BufReadPost',
  -- ensure rasi is included
  ft = { '*', 'rasi' },
  opts = {
    RGB      = true,   -- #RGB
    RRGGBB   = true,   -- #RRGGBB
    names    = true,   -- "Blue", etc.
    RRGGBBAA = true,   -- #RRGGBBAA
    rgb_fn   = true,   -- rgb(), rgba()
    hsl_fn   = true,   -- hsl(), hsla()
    css      = true,   -- enable css shorthand (#rrggbb etc)
    css_fn   = true,   -- enable css functions
    mode     = 'background',
  },
  config = function(_, opts)
    -- setup for *all* filetypes plus our rasi
    require('colorizer').setup({ '*' , 'rasi' }, opts)
  end,
}
