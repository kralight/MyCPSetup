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

vim.keymap.set('n', '<C-Tab>', ':tabnext<CR>', { noremap = true, silent = true })



local number_toggle_group = vim.api.nvim_create_augroup("NumberToggle", {
    clear = true,
})

local line_number_enabled = true

-- F4: bật/tắt hoàn toàn số dòng
vim.keymap.set("n", "<F4>", function()
    line_number_enabled = not line_number_enabled

    vim.opt.number = line_number_enabled
    vim.opt.relativenumber = line_number_enabled
end, {
    silent = true,
    desc = "Toggle line numbers",
})

-- Vào Insert: tắt relative number
vim.api.nvim_create_autocmd("InsertEnter", {
    group = number_toggle_group,
    callback = function()
        vim.opt.number = line_number_enabled
        vim.opt.relativenumber = false
    end,
})

-- Ra Normal: khôi phục trạng thái F4
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



-- F10: save -> compile -> run with manual input
vim.keymap.set("n", "<F10>", function()
    local exe = cp_compile()
    if not exe then return end

    vim.cmd("split | terminal time " .. exe)
end, { desc = "CP: Compile & Run manually" })






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
		lemon = "#FFFF99",
		lochinvar = "#2e8b7c",
	}
	local highlight = {
		OilDir = { fg=colors.white },
		OilDirIcon = { fg=colors.white },

		Normal = { fg=colors.white, bg=colors.navy },
		LineNr = { fg=colors.lemon},
		Cursor = { fg=colors.black, bg=colors.lemon },
		CursorInsert = { fg=colors.black, bg=colors.lemon },
		CursorReplace = { fg=colors.black, bg=colors.lemon },
		ModeMsg = { fg=colors.cyan, bold=true },
		Identifier = { fg=colors.cyan },
		Delimiter = { fg=colors.lemon },

		Comment = { fg=colors.lochinvar, italic=true },
		Constant = { fg=colors.green },
		String = { fg=colors.lemon },

		Keyword = { fg=colors.red, bold=true },
		Statement = { fg=colors.red, bold=true },
		Type = { fg=colors.white, italic=true },
		PreProc = { fg=colors.green },
		Operator = { fg=colors.lemon },
		Function = { fg=colors.cyan },

		Error = { fg=colors.white, bg=colors.red, bold=true },
		Special = { fg=colors.lemon },
		Todo = { fg=colors.blue, bg=colors.yellow },
		Title = { fg=colors.lochinvar },

		Visual = { fg=colors.black, bg=colors.lochinvar },
		MatchParen = { bg=colors.red },
		NonText = { fg=colors.gray, bold=true },
		CurSearch = { fg=colors.black, bg=colors.yellow },

		WarningMsg = { fg=colors.red, bold=true },
		ErrorMsg = { fg=colors.white, bg=colors.red, bold=true },
		MoreMsg = { fg=colors.lochinvar },
		Question = { fg=colors.lochinvar },

		TabLine = { fg=colors.white, bg=colors.lochinvar },
		TabLineSel = { fg=colors.white, bg=colors.black },
		TabLineFill = { bg=colors.navy },
		Pmenu = { fg=colors.black, bg=colors.gray },
		PmenuSel = { fg=colors.black, bg=colors.lochinvar },

		Statusline = { fg=colors.black, bg=colors.lochinvar },
		StatuslineNC = { fg=colors.black, bg=colors.gray },

		-- Tree-sitter
		["@variable"] = { fg=colors.white },
	}

	for group, opts in pairs(highlight) do
		vim.api.nvim_set_hl(0, group, opts)
	end
end

M.setup()

return M
