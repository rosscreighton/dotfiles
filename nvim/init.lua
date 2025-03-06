--[[ Vim settings ]]

vim.g.mapleader = " "
vim.o.number = true
vim.o.wrap = false
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.copyindent = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.preserveindent = true
vim.o.cursorcolumn = true
vim.o.cursorline = true
vim.o.incsearch = true
vim.o.backspace = "eol,indent,start"
vim.o.scrolloff=5
vim.o.sidescrolloff=5
vim.o.display = vim.o.display .. ",lastline"
vim.o.termguicolors = true


--[[ Key mappings for builtin vim stuff ]]

vim.keymap.set("n", "<C-h>", ":bp!<CR>") -- Previous buffer
vim.keymap.set("n", "<C-l>", ":bn!<CR>") -- Next buffer
vim.keymap.set("n", "<leader>w", ":w<CR>") -- Write
vim.keymap.set("n", "<leader>q", ":wq<CR>") -- Save and quite
vim.keymap.set("n", "<leader>c", ":w<CR>:bd<CR>") -- Save and close current buffer
vim.keymap.set("n", "<leader>bd", ":bd<CR>") -- Close current buffer
vim.keymap.set("n", "<leader>ba", ":bufdo bd<CR>") -- Close all buffers
vim.keymap.set("n", "<leader>ik", "O<Esc>j") -- Insert new line above cursor w/o entering insert mode
vim.keymap.set("n", "<leader>ij", "o<Esc>k") -- Insert new line below cursor w/o entering insert mode
vim.keymap.set("n", "<leader><Space>", "i<Space><Esc>la<Space><Esc>h") -- Insert spaces around cursor
vim.keymap.set("n", "<leader>n", ":cn<CR>") -- Next entry in quickfix list
vim.keymap.set("n", "<leader>p", ":cp<CR>") -- Previous entry in quickfix list
vim.keymap.set("n", "<leader>j", "<C-w>j") -- Easy window traversal (down)
vim.keymap.set("n", "<leader>k", "<C-w>k") -- Easy window traversal (up)
vim.keymap.set("n", "<leader>h", "<C-w>h") -- Easy window traversal (left)
vim.keymap.set("n", "<leader>l", "<C-w>l") -- Easy window traversal (right)
vim.keymap.set("n", "<leader>x", "<C-w>q") -- Close current window
vim.keymap.set("n", "<leader>d", "Oimport ipdb; ipdb.set_trace() :w<CR>") -- Insert ipdb debugger
vim.keymap.set("i", "<C-g>", "<Left>") -- Move cursor left while in insert mode
vim.keymap.set("i", "<C-j>", "<Down>") -- Move cursor down while in insert mode
vim.keymap.set("i", "<C-k>", "<Up>") -- Move cursor up while in insert mode
vim.keymap.set("i", "<C-l>", "<Right>") -- Move cursor right while in insert mode
--[[ Wrap each line in quotes and follow with comma. Intended use: prepare lines
in a text file for copy and paste into a list of strings in a scripting
language.]]
vim.keymap.set("n", "<leader>]", ':%s/^/"/<CR>:%s/$/",/<CR>:w<CR>')

--[[ Bootstrap lazy.nvim ]]

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

--[[ Setup lazy.nvim ]]

local plugins = {
  { -- Colorscheme
    'sainnhe/gruvbox-material', 
    priority = 1000,
    config = function()
	      vim.g.gruvbox_material_background = 'hard'
	      vim.g.gruvbox_material_foreground = 'material'
        vim.g.gruvbox_material_enable_italic = true
        vim.cmd.colorscheme('gruvbox-material')
    end
  },
  { -- Icons used by mini.files, bufferline.nvim, etc.
    'echasnovski/mini.icons',
    version = '*',
    config = function()
      miniIcons = require("mini.icons")
      miniIcons.setup()
      -- bufferline needs `get_icon_by_filetype` behavior from 'nvim-web-devicons'
      miniIcons.mock_nvim_web_devicons()
    end
  },
  { -- Syntax highlighting
    "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate",
    config = function()
      local treeSitterConfigs = require("nvim-treesitter.configs")
      treeSitterConfigs.setup({
        ensure_installed = {
          "bash", 
          "css",
          "dockerfile",
          "git_config",
          "git_rebase",
          "gitcommit",
          "gitignore",
          "html",
          "html", 
          "javascript", 
          "json",
          "lua", 
          "markdown",
          "python", 
          "sql", 
          "terraform",
          "typescript", 
          "vim", 
          "vimdoc"
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },  
      })
    end
  },
  { -- Fuzzy finder
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require("telescope").setup(
	{
          defaults = {
            mappings = {
	            i = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
	            } 
            },
            file_ignore_patterns = {
              "node_modules/",
              ".git/",
              "__pycache__/"
            }
	  }
        }
      )
      local telescopeBuiltins = require("telescope.builtin")
      vim.keymap.set("n", "<leader>o", telescopeBuiltins.find_files, {})
      vim.keymap.set("n", "<leader>s", telescopeBuiltins.buffers, {})
      vim.keymap.set("n", "<leader>r", telescopeBuiltins.oldfiles, {})
    end
  },
  { -- File explorer
    'echasnovski/mini.files',
    version = '*',
    config = function()
      local function toggle_minifiles()
        local miniFiles = require('mini.files')
        if not miniFiles.close() then 
          miniFiles.open() 
          miniFiles.reset()
        end
      end

      local miniFiles = require('mini.files')
      miniFiles.setup({
        mappings = {
          go_in_plus = "<CR>",
        },
        -- Deleted files moved to :echo stdpath('data') + '/mini.files/trash/'
        options = {
          permanent_delete = false,
        }
      })

      vim.keymap.set("n", '<leader>\\', toggle_minifiles, {})
    end
  },
  { -- Buffer tabline
    'akinsho/bufferline.nvim', 
    version = "*",
    config = function()
      require("bufferline").setup({
        options = {
          separator_style = "slant",
          show_buffer_close_icons = false,
          get_element_icon = function(element)
            -- element consists of {filetype: string, path: string, extension: string, directory: string}
            miniIcons = require("mini.icons")
            local icon, hl = miniIcons.get("filetype", element.filetype)
            return icon, hl
          end,
        }
      })
    end
  }, 
  { -- Status line
    'nvim-lualine/lualine.nvim',
    config = function()
      require("lualine").setup({
        sections = {
          lualine_a = {'branch'},
          lualine_b = {'diff'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}  
        }
      })
    end
  }
}

local opts = {}

require("lazy").setup(plugins, opts)

