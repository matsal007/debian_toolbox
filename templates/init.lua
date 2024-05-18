local global = vim.g

global.mapleader = " "
global.maplocalleader = " "

--- A better way for |mapping|.
--- Examples:
--- ```lua
---   -- Map to a Lua function:
---   Map('n', 'lhs', function() print("real lua function") end)
--
---   -- Map to multiple modes:
---   Map({'n', 'v'}, '<leader>lr', vim.lsp.buf.references, { buffer=true })
---   -- Buffer-local mapping:
---   Map('n', '<leader>w', "<cmd>w<cr>", { silent = true, buffer = 5 })
---   -- Expr mapping:
---   Map('i', '<Tab>', function()
---     return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
---   end, { expr = true })
---   -- <Plug> mapping:
---   Map('n', '[%%', '<Plug>(MatchitNormalMultiBackward)')
---   -- Multiple keys for the same map
---   Map('i', {'jk', 'kj'}, '<Esc>', { silent = true })
--- ```
---
---@param mode string|table    Mode short-name, see |nvim_set_keymap()|.
---@param lhs string|table     Left-hand side |{lhs}| of the mapping.
---@param rhs string|function  Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts table|nil A Table of options
function Map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end

	if type(lhs) == "table" then
		for _, sequence in ipairs(lhs) do
			vim.keymap.set(mode, sequence, rhs, options)
		end
	else
		vim.keymap.set(mode, lhs, rhs, options)
	end
end

---Return the given string as Title Case string
---<pre>
---Sample Usage
---titleCase("hello world") -> Hello World
---</pre>
---@param str string
---@return string
local titleCase = function(str)
	return (str:gsub("(%a)([%w_']*)", function(first, rest)
		return first:upper() .. rest:lower()
	end))
end

---Creates a new file with the date in the format of [day-month] within a folder
---of the current month in Title Case i.e [April]
---@param filetype string|nil
function CreateNewFileByDate(filetype)
	if filetype == nil then
		filetype = "md"
	end

	local date = os.date("%d-%m")
	local monthName = os.date("%B")
	local month = ""
	if type(monthName) == "string" then
		month = titleCase(monthName)
	end

	local dirPath = "./" .. month

	if vim.fn.isdirectory(dirPath) == 0 then
		vim.fn.mkdir(dirPath)
	end

	local filepath = dirPath .. "/" .. date .. "." .. filetype
	vim.fn.writefile({}, filepath)
	vim.cmd("edit " .. filepath)
end

local opt = vim.opt

opt.relativenumber = true
opt.number = true
opt.showmode = false
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.breakindent = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.backspace = "indent,eol,start"
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 10
opt.colorcolumn = "90"
opt.undofile = true
opt.updatetime = 25
opt.list = true
opt.listchars = { trail = "·", nbsp = "␣", eol = "󱞣", tab = "  " }
opt.inccommand = "split"

