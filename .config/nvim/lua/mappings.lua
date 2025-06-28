local keymap = vim.keymap
local uv = vim.uv

-- in your init.lua / plugin loader
vim.api.nvim_create_user_command("RegenPalette", function()
  -- 1) regenerate the scheme file
  --local gen = vim.fn.stdpath("config") .. "/colors/gencolors.lua"
  --local out = vim.fn.system({ "lua", gen })
  --if vim.v.shell_error ~= 0 then
  --  vim.notify("Palette generation failed:\n" .. out, vim.log.levels.ERROR)
  --  return
  --end

  -- 2) clear existing highlights and reset syntax
  vim.cmd("highlight clear")
  vim.cmd("syntax reset")

  -- 3) ensure GUI colors are on
  vim.o.termguicolors = true

  -- 4) load the updated colorscheme
  vim.cmd("colorscheme EnActors")

  vim.notify("Wallpaper palette reloaded", vim.log.levels.INFO)
end, {
  desc = "Regenerate & immediately reload the wallpaper-based colorscheme",
})

-- Automaticcally detect color susing colorisers.
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*.rasi',
  callback = function()
    require('colorizer').attach_to_buffer(0, {
      RGB = true, RRGGBB = true, names = true,
      RRGGBBAA = true, rgb_fn = true, hsl_fn = true,
      css = true, css_fn = true, mode = 'background'
    })
  end,
})

--Call the wallpaper specific colors for Neovim
vim.keymap.set("n", "<leader>rp", "<cmd>RegenPalette<CR>", { desc = "Regen wallpaper palette" })

-- Save key strokes (now we do not need to press shift to enter command mode).
keymap.set({ "n", "x" }, ";", ":")

-- Turn the word under cursor to upper case
keymap.set("i", "<c-u>", "<Esc>viwUea")

-- Turn the current word into title case
keymap.set("i", "<c-t>", "<Esc>b~lea")

-- Insert a blank line below or above current line (do not move the cursor),
-- see https://stackoverflow.com/a/16136133/6064933
keymap.set("n", "<space>o", "printf('m`%so<ESC>``', v:count1)", {
  expr = true,
  desc = "insert line below",
})

keymap.set("n", "<space>O", "printf('m`%sO<ESC>``', v:count1)", {
  expr = true,
  desc = "insert line above",
})

-- Move the cursor based on physical lines, not the actual lines.
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap.set("n", "^", "g^")
keymap.set("n", "0", "g0")

-- Continuous visual shifting (does not exit Visual mode), `gv` means
-- to reselect previous visual area, see https://superuser.com/q/310417/736190
keymap.set("x", "<", "<gv")
keymap.set("x", ">", ">gv")

-- Go to start or end of line easier
keymap.set({ "n", "x" }, "H", "^")
keymap.set({ "n", "x" }, "L", "g_")

-- Reselect the text that has just been pasted, see also https://stackoverflow.com/a/4317090/6064933.
keymap.set("n", "<leader>v", "printf('`[%s`]', getregtype()[0])", {
  expr = true,
  desc = "reselect last pasted area",
})

-- Change current working directory locally and print cwd after that,
-- see https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
keymap.set("n", "<leader>cd", "<cmd>lcd %:p:h<cr><cmd>pwd<cr>", { desc = "change cwd" })

-- Toggle spell checking
keymap.set("n", "<F11>", "<cmd>set spell!<cr>", { desc = "toggle spell" })
keymap.set("i", "<F11>", "<c-o><cmd>set spell!<cr>", { desc = "toggle spell" })

-- Move current line up and down
keymap.set("n", "<A-k>", '<cmd>call utils#SwitchLine(line("."), "up")<cr>', { desc = "move line up" })
keymap.set("n", "<A-j>", '<cmd>call utils#SwitchLine(line("."), "down")<cr>', { desc = "move line down" })

-- Switch windows
keymap.set("n", "<left>", "<c-w>h")
keymap.set("n", "<Right>", "<C-W>l")
keymap.set("n", "<Up>", "<C-W>k")
keymap.set("n", "<Down>", "<C-W>j")

-- Do not move my cursor when joining lines.
keymap.set("n", "J", function()
  vim.cmd([[
      normal! mzJ`z
      delmarks z
    ]])
end, {
  desc = "join lines without moving cursor",
})

keymap.set("n", "gJ", function()
  -- we must use `normal!`, otherwise it will trigger recursive mapping
  vim.cmd([[
      normal! mzgJ`z
      delmarks z
    ]])
end, {
  desc = "join lines without moving cursor",
})

-- insert semicolon in the end
keymap.set("i", "<A-;>", "<Esc>miA;<Esc>`ii")

-- Go to the beginning and end of current line in insert mode quickly
keymap.set("i", "<C-A>", "<HOME>")
keymap.set("i", "<C-E>", "<END>")

-- Go to beginning of command in command-line mode
keymap.set("c", "<C-A>", "<HOME>")
