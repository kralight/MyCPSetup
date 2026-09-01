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
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.title = true
vim.opt.cursorline = false
vim.opt.wrap = false
vim.opt.encoding = 'utf-8'
vim.opt.termguicolors = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = true


vim.opt.guicursor = {
  "n-v-c:block-Cursor/lCursor-blinkwait1000-blinkon1000-blinkoff250",
  "i-ci:hor25-CursorInsert/lCursor-blinkwait1000-blinkon1000-blinkoff250",
  "r-cr:hor10-CursorReplace",
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

vim.keymap.set('n', '<C-a>', 'gg0vG$', { noremap = true, silent = true })
vim.keymap.set('i', '<C-a>', '<Esc>gg0vG$', { noremap = true, silent = true })

vim.keymap.set('n', 'cp', function()
	require('oil').open('/home/kralight/CP')
end)

vim.keymap.set('n', '<S-Tab>', ':tabnext<CR>', { noremap = true, silent = true })



local number_toggle_group = vim.api.nvim_create_augroup("NumberToggle", {
    clear = true,
})

local line_number_enabled = true

vim.keymap.set("n", "<F4>", function()
    line_number_enabled = not line_number_enabled

    vim.opt.number = line_number_enabled
    vim.opt.relativenumber = line_number_enabled
end, {
    silent = true,
    desc = "Toggle line numbers",
})

vim.api.nvim_create_autocmd("InsertEnter", {
    group = number_toggle_group,
    callback = function()
        vim.opt.number = line_number_enabled
        vim.opt.relativenumber = false
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    group = number_toggle_group,
    callback = function()
        vim.opt.number = line_number_enabled
        vim.opt.relativenumber = line_number_enabled
    end,
})



-- Build and Run --
-- <F9>: Save, compile, run (with .inp file)
local function cp_compile()
    vim.cmd("write")

    local file = vim.fn.expand("%:p")
    local base = vim.fn.expand("%:p:r")
    local exe = "/tmp/" .. vim.fn.expand("%:t:r")

    local cmd = string.format(
        "g++ -std=c++17 -O2 -Wall -Wextra %q -o %q",
        file,
        exe
    )

    local result = vim.fn.system(cmd)

    if vim.v.shell_error ~= 0 then
        vim.notify(result, vim.log.levels.ERROR)
        return nil
    end

    return exe
end

-- F9: save -> compile -> run with <filename>.inp
vim.keymap.set("n", "<F9>", function()
    local exe = cp_compile()
    if not exe then return end

    local inp = vim.fn.expand("%:p:r") .. ".inp"

    if vim.fn.filereadable(inp) == 1 then
        vim.cmd("split | terminal time " .. exe .. " < " .. vim.fn.shellescape(inp))
    else
        vim.notify("Input file not found: " .. inp, vim.log.levels.WARN)
    end
end, { desc = "CP: Compile & Run with input file" })
--
-- F10: save -> compile -> run with manual input
vim.keymap.set("n", "<F10>", function()
	local exe = cp_compile()
		if not exe then
			return
		end
    vim.cmd("split | terminal time " .. exe)
end, { desc = "CP: Compile & Run manually" })





-- Workspace layout
local cpp_layout = vim.api.nvim_create_augroup("CppInputLayout", {

  clear = true,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = cpp_layout,
  pattern = "*.cpp",
  callback = function()
    
    if vim.t.cpp_input_open then
      return
    end

    vim.t.cpp_input_open = true

    local cpp_file = vim.api.nvim_buf_get_name(0)
    local inp_file = vim.fn.fnamemodify(cpp_file, ":r") .. ".inp"

    vim.cmd("rightbelow 70vsplit")
    vim.cmd("wincmd l")
    vim.cmd("edit " .. vim.fn.fnameescape(inp_file))

    vim.cmd("wincmd h")
  end,
})


vim.opt.showtabline = 2
vim.opt.laststatus = 2

vim.o.statusline = table.concat({
  " %F",
  " %m",
  "%=",
  "%L Ln",
  " | Row %l, Col %c ",
})






-- Theme --
local M = {}
function M.setup()
	vim.opt.termguicolors = true

	local colors = {
		black = "#000000",
		bright_black = "#676767",
		white = "#F0F0F0",
		bright_white = "#FFFFFF",
		red = "#BB0000",
		bright_red = "#FF0000",
		green = "#00BB00",
		bright_green = "#00FF00",
		yellow = "#FFFF00",
		bright_yellow = "#FFFF7F",
		blue = "#000080",
		bright_blue = "#00CCFF",
		purple = "#881188",
		bright_purple = "#DD00DD",
		cyan = "#2E8B7C",
		bright_cyan = "#00FFFF",
	}
	local highlight = {
		OilDir = { fg=colors.white },
		OilDirIcon = { fg=colors.white },

		Normal = { fg=colors.white, bg=colors.blue },
		LineNr = { fg=colors.bright_yellow},
		CursorLine = { bg=colors.cyan },
		Cursor = { fg=colors.black, bg=colors.bright_yellow },
		CursorInsert = { fg=colors.black, bg=colors.bright_yellow },
		CursorReplace = { fg=colors.black, bg=colors.bright_yellow },
		ModeMsg = { fg=colors.cyan, bold=true },

		Comment = { fg=colors.cyan, italic=true },
		Constant = { fg=colors.bright_green },
		cConstant = { fg=colors.bright_blue },
		cIncluded = { fg=colors.bright_red },
		Special = { fg=colors.bright_green },
		String = { fg=colors.bright_yellow },

		Keyword = { fg=colors.white },
		Statement = { fg=colors.white },
		Type = { fg=colors.white },
		PreProc = { fg=colors.bright_green },

		Error = { fg=colors.white, bg=colors.bright_red },
		Todo = { fg=colors.black, bg=colors.yellow },
		Title = { fg=colors.bright_yellow },

		Visual = { fg=colors.black, bg=colors.cyan },
		MatchParen = { fg=colors.bright_red },
		NonText = { fg=colors.bright_blue },
		CurSearch = { fg=colors.black, bg=colors.yellow },

		WarningMsg = { fg=colors.bright_red },
		ErrorMsg = { fg=colors.white, bg=colors.bright_red, bold=true },
		MoreMsg = { fg=colors.cyan },
		Question = { fg=colors.cyan },

		TabLine = { fg=colors.black, bg=colors.cyan },
		TabLineSel = { fg=colors.white, bg=colors.black },
		TabLineFill = { bg=colors.cyan },
		Pmenu = { fg=colors.black, bg=colors.bright_black },
		PmenuSel = { fg=colors.black, bg=colors.cyan },

		Statusline = { fg=colors.white, bg=colors.black },
		StatuslineNC = { fg=colors.black, bg=colors.cyan },

		-- Custom CP syntax highlight
		CPOperator = { fg=colors.bright_yellow },
		CPContainer = { fg=colors.bright_blue },
		CPFunction = { fg=colors.bright_blue },
	}

	for group, opts in pairs(highlight) do
		vim.api.nvim_set_hl(0, group, opts)
	end

	
	-- Test operator highlighting
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "c", "cpp" },

		callback = function()
			vim.fn.matchadd(
				"CPOperator",
				[[->\|::\|,\|;\|<\|>\|{\|}]]
			)
			vim.fn.matchadd(
				"CPContainer",
				[[\<\(array\|bitset\|vector\|stack\|queue\|deque\|priority_queue\|forward_list\|list\|set\|multiset\|unordered_set\|unordered_multiset\|map\|multimap\|unordered_map\|unordered_multimap\)\>]]
			)

			vim.fn.matchadd(
				"CPFunction",
				[[\<\(begin\|end\|rbegin\|rend\|size\|length\|sizeof\|empty\|resize\|capacity\|reverse\|assign\|memset\|front\|back\|at\|insert\|erase\|push_back\|pop_back\|push_front\|pop_front\|push\|pop\|clear\|swap\|count\|find\|lower_bound\|upper_bound\)\>]]
			)

		end,
	})

end

M.setup()

return M