local plugins = {

	{
		"catppuccin/nvim",
		priority = 1000,
		config = function()
			vim.cmd("colorscheme catppuccin-mocha")
			require("catppuccin").setup({
				transparent_background = true,
			})
		end,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 1500
		end,
		opts = {},
	},

	-- lualine

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local lualine = require("lualine")
			local lazy_status = require("lazy.status")

			local colors = {
				blue = "#65D1FF",
				green = "#3EFFDC",
				violet = "#FF61EF",
				yellow = "#FFDA7B",
				red = "#FF4A4A",
				fg = "#c3ccdc",
				bg = "#112638",
				inactive_bg = "#2c3043",
			}

			local my_lualine_theme = {
				normal = {
					a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				insert = {
					a = { bg = colors.green, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				visual = {
					a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				command = {
					a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				replace = {
					a = { bg = colors.red, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.fg },
					c = { bg = colors.bg, fg = colors.fg },
				},
				inactive = {
					a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
					b = { bg = colors.inactive_bg, fg = colors.semilightgray },
					c = { bg = colors.inactive_bg, fg = colors.semilightgray },
				},
			}

			lualine.setup({
				options = {
					theme = my_lualine_theme,
				},
				sections = {
					lualine_x = {
						{
							lazy_status.updates,
							cond = lazy_status.has_updates,
							color = { fg = "#ff9e65" },
						},
						{ "encoding" },
						{ "filetype" },
					},
				},
			})
		end,
	},

	-- BEST PLUGIN
	{
		"ThePrimeagen/harpoon",
		config = function()
			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")

			Map("n", "<leader>a", function()
				mark.add_file()
			end, { desc = "Harpoon add file" })

			Map("n", "<leader>h", function()
				ui.toggle_quick_menu()
			end, { desc = "Harpoon quick menu" })

			for i = 1, 9 do
				Map("n", "<leader>" .. i, function()
					ui.nav_file(i)
				end, { desc = "Harpoon file " .. i })
			end

			Map("n", "<tab>", function()
				ui.nav_next()
			end, { desc = "Harpoon next file" })

			Map("n", "<s-tab>", function()
				ui.nav_prev()
			end, { desc = "Harpoon previous file" })
		end,
	},

	-- Nvim Tree
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			local nvimtree = require("nvim-tree")

			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			nvimtree.setup({

				sort_by = function(nodes)
					table.sort(nodes, function(left, right)
						left = left.name:lower()
						right = right.name:lower()

						local isLeftDir = left.type == "directory"
						local isRightDir = right.type == "directory"

						if isLeftDir and not isRightDir then
							return true
						end

						if left == right then
							return false
						end

						if left:match("^%d+") == nil and right:match("^%d+") == nil then
							return left < right
						end

						local leftNum = tonumber(left:match("^%d+"))
						local rightNum = tonumber(right:match("^%d+"))
						if leftNum and not rightNum then
							return true
						elseif not leftNum and rightNum then
							return false
						end

						if leftNum and rightNum then
							return leftNum < rightNum
						end

						return left < right
					end)
				end,

				view = {
					width = 45,
					relativenumber = true,
				},

				renderer = {
					icons = {
						glyphs = {
							folder = {
								arrow_closed = "",
								arrow_open = "",
							},
						},
					},
				},

				actions = {
					open_file = {
						window_picker = {
							enable = false,
						},
					},
				},

				git = {
					ignore = false,
				},
			})

			local normal = "n"
			local leader = "<leader>"

			Map(normal, leader .. "ee", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })
			Map(
				normal,
				leader .. "ef",
				":NvimTreeFindFileToggle<CR>",
				{ desc = "Toggle File Explorer on Current File" }
			)
			Map(normal, leader .. "er", ":NvimTreeRefresh<CR>", { desc = "Refresh Explorer" })
		end,
	},

	-- Telescope

	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-tree/nvim-web-devicons",
		},

		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					path_display = { "smart" },
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
							["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
						},
					},
				},
			})

			telescope.load_extension("fzf")

			local normal = "n"

			Map(normal, "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
			Map(normal, "<leader>fr", builtin.oldfiles, { desc = "Fuzzy find recent files" })
			Map(normal, "<leader>fs", builtin.live_grep, { desc = "Find string in cwd" })
			Map(normal, "<leader>fc", builtin.grep_string, { desc = "Find string under cursor in cwd" })
			Map(normal, "<leader>ft", ":TodoTelescope<cr>", { desc = "Find todos" })
			Map(normal, "<leader>fh", builtin.help_tags, { desc = "Search help tags" })
			Map(normal, "<leader>fc", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "Find Config Files" })
		end,
	},

	"mbbill/undotree",

	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
}

local normal = "n"
local visual = "v"
local insert = "i"
local leader = "<leader>"

-- Page Move with Cursor Centered
Map({ normal, visual }, "<C-u>", "<C-u>zz")
Map({ normal, visual }, "<C-d>", "<C-d>zz")

-- Executing Lines
Map({ normal }, leader .. "x", ":.lua<cr>", { desc = "Execute Line with Lua" })
Map({ normal, visual }, leader .. "<CR>", ":.!zsh<CR>", { desc = "Run line in Zsh Shell" })

Map({ normal }, leader .. leader .. "x", ":so<cr>", { desc = "Execute the current file" })

-- Save with Control+S
Map(normal, "<C-s>", ":w<CR>", { desc = "Save" })
Map(insert, "<C-s>", "<Esc>:w<CR>", { desc = "Save" })

-- Clear Highlighting
Map(normal, "<Esc>", ":nohl<CR>", { desc = "Clear highlight" })

-- Navigation
Map(normal, "<C-l>", "<C-w>l", { desc = "Go Left a Window" })
Map(normal, "<C-h>", "<C-w>h", { desc = "Go Right a Window" })
Map(normal, "<C-j>", "<C-w>j", { desc = "Go Down a Window" })
Map(normal, "<C-k>", "<C-k>j", { desc = "Go Up a Window" })

-- Window Size Control
Map(normal, "<M-,>", "<C-w>5<")
Map(normal, "<M-.>", "<C-w>5>")
Map(normal, "<M-t>", "<C-w>+")
Map(normal, "<M-s>", "<C-w>-")

-- Close buffers
Map(normal, leader .. "bo", ":%bd<CR><C-o>:bd#<CR>", { desc = "Delete Buffers" })

-- Make it go to Clipboard register
Map({ normal, visual }, leader, '"+', { desc = "To Clipboard register" })

-- Disable Arrow Keys
Map({ normal, visual }, { "<left>", "<right>", "<up>", "<down>" }, '<cmd>echo "Use HJKL to move!!"<CR>')

-- Move Lines
Map(normal, "<A-j>", ":m +1<CR>==", { desc = "Move Line Down" })
Map(normal, "<A-k>", ":m -2<CR>==", { desc = "Move Line Up" })
Map(visual, "<A-j>", ":m '>+1<CR>gv", { desc = "Move Line Down" })
Map(visual, "<A-k>", ":m '<-2<CR>gv", { desc = "Move Line Up" })

-- Indent
Map(visual, ">", ">gv", { desc = "Indent" })
Map(visual, "<", "<gv", { desc = "Unindent" })

Map({ normal, visual }, "<leader>ç", ":s///g<left><left><left>", { silent = false })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	plugins,
}, {
	checker = {
		enable = true,
	},
	change_detection = {
		notify = false,
	},
})
