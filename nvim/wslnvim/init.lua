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
	
	-- Tree-sitter
	{
  	    "nvim-treesitter/nvim-treesitter",
	    branch = "master",
  	    build = ":TSUpdate",
  	    lazy = false,
	},

}, { checker = { enabled = false } })





-- Editor settings --
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.title = true
vim.opt.wrap = false
vim.opt.encoding = 'utf-8'
vim.opt.termguicolors = true

vim.opt.foldcolumn = "1"
vim.opt.fillchars:append({
  eob = ' ',
})

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.scrolloff = 8



-- Tab engine
local tab_config = {
  text = 2,
  python = 4,
  cpp = 2,
  javascript = 2,
  typescript = 2,
  html = 2,
  lua = 2,
  rust = 4,
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.tbl_keys(tab_config),
  callback = function(args)
    local size = tab_config[vim.bo[args.buf].filetype]

    vim.opt_local.tabstop = size
    vim.opt_local.shiftwidth = size
    vim.opt_local.softtabstop = size
    vim.opt_local.expandtab = true
  end,
})



vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true

vim.opt.guicursor = "n-v-c:block"

local group = vim.api.nvim_create_augroup("CursorShape", {})

vim.api.nvim_create_autocmd("InsertEnter", {
  group = group,
  callback = function()
    vim.opt.guicursor = ""
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = group,
  callback = function()
    vim.opt.guicursor = "n-v-c:block"
  end,
})






-- Keymap settings --
-- Brackets keymap --
vim.keymap.set('i', '{', '{}<Left>', { noremap = true })
vim.keymap.set('i', '{{', '{', { noremap = true })
vim.keymap.set('i', '{}', '{}', { noremap = true })

vim.keymap.set('i', '{<CR>', function()
  return '{<CR>}<Esc>O'
end, { expr = true, noremap = true })

-- Shortcut --
vim.keymap.set('n', '<C-a>', 'gg0vG$', { noremap = true, silent = true })
vim.keymap.set('i', '<C-a>', '<Esc>gg0vG$', { noremap = true, silent = true })

vim.keymap.set('n', '<S-Tab>', ':tabnext<CR>', { noremap = true, silent = true })

-- Terminal toggle
vim.keymap.set("n", "<F2>", function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)

		if vim.bo[buf].buftype == "terminal" then
			vim.api.nvim_win_close(win, true)
			return
		end
	end

	vim.cmd("botright 20split")
	vim.cmd("terminal")
	vim.cmd("startinsert")
end, { desc = "Toggle terminal" })






-- Build and Run --
-- Save, compile, run
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
		vim.cmd("startinsert")
        vim.cmd("vsplit | terminal time " .. exe .. " < " .. vim.fn.shellescape(inp))
    else
		vim.cmd("startinsert")
        vim.notify("Input file not found: " .. inp, vim.log.levels.WARN)
    end
end, { desc = "CP: Compile & Run with input file" })

-- F10: save -> compile -> run with manual input
vim.keymap.set("n", "<F10>", function()
	local exe = cp_compile()
		if not exe then
			return
		end
    vim.cmd("vsplit | terminal time " .. exe)
end, { desc = "CP: Compile & Run manually" })






-- Layout for CP
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



vim.opt.showtabline = 1
vim.opt.laststatus = 0
vim.o.statusline = " %F %m%=%L Ln | Row %l, Col %c "






-- Tree-sitter
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "java", "python", "lua" },
    callback = function(args)
        vim.treesitter.start(args.buf)
    end,
})



-- Terminal color
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.wo.winhl = "Normal:TermNormal,NormalNC:TermNormal"
    end,
})






