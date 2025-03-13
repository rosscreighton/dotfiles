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

--[[ Install & Configure plugins ]]

local plugins = {
  { -- Turn off search highlights when you're done searching (similar to manually typing :noh
    'romainl/vim-cool',
  },
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
      local miniIcons = require("mini.icons")
      miniIcons.setup()
    end
  },
  { -- Syntax highlighting
    "nvim-treesitter/nvim-treesitter", 
    event = { "BufReadPre", "BufNewFile" }, 
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag", 
    },
    config = function()
      local treeSitterConfigs = require("nvim-treesitter.configs") -- Autoclose frontend tags (html, jsx, etc.)
      treeSitterConfigs.setup({
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },  
        autotag = { enable = true }, -- Autoclose frontend tags (html, jsx, etc.)
        ensure_installed = {
          "bash", 
          "css",
          "dockerfile",
          "git_config",
          "git_rebase",
          "gitcommit",
          "gitignore",
          "graphql",
          "helm",
          "html",
          "html", 
          "javascript", 
          "json",
          "lua", 
          "markdown",
          "python", 
          "sql", 
          "terraform",
          "tmux",
          "typescript", 
          "vim", 
          "vimdoc"
        },
      })
    end
  },
  { -- Fuzzy finder
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      require("telescope").setup(
        {
          defaults = {
            path_display = { "smart" },
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
            },
            pickers = {
              buffers = { sort_mru = true},
              oldfiles = { sort_mru = true}
            }
          }
        }
      )
      local telescopeBuiltins = require("telescope.builtin")
      vim.keymap.set("n", "<leader>o", telescopeBuiltins.find_files, {}) -- Fuzzy open file
      vim.keymap.set("n", "<leader>s", telescopeBuiltins.buffers, {}) -- Switch buffers
      vim.keymap.set("n", "<leader>r", telescopeBuiltins.oldfiles, {}) -- Switch recent files
      vim.keymap.set("n", "<leader>gl", telescopeBuiltins.live_grep, {}) -- Live grep input string in cwd
      vim.keymap.set("n", "<leader>gu", telescopeBuiltins.grep_string, {}) -- Grep string under cursor in cwd
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
            local miniIcons = require("mini.icons")
            -- bufferline needs `get_icon_by_filetype` behavior from 'nvim-web-devicons'
            miniIcons.mock_nvim_web_devicons()
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
      local colors = {
        bgLightGray = '#504945',
        textWhite    = '#ddc7a1',
        bgMedGray = '#32302f',
      }

      local custom_theme = {
        normal = {
          a = { fg = colors.textWhite, bg = colors.bgLightGray },
          b = { fg = colors.textWhite, bg = colors.bgMedGray },
          c = { fg = colors.textWhite, bg = colors.bgMedGray },
        },
      }

      local function get_lsp_client_names()
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if #clients == 0 then return "No LSP" end
        local client_names = {}
        for _, client in ipairs(clients) do
          table.insert(client_names, client.name)
        end
        return table.concat(client_names, ",")
      end

      local function get_file_location_and_progress()
          local line = vim.fn.line('.')
          local col = vim.fn.col('.')
          local total_lines = vim.fn.line('$')
          return string.format('%d/%d : %d', line, total_lines, col)
      end

      require("lualine").setup({
        options = {
          theme = custom_theme,
          component_separators = '',
        },
        sections = {
          lualine_a = {
            {
              'filename', 
              path = 3,  -- Show full absolute path
              file_status = false,
            }
          },
          lualine_b = {'branch'},
          lualine_c = {'diff'},
          lualine_x = {'filetype'},
          lualine_y = { 
            { get_lsp_client_names, icons_enabled = false},
          },
          lualine_z = { 
            { 'mode' },
            { get_file_location_and_progress }
          }
        }
      })
    end
  },
  { -- Install language severs, linters, fixers
    "williamboman/mason.nvim",
    dependencies = { 
        "neovim/nvim-lspconfig",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",
          "tailwindcss",
          "jinja_lsp",
          "docker_compose_language_service",
          "dockerls",
          "graphql",
          "superhtml",
          "ts_ls", -- TypeScript & JS
          "cssls",
          "lua_ls",
          "jsonls",
          "remark_ls", -- Markdown
          "nginx_language_server",
          "vacuum", -- OpenAPI
          "pyright", -- Python
          "ruff", -- Python linter & formatter
          "ruby_lsp",
          "rust_analyzer",
          "sqlls",
          "svelte",
          "terraformls",
          "lemminx", -- XML
        }
      })
    end
  },
  { -- Autocompletion
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets', -- provides snippets based on file type
    version = '*',
    config = function()
      require("blink.cmp").setup({
        fuzzy = { implementation = "rust" },
        appearance = {
          nerd_font_variant = 'mono'
        },
        signature = { enabled = true },
        keymap = {
          -- See docs for rest of keymaps:
          -- https://cmp.saghen.dev/configuration/keymap.html
          preset = 'super-tab',
          ['<C-c>'] = { 'hide', 'fallback' }, -- Close completion
          ['<C-k>'] = { 'select_prev', 'fallback_to_mappings' },
          ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },
          ['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' }, -- Show/hide signature when autocompleting a funtion call
        }
      })
    end
  }, 
  { -- LSP configuration
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" }, 
    config = function()
      local blink_lsp_capabilities = require('blink.cmp').get_lsp_capabilities()
      require("mason-lspconfig").setup_handlers({
        -- Auto configure each language server installed by Mason
        
        -- The first entry (without a key) is the default handler and will be called for
        -- each installed server that doesn't have a dedicated handler.
        function (server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup({ 
             -- Inform the langauge server of the autocompletion capabilities we have via blink
              capabilities = blink_lsp_capabilities
            })
        end,

        --[[ 
        We can also provide a dedicated handler for specific servers. For example, a 
        handler override for the `rust_analyzer`: 

        ["rust_analyzer"] = function ()
          require("rust-tools").setup({})
        end

        ]]
        ["lua_ls"] = function ()
          require("lspconfig")["lua_ls"].setup({
            capabilities = blink_lsp_capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  -- Make it the language server doesn't think the the global variable `vim`
                  -- is an error when working neovim config in init.lua
                  globals = { "vim" }
                }
              }
            }
          }) 
        end
      })
    end
  }
}

local opts = {}

require("lazy").setup(plugins, opts)

