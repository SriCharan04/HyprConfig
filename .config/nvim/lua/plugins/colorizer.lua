return {
  "catgoose/nvim-colorizer.lua",
  -- load after a buffer is read so termguicolors is set
  event = "BufReadPost",
  config = function()
    -- 1) Enable true-colour support
    vim.opt.termguicolors = true

    -- 2) Global setup: highlight all color formats in every filetype
    require("colorizer").setup({ "*" }, {
      -- Hex codes
      RGB      = true,   -- #RGB
      RRGGBB   = true,   -- #RRGGBB
      RRGGBBAA = true,   -- #RRGGBBAA (8-digit RGBA)

      -- Named colors
      names    = true,   -- “red”, “blue”, etc.

      -- CSS shorthand & named colors
      css      = true,   -- enable CSS features
      css_fn   = true,   -- enable rgb(), rgba(), hsl(), hsla()

      -- Explicit parsing of CSS functions
      rgb_fn   = true,   -- rgb() and rgba()
      hsl_fn   = true,   -- hsl() and hsla()

      -- Display mode: paint the background behind the color code
      mode     = "background",
    })

    -- 3) User command to attach Colorizer on demand
    vim.api.nvim_create_user_command("Colorise", function()
      require("colorizer").attach_to_buffer(0, {
        RGB      = true,
        RRGGBB   = true,
        RRGGBBAA = true,
        names    = true,
        css      = true,
        css_fn   = true,
        rgb_fn   = true,
        hsl_fn   = true,
        mode     = "background",
      })
    end, {
      desc = "Attach nvim-colorizer.lua to current buffer"
    })
  end,
}
