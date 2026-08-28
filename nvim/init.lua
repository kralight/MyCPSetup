-- System settings --
vim.opt.clipboard = 'unnamedplus'






-- PLUGIN MANAGER --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)



require("lazy").setup({
  -- Theme Everforest
  { "sainnhe/everforest", name = "everforest", priority = 1000 },
  -- Oil.nvim
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        columns = { "icon" },
        view_options = { show_hidden = true },
      })
    end,
    keys = {
        { "mo", "<CMD>Oil<CR>", desc = "Open File Manager" },
    },
  },
}, { checker = { enabled = false } })






-- Editor settings --
vim.opt.number = true
vim.opt.relativenumber = true
vim.cmd('syntax on')
vim.opt.title = true
vim.opt.cursorline = false
vim.opt.wrap = false
vim.opt.encoding = 'utf-8'
vim.opt.termguicolors = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.showtabline = 2
vim.opt.laststatus = 1
vim.opt.guifont = "DejaVu Sans Mono:h10"
vim.opt.guicursor = {
  "n-v-c:block-Cursor/lCursor-blinkwait1000-blinkon1000-blinkoff250",
  "i-ci:hor30-CursorInsert/lCursor-blinkwait1000-blinkon1000-blinkoff250",
  "r-cr:hor15-CursorReplace",
}



-- Backup settings --
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true






-- Keymap settings --
-- Brackets keymap --
vim.keymap.set('i', '{', '{}<Left>', { noremap = true })
vim.keymap.set('i', '{{', '{', { noremap = true })
vim.keymap.set('i', '{}', '{}', { noremap = true })

vim.keymap.set('i', '{<CR>', function()
  return '{<CR>}<Esc>O'
end, { expr = true, noremap = true })

-- Windows shortcut --
vim.keymap.set('n', '<C-z>', 'u', { noremap = true, silent = true })
vim.keymap.set('i', '<C-z>', '<Esc>ui', { noremap = true, silent = true })

vim.keymap.set('n', '<C-a>', 'gg0vG', { noremap = true, silent = true })
vim.keymap.set('i', '<C-a>', '<Esc>gg0vG$', { noremap = true, silent = true })

vim.keymap.set('n', 'cp', function()
	require('oil').open('D:/CP/')
end)

-- Numberline mode keymap --
local number_toggle_group = vim.api.nvim_create_augroup([[NumberToggle]], { clear = true })

vim.api.nvim_create_autocmd({ [[InsertLeave]], [[BufEnter]] }, {
    group = number_toggle_group,
    pattern = [[*]],
    command = [[set relativenumber]],
})

vim.api.nvim_create_autocmd({ [[InsertEnter]] }, {
    group = number_toggle_group,
    pattern = [[*]],
    command = [[set norelativenumber]],
})

-- Build and Run --
-- <F9>: Save, compile, run (C++ and Python)
vim.cmd([[
  autocmd FileType cpp nnoremap <buffer> <F9> :w<CR>:execute '!cd /d "' . expand('%:p:h') . '" && g++ -O2 -std=c++17 -Wall -Wextra -Wshadow "' . expand('%:t') . '" -o "' . expand('%:t:r') . '.exe" && start cmd /c ""' . expand('%:p:r') . '.exe" && echo. && echo. & pause"'<CR>
  autocmd FileType python nnoremap <buffer> <F9> :w<CR>:execute '!cd /d "' . expand('%:p:h') . '" && python "' . expand('%:t') . '" && echo.'<CR>
]])






-- Theme --
local M = {}
function M.setup()
	vim.opt.termguicolors = true

	local colors = {
		white = "#FFFFFF",
		black = "#000000",
		gray = "#DFDFDF",
		red = "#FF0000",
		green = "#00FF00",
		blue = "#0000FF",
		yellow = "#FFFF00",
		pink = "#FF00FF",
		purple = "#6A0DAD",
		lavender = "#6A5ACD",
		maroon = "#A52A2A",
		teal = "#2E8B57",
		cyan = "#00FFFF",
		navy = "#000080",
	}
	local highlight = {
		OilDir = { fg=colors.blue },
		OilDirIcon = { fg=colors.blue },

		Normal = { fg=colors.black, bg=colors.white },
		LineNr = { fg=colors.maroon},
		Cursor = { fg=colors.cyan, bg=colors.black },
		ModeMsg = { fg=colors.black, bold=true },
		Identifier = { fg=colors.black },

		Comment = { fg=colors.blue, italic=true },
		Constant = { fg=colors.pink },
		String = { fg=colors.pink },

		Keyword = { fg=colors.maroon, bold=true },
		Statement = { fg=colors.maroon, bold=true},
		Type = { fg=colors.teal, bold=true },
		PreProc = { fg=colors.purple },

		Error = { fg=colors.white, bg=colors.red, bold=true },
		Special = { fg=colors.lavender },
		Todo = { fg=colors.blue, bg=colors.yellow },
		Title = { fg=colors.pink },

		Visual = { bg=colors.gray },
		MatchParen = { bg=colors.cyan },
		NonText = { fg=colors.blue, bold=true },
		CurSearch = { fg=colors.black, bg=colors.yellow },

		WarningMsg = { fg=colors.red, bold=true },
		ErrorMsg = { fg=colors.bg, bg=colors.red, bold=true },
		MoreMsg = { fg=colors.teal },
		Question = { fg=colors.teal },

		TabLine = { fg=colors.white, bg=colors.gray },
		TabLineSel = { fg=colors.black, bg=colors.white },
		TabLineFill = { bg=colors.gray },


		-- Tree-sitter
		["@variable"] = { fg=colors.black },
	}

	for group, opts in pairs(highlight) do
		vim.api.nvim_set_hl(0, group, opts)
	end
end

M.setup()

return M
