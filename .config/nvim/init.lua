-- This is my personal Nvim configuration supporting Mac, Linux and Windows, with various plugins configured.
-- This configuration evolves as I learn more about Nvim and become more proficient in using Nvim.
-- Since it is very long (more than 1000 lines!), you should read it carefully and take only the settings that suit you.
-- I would not recommend cloning this repo and replace your own config. Good configurations are personal,
-- built over time with a lot of polish.
--
-- Author: Jiedong Hao
-- Email: jdhao@hotmail.com
-- Blog: https://jdhao.github.io/
-- GitHub: https://github.com/jdhao
-- StackOverflow: https://stackoverflow.com/users/6064933/jdhao
vim.loader.enable()

local utils = require("utils")

local config_dir = vim.fn.stdpath("config")

---@cast config_dir string
require("config")

-- setting options in nvim
--vim.cmd("source " .. vim.fs.joinpath(config_dir, "viml_conf/options.vim"))
--lsp settings
--require("lsp")
-- snippets for various programming languages
--require("snippets")          
-- all the user-defined mappings
require("mappings")
-- all the plugins installed and their configurations
-- vim.cmd("source " .. vim.fs.joinpath(config_dir, "viml_conf/plugins.vim"))

-- diagnostic related config
require("diagnose")

-- colorscheme settings
local function apply_dynamic_colorscheme()
    local colorscheme_path = vim.fn.stdpath('config') .. '/colors/EnActors.lua'
    
    -- Check if the generated colorscheme exists
    if vim.fn.filereadable(colorscheme_path) == 1 then
        -- Load and apply the colorscheme
        local ok, colorscheme = pcall(require, 'colors.EnActors')
        if ok and colorscheme.setup then
            colorscheme.setup()
        else
            vim.cmd.colorscheme('default')
        end
    else
        -- Fallback to default colorscheme
        vim.cmd.colorscheme('default')
    end
end

-- Apply the colorscheme
apply_dynamic_colorscheme()

-- Set up Lazy
local lazypath = vim.fn.stdpath("config") .. "/plugins/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\\n", "ErrorMsg" }, { out, "WarningMsg" }, { "\\nPress any key to exit..." } }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

local plugins = "plugins"

local opts = {
	defaults = {
		lazy = true,
	},
	rtp = {
		disabled_plugins = {
			"gzip",
			"matchit",
			"matchparen",
			"netrw",
			"netrwPlugin",
			"tarPlugin",
			"tohtml",
			"tutor",
			"zipPlugin",
		},
	},
	change_detection = {
		notify = true,
	},
}

require("lazy").setup(plugins, opts)
