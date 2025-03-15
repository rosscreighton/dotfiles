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
vim.o.scrolloff = 5
vim.o.sidescrolloff = 5
vim.o.display = vim.o.display .. ",lastline"
vim.o.termguicolors = true
vim.o.undofile = true -- Enable persistent undo
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undodir")
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
--[[
Synchronizes the unnamed register (which is used for basic yank, delete, and put 
operations) with the system clipboard. Yanks/deletes in nvim will be copied to
system clipboard. Pasting nvim using the p command will paste from system
clipboard. ]]
vim.opt.clipboard = "unnamedplus"

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

--[[ Customize diagnostics ]]

-- Customize diagnostic signs in the sign column

local signs = { Error = "", Warn = "", Hint = "󰋗", Info = "" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Customize diagnostic virtual text displayed to the right of code lines in the buffer
vim.diagnostic.config({
	virtual_text = {
		source = "always",
		prefix = "",
	},
	severity_sort = true,
	float = {
		source = "always", -- Or "if_many"
	},
})

-- Keymap to turn diagnostics on and off globally
local function toggle_diagnostics()
	if vim.diagnostic.is_enabled(nil) then
		vim.diagnostic.disable()
	else
		vim.diagnostic.enable()
	end
end

vim.keymap.set("n", "<leader>td", toggle_diagnostics, { desc = "Toggle diagnostics" })

--[[ Global variables used across plugins ]]

vim.g.nvim_lint_enabled = true
vim.g.conform_formatting_enabled = true

--[[ Install & Configure plugins ]]

LazyPlugins = {
	{ -- Turn off search highlights when you're done searching (similar to manually typing :noh
		"romainl/vim-cool",
	},
	{ -- Colorscheme
		"sainnhe/gruvbox-material",
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_foreground = "material"
			vim.g.gruvbox_material_enable_italic = true
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{ -- Icons used by mini.files, bufferline.nvim, etc.
		"echasnovski/mini.icons",
		version = "*",
		config = function()
			local miniIcons = require("mini.icons")
			miniIcons.setup()
		end,
	},
	{ -- Syntax highlighting
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		config = function()
			local treeSitterConfigs = require("nvim-treesitter.configs") -- Autoclose frontend tags (html, jsx, etc.)
			treeSitterConfigs.setup({
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
				auto_install = true,
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
					"vimdoc",
				},
			})
		end,
	},
	{ -- Fuzzy finder
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					path_display = { "smart" },
					mappings = {
						i = {
							["<C-j>"] = "move_selection_next",
							["<C-k>"] = "move_selection_previous",
						},
					},
					file_ignore_patterns = {
						"node_modules/",
						".git/",
						"__pycache__/",
					},
					pickers = {
						buffers = { sort_mru = true },
						oldfiles = { sort_mru = true },
					},
				},
			})
			local telescopeBuiltins = require("telescope.builtin")
			vim.keymap.set("n", "<leader>o", telescopeBuiltins.find_files, {}) -- Fuzzy open file
			vim.keymap.set("n", "<leader>s", telescopeBuiltins.buffers, {}) -- Switch buffers
			vim.keymap.set("n", "<leader>r", telescopeBuiltins.oldfiles, {}) -- Switch recent files
			vim.keymap.set("n", "<leader>gl", telescopeBuiltins.live_grep, {}) -- Live grep input string in cwd
			vim.keymap.set("n", "<leader>gu", telescopeBuiltins.grep_string, {}) -- Grep string under cursor in cwd
		end,
	},
	{ -- File explorer
		"echasnovski/mini.files",
		version = "*",
		config = function()
			local function toggle_minifiles()
				local miniFiles = require("mini.files")
				if not miniFiles.close() then
					miniFiles.open()
					miniFiles.reset()
				end
			end

			local miniFiles = require("mini.files")
			miniFiles.setup({
				mappings = {
					go_in_plus = "<CR>",
				},
				-- Deleted files moved to :echo stdpath('data') + '/mini.files/trash/'
				options = {
					permanent_delete = false,
				},
			})

			vim.keymap.set("n", "<leader>\\", toggle_minifiles, {})
		end,
	},
	{ -- Buffer tabline
		"akinsho/bufferline.nvim",
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
				},
			})
		end,
	},
	{ -- Status line
		"nvim-lualine/lualine.nvim",
		dependencies = { "stevearc/conform.nvim" },
		config = function()
			local colors = {
				bgLightGray = "#504945",
				textWhite = "#ddc7a1",
				bgMedGray = "#32302f",
			}

			local custom_theme = {
				normal = {
					a = { fg = colors.textWhite, bg = colors.bgLightGray },
					b = { fg = colors.textWhite, bg = colors.bgMedGray },
					c = { fg = colors.textWhite, bg = colors.bgMedGray },
				},
			}

			local get_diagnostics_status = function()
				if vim.diagnostic.is_enabled(nil) then
					return ""
				else
					return "󰜺"
				end
			end
			local get_linters = function()
				local linters = require("lint")._resolve_linter_by_ft(vim.bo.filetype)
				if not vim.g.nvim_lint_enabled then
					return "󰜺"
				elseif #linters == 0 then
					return ""
				end
				return table.concat(linters, ", ")
			end

			local function get_formatters()
				local formatters = require("conform").list_formatters_for_buffer(0)
				if not vim.g.conform_formatting_enabled then
					return "󰜺"
				elseif #formatters == 0 then
					return ""
				else
					return table.concat(formatters, ",")
				end
			end

			local function get_lsp_client_names()
				local clients = vim.lsp.get_active_clients({ bufnr = 0 })
				if #clients == 0 then
					return ""
				end
				local client_names = {}
				for _, client in ipairs(clients) do
					table.insert(client_names, client.name)
				end
				return table.concat(client_names, ",")
			end

			local function get_file_location_and_progress()
				local line = vim.fn.line(".")
				local col = vim.fn.col(".")
				local total_lines = vim.fn.line("$")
				return string.format("%d/%d:%d", line, total_lines, col)
			end

			require("lualine").setup({
				options = {
					theme = custom_theme,
					component_separators = "",
				},
				sections = {
					lualine_a = {
						{
							"filename",
							path = 1, -- Show full path from home dir
							file_status = false,
						},
					},
					lualine_b = { "branch" },
					lualine_c = { "diff" },
					lualine_x = {
						{ "filetype" },
					},
					lualine_y = {
						{ get_lsp_client_names, icon = "LSP:" },
						{ get_formatters, icon = "FMT:" },
						{ get_linters, icon = "LNT:" },
						{ get_diagnostics_status, icon = "DXG:" },
					},
					lualine_z = {
						{ get_file_location_and_progress },
					},
				},
			})
		end,
	},
	{ -- Install language severs, linters, formatters
		"williamboman/mason.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("mason").setup()

			-- Language servers
			-- mason-lsqpconfig adds convenient features for mason packages that are langauge servers
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"cssls",
					"docker_compose_language_service",
					"dockerls",
					"graphql",
					"jinja_lsp",
					"jsonls",
					"lemminx", -- XML
					"lua_ls",
					"nginx_language_server",
					"pyright", -- Python
					"remark_ls", -- Markdown
					"ruby_lsp",
					"rust_analyzer",
					"sqlls",
					"superhtml",
					"svelte",
					"tailwindcss",
					"terraformls",
					"ts_ls", -- TypeScript & JS
					"vacuum", -- OpenAPI
				},
			})

			-- Linters and formattters
			-- mason-lsqpconfig adds convenience features for mason packages that are not langauge servers
			require("mason-tool-installer").setup({
				ensure_installed = {
					"eslint_d", -- JS/TS Linter
					"jsonlint",
					"prettier", -- Everything frontend formatter
					"rubocop",
					"ruff", -- Python linter & formatter
					"shellcheck",
					"shfmt", -- Bash, shell
					"sleek", -- SQL formatter
					"sqlfluff", -- SQL Linter
					"stylua",
					"xmlformatter",
					"tflint",
				},
			})
		end,
	},
	{ -- Formatters
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					bash = { "shfmt" },
					css = { "prettier" },
					graphql = { "prettier" },
					html = { "prettier" },
					javascript = { "prettier" },
					javascriptreact = { "prettier" },
					json = { "prettier" },
					lua = { "stylua" },
					markdown = { "prettier" },
					python = { "ruff_format" },
					ruby = { "rubocop" },
					sh = { "shfmt" },
					shell = { "shfmt" },
					sql = { "sleek" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
					xml = { "xmlformatter" },
					yaml = { "prettier" },
				},
				default_format_opts = {
					-- Fallback on the LSP for formatting if no formatter is available
					lsp_format = "fallback",
				},
				format_on_save = function()
					if vim.g.conform_formatting_enabled then
						return {
							timeout_ms = 500, -- How long to block for formatting
							lsp_format = "fallback",
						}
					else
						return
					end
				end,
				-- Set the log level. Use `:ConformInfo` to see the location of the log file.
				log_level = vim.log.levels.ERROR,
				-- Conform will notify  when a formatter errors
				notify_on_error = true,
			})

			local function toggle_formatting()
				vim.g.conform_formatting_enabled = not vim.g.conform_formatting_enabled
			end

			vim.keymap.set("n", "<leader>tf", toggle_formatting, {})
		end,
	},
	{ -- Linting
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				bash = { "shellcheck" },
				javacriptreact = { "eslint_d" },
				javascript = { "eslint_d" },
				python = { "ruff" },
				sh = { "shellcheck" },
				shell = { "shellcheck" },
				sql = { "sqlfluff" },
				terraform = { "tflint" },
				typescript = { "eslint_d" },
				typescriptreact = { "eslint_d" },
			}

			local function toggle_linting()
				vim.g.nvim_lint_enabled = not vim.g.nvim_lint_enabled
				if vim.g.nvim_lint_enabled then
					require("lint").try_lint()
				else
					local linter_name = lint._resolve_linter_by_ft(vim.bo.filetype)[1]
					if linter_name then
						local linter_namespace = lint.get_namespace(linter_name)
						vim.diagnostic.reset(linter_namespace)
					end
				end
			end

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				callback = function()
					if vim.g.nvim_lint_enabled then
						lint.try_lint()
					end
				end,
			})

			vim.keymap.set("n", "<leader>tl", toggle_linting, {})
		end,
	},
	{ -- Autocompletion
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets", -- provides snippets based on file type
		version = "*",
		config = function()
			require("blink.cmp").setup({
				fuzzy = { implementation = "rust" },
				appearance = {
					nerd_font_variant = "mono",
				},
				signature = { enabled = true },
				completion = {
					documentation = { auto_show = true },
				},
				keymap = {
					-- See docs for rest of keymaps:
					-- https://cmp.saghen.dev/configuration/keymap.html
					preset = "super-tab",
					["<C-c>"] = { "hide", "fallback" }, -- Close completion
					["<C-k>"] = { "select_prev", "fallback_to_mappings" },
					["<C-j>"] = { "select_next", "fallback_to_mappings" },
					["<C-s>"] = { "show_signature", "hide_signature", "fallback" }, -- Show/hide signature when autocompleting a funtion call
				},
			})
		end,
	},
	{ -- LSP configuration
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local blink_lsp_capabilities = require("blink.cmp").get_lsp_capabilities()
			require("mason-lspconfig").setup_handlers({
				-- Auto configure each language server installed by Mason

				-- The first entry (without a key) is the default handler and will be called for
				-- each installed server that doesn't have a dedicated handler.
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						-- Inform the langauge server of the autocompletion capabilities we have via blink
						capabilities = blink_lsp_capabilities,
					})
				end,

				--[[ 
        We can also provide a dedicated handler for specific servers. For example, a 
        handler override for the `rust_analyzer`: 

        ["rust_analyzer"] = function ()
          require("rust-tools").setup({})
        end

        ]]

				["ruff"] = function() end, -- Disable ruff as a language server. (We use as linter/formatter)
				["lua_ls"] = function()
					require("lspconfig")["lua_ls"].setup({
						capabilities = blink_lsp_capabilities,
						settings = {
							Lua = {
								diagnostics = {
									-- Make it so the language server doesn't think the the global variable
									-- `vim` is an error when working on neovim config in init.lua
									globals = { "vim" },
								},
							},
						},
					})
				end,
				["sqlls"] = function()
					require("lspconfig")["sqlls"].setup({
						capabilities = blink_lsp_capabilities,
						--[[ sqlls will fail to start if it can't determine a root directory for the 
            project. The is no obvious root directory in a sql project bc sql doesn't have 
            modules, packages, paths, etc., so it is difficult for sqlls to decide on a 
            project root with the default configuration, which relies on the existence 
            of a `.sqllsrc.json` file (https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/sqlls.lua#L4)
            Here we set the root dir to the cwd so that sqlls always can always have a 
            project root. ]]
						root_dir = function()
							return vim.loop.cwd()
						end,
					})
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf, silent = true }

					-- set keybinds
					opts.desc = "Show documentation for what is under cursor"
					vim.keymap.set("n", "gk", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

					opts.desc = "Show LSP definitions"
					vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

					opts.desc = "Go to declaration"
					vim.keymap.set("n", "gv", vim.lsp.buf.declaration, opts) -- go to declaration

					opts.desc = "Show LSP references"
					vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

					opts.desc = "Show LSP Iplementations"
					vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

					opts.desc = "Show LSP type definitions"
					vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

					opts.desc = "Show diagnostics for current line in popup"
					vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

					opts.desc = "Smart rename"
					vim.keymap.set("n", "<leader>mvs", vim.lsp.buf.rename, opts) -- smart rename
				end,
			})
		end,
	},
	{ -- Autoclose pairs and tags
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		dependencies = { "windwp/nvim-ts-autotag" },
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true,
			})
			require("nvim-ts-autotag").setup({
				opts = {
					-- Defaults
					enable_close = true, -- Auto close tags
					enable_rename = true, -- Auto rename pairs of tags
					enable_close_on_slash = true, -- Auto close on trailing </
				},
			})
		end,
	},
	{ -- Comments helper
		"numToStr/Comment.nvim",
		version = "*",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		config = function()
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})
			require("Comment").setup({
				toggler = {
					line = "<leader>cc<space>",
					block = "<leader>c<space>",
				},
				opleader = {
					line = "<leader>cc<space>",
					block = "<leader>c<space>",
				},
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},
}

LazyOpts = {}

require("lazy").setup(LazyPlugins, LazyOpts)