-- Syntax highlight
local M = {}
function M.setup()
	vim.opt.termguicolors = true

	local colors = {
		black = "#000000",
		bright_black = "#808080",
		white = "#EEEEEE",
		bright_white = "#FFFFFF",
		red = "#800000",
		bright_red = "#FF0000",
		green = "#008000",
		bright_green = "#00FF00",
		yellow = "#808000",
		bright_yellow = "#FFFF00",
		blue = "#000080",
		bright_blue = "#00DDFF",
		purple = "#800080",
		bright_purple = "#FF00FF",
		cyan = "#2E8B7C",
		bright_cyan = "#00FFFF",
	}
	local highlight = {
		Normal = { fg=colors.bright_white, bg=colors.blue },
		LineNr = { fg=colors.bright_yellow},
		CursorLine = { bg=colors.cyan },
		Cursor = { bg="#FFFF7F" },
		CursorInsert = { bg="#FFFF7F" },
		CursorReplace = { bg="#FFFF7F" },
		ModeMsg = { fg=colors.cyan, bold=true },
		TermNormal = { fg=colors.bright_white, bg=colors.black },

		Comment = { fg=colors.cyan },
		Constant = { fg=colors.bright_green },
		cConstant = { fg=colors.bright_blue },
		cIncluded = { fg=colors.bright_red },
		Special = { fg=colors.bright_green },
		String = { fg=colors.bright_yellow },

		Keyword = { fg=colors.bright_white },
		Statement = { fg=colors.bright_white },
		Type = { fg=colors.bright_white },
		PreProc = { fg=colors.bright_green },
		Function = { fg=colors.bright_blue },
        Delimiter = { fg=colors.bright_white },
		Identifier = { fg=colors.bright_blue },

		Error = { fg=colors.bright_white, bg=colors.bright_red },
		Todo = { fg=colors.black, bg=colors.yellow },
		Title = { fg=colors.bright_yellow },

		Visual = { fg=colors.black, bg=colors.cyan },
		MatchParen = { fg=colors.bright_red },
		NonText = { fg=colors.bright_blue },
		CurSearch = { fg=colors.black, bg=colors.yellow },

		WarningMsg = { fg=colors.bright_red },
		ErrorMsg = { fg=colors.bright_white, bg=colors.bright_red, bold=true },
		MoreMsg = { fg=colors.cyan },
		Question = { fg=colors.cyan },

		TabLine = { fg=colors.black, bg=colors.cyan },
		TabLineSel = { fg=colors.bright_white, bg=colors.black },
		TabLineFill = { bg=colors.cyan },
		Pmenu = { fg=colors.black, bg=colors.bright_black },
		PmenuSel = { fg=colors.black, bg=colors.cyan },

		Statusline = { fg=colors.bright_white, bg=colors.black },
		StatuslineNC = { fg=colors.black, bg=colors.cyan },



		-- This part is just for who installed Tree-sitter
        -- Tree-sitter: default
        ["@variable"] = { fg=colors.bright_white },
        ["@operator"] = { fg=colors.bright_white },

		-- Tree-sitter: lua
		["@property.lua"] = { fg=colors.bright_white },
		["@variable.member.lua"] = { fg=colors.bright_blue },

		-- Tree-sitter: cpp
		["@function.cpp"] = { fg=colors.bright_white },
		["@type.builtin.cpp"] = { fg=colors.bright_white},
		["@variable.cpp"] = { fg=colors.bright_blue },
		["@character.cpp"] = { fg=colors.bright_yellow },
		["@string.escape.cpp"] = { fg=colors.bright_yellow },
		["@keyword.import.cpp"] = { fg=colors.bright_green },
		["@keyword.directive.cpp"] = { fg=colors.bright_green },
		["@keyword.directive.define.cpp"] = { fg=colors.bright_green },
        ["@boolean.cpp"] = { fg=colors.bright_white },
        ["@function.macro.cpp"] = { fg=colors.bright_green },
		
	}

	for group, opts in pairs(highlight) do
		vim.api.nvim_set_hl(0, group, opts)
	end
    -- Custom Highlighting
    -- CP
    local custom_matches = {
        -- punctuation
        {
            patterns = {
                [[{]],
                [[}]],
                [[;]],
                [[::]],
            },
            fg = colors.bright_yellow,
        },

        -- library
        {
            patterns = {
                -- more library
                [[#include\s\+<\zs[^>]\+\ze>]],
                [[#include\s\+"\zs[^"]\+\ze"]],
            },
            fg=colors.bright_red,
        },

        -- ' and "
        {
            patterns = {
                [[']],
                [["]],
            },
            fg=colors.yellow,
        },

        -- less color on basic i/o c++
        {
            patterns = {
                [[\<cin\>]],
                [[\<cout\>]],
                [[\<printf\>]],
                [[\<scanf\>]],
                [[\<endl\>]],
                [[\<cerr\>]],
                [[\V>>]],
                [[\V<<]],
            },
            fg = colors.bright_white,
        },

    }

    for i, item in ipairs(custom_matches) do
        local group = "CustomHighlight" .. i

        vim.api.nvim_set_hl(0, group, {
            fg = item.fg,
            bg = item.bg,
            bold = item.bold,
            italic = item.italic,
        })

        for _, pattern in ipairs(item.patterns) do
            vim.fn.matchadd(group, pattern, 100)
        end
    end
end

M.setup()


